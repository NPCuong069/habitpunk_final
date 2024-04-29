import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpunk/src/model/party.dart';
import 'package:habitpunk/src/model/quest.dart';
import 'package:habitpunk/src/riverpod/invitation_provider.dart';
import 'package:habitpunk/src/riverpod/party_quest_provider.dart';
import 'package:habitpunk/src/riverpod/quest_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpunk/src/model/user.dart';
import 'package:habitpunk/src/riverpod/user_provider.dart';
import 'package:habitpunk/src/ui/pages/noparty_page.dart';
import 'package:habitpunk/src/ui/widgets/user_party.dart'; // Import NoPartyPage
import 'package:habitpunk/src/riverpod/party_provider.dart';

class PartyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quest',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PartyScreen(),
    );
  }
}

class PartyScreen extends ConsumerStatefulWidget {
  @override
  _PartyScreenState createState() => _PartyScreenState();
}

class _PartyScreenState extends ConsumerState<PartyScreen> {
  bool hasQuestAssigned = false; // This flag determines which screen to show
  int _selectedSegment =
      0; // This will help to determine which segment is currently selected.
  String? partyId;
  Party? currentParty;
  Quest? currentQuest;
  @override
  void initState() {
    super.initState();
    ref.read(partyProvider.notifier).fetchParties();
  }

  void fetchPartyInfo() async {
    final partyNotifier = ref.read(partyProvider.notifier);
    await partyNotifier
        .fetchParties(); // Assuming this method fetches and updates the state.

    // Now let's listen to the state to get the latest party info.
    var partyList = ref.watch(partyProvider);
    if (partyList.isNotEmpty) {
      setState(() {
        partyId = partyList[0]
            .id; // Assuming the first party in the list is the desired one.
      });
    } else {
      print("No party found, cannot set partyId");
    }
  }

  List<ChatMessage> chatMessages = [
    ChatMessage(text: 'A new quest has begun!', isSystemMessage: true),
    ChatMessage(text: 'Welcome to the party chat!'),
    ChatMessage(
        text: 'Hey everyone, let’s coordinate our strategies.',
        username: "User2"),
    ChatMessage(
        text: 'This is user chat', isUserMessage: true, username: "User1"),
  ];

  void _cancelQuest() {
    setState(() {
      hasQuestAssigned = false;
    });
  }

  void _showQuestSelection() {
    ref.read(questProvider.notifier).fetchQuests();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestListScreen(
          onQuestSelected: _selectQuest,
        ),
      ),
    );
  }

  void _selectQuest(Quest quest) async {
    if (partyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("No party selected. Please select a party first.")),
      );
      return;
    }
    final partyQuestService = ref.read(partyQuestProvider);
    bool result = await partyQuestService.addPartyQuest(partyId!, quest.id);
    if (result) {
      // Handle success
      setState(() {
        hasQuestAssigned =
            true; // You may want to save the selected quest name or details in the state as well
      });
      Navigator.pop(context);
    } else {
      // Handle failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to assign quest to party")),
      );
    }
  }

  void _showQuestDetails() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => QuestDetailsScreen(party: currentParty!)),
    );
    if (result == false) {
      setState(() {
        hasQuestAssigned = false;
      });
    }
  }

  Widget _buildSelectedSegment() {
    switch (_selectedSegment) {
      case 0:
        // Show 'No Quest Assigned' or 'Quest Container' based on whether a quest is assigned
        return hasQuestAssigned
            ? QuestContainer(
                party: currentParty!,
                onCancelQuest: _cancelQuest, // Pass the cancel quest function
              )
            : NoQuestScreen(startQuest: _showQuestSelection);
      case 1:
        // Handle 'Members' segment
        return MembersContainer(
          onLeavePressed: () {
            // TODO: Implement the leave party functionality
          },
        );
      case 2:
        return ChatContainer(messages: chatMessages);
      //return ChatContainer(messages: const []);
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<List<Party>?>(partyProvider, (_, partyList) {
      if (partyList != null && partyList.isNotEmpty) {
        Party party = partyList[0];
        if (party.questId != null) {
          setState(() {
            hasQuestAssigned = true;
            currentParty = party; // Update the current party data
          });
        } else {
          setState(() {
            hasQuestAssigned = false;
          });
        }
      }
    });

    final partyNotifier = ref.read(partyProvider.notifier);
    partyNotifier.fetchParties(); // Trigger fetching parties
    return Scaffold(
      body: Column(
        children: [
          // Segment control for Quest and Members.
          // Replace this with your preferred package or custom segment control.
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSegmentButton('Quest', 0),
                _buildSegmentButton('Members', 1),
                _buildSegmentButton('Chat', 2),
              ],
            ),
          ),
          Expanded(
            child: _buildSelectedSegment(),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedSegment = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          color: _selectedSegment == index ? Colors.grey[300] : Colors.white,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _selectedSegment == index ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

// Replace the following placeholders with your own custom widgets and data.
class QuestContainer extends StatelessWidget {
  final VoidCallback onCancelQuest;
  final Party party;
  QuestContainer({required this.party, required this.onCancelQuest});

  // ... Rest of your code
  @override
  Widget build(BuildContext context) {
// Assuming 100% health for the example
    String questName = party.questName ?? 'Unnamed Quest';
    int currentHp = party.hp ?? 0;
    int maximumHp = party.maxHp ?? 100;
    int currentBreak = party.breakPoints ?? 0;
    int maxBreak = party.maxBreak ?? 100;
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Quest Header with Image, Title, and Chevron
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.image, size: 40), // Placeholder for quest logo
              SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  questName,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QuestDetailsScreen(party: party)),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Image.asset('assets/images/bosses/boss_00${party.questId}.png',
              width: 80, height: 80), // Placeholder for quest image
          SizedBox(height: 16.0),
          Text(
            party.questName!,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          // Health Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              minHeight: 20,
              backgroundColor: Colors.grey[300],
              value: currentHp / maximumHp,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          ),
          SizedBox(height: 4.0),
          // Health Text and Mechanics
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$currentHp / $maximumHp',
                  style: TextStyle(color: Colors.black)),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              minHeight: 20,
              backgroundColor: Colors.grey[300],
              value: currentBreak / maxBreak,
              valueColor: AlwaysStoppedAnimation<Color>(
                  const Color.fromARGB(255, 14, 31, 46)),
            ),
          ),
          SizedBox(height: 4.0),
          // Health Text and Mechanics
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$currentBreak / $maxBreak',
                  style: TextStyle(color: Colors.black)),
            ],
          ),
          SizedBox(height: 18.0),
          ElevatedButton(
            onPressed: onCancelQuest,
            child: Text('Cancel Quest'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: Size(50, 40),
            ),
          ),
        ],
      ),
    );
  }
}

class QuestDetailsScreen extends StatelessWidget {
  final Party party;
  QuestDetailsScreen({required this.party});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quest details'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Quit Quest'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset('assets/images/bosses/boss_00${party.questId}.png',
                width: 100, height: 100), // Placeholder for quest icon
            SizedBox(height: 8),
            Text(
              party.questName!,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              party.questDescription!,
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text(
              'Rewards',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Coins:' + party.questReward.toString()),
            Text('Exp: ' + party.questXP.toString()),
          ],
        ),
      ),
    );
  }
}


class LeavePartyButton extends StatelessWidget {
  final VoidCallback onPressed;

  LeavePartyButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text('Leave Party'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red, // Background color
      ),
    );
  }
}

class NoQuestScreen extends StatelessWidget {
  final VoidCallback startQuest;

  NoQuestScreen({required this.startQuest});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No Quest Assigned'),
          ElevatedButton(
            onPressed: startQuest,
            child: Text('Start a Quest'),
          ),
          // Add other elements from the first image as needed
        ],
      ),
    );
  }
}

class QuestListScreen extends ConsumerWidget {
  final Function(Quest) onQuestSelected;

  QuestListScreen({Key? key, required this.onQuestSelected}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quests = ref.watch(questProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Quest'),
      ),
      body: ListView.builder(
        itemCount: quests.length,
        itemBuilder: (context, index) {
          final quest = quests[index];
          return ListTile(
            leading: Image.asset('assets/images/bosses/boss_00${quest.id}.png'),
            title: Text(quest.name),
            onTap: () => onQuestSelected(quest), // Pass the quest object back
          );
        },
      ),
    );
  }
}

//This is Member section

class MembersContainer extends ConsumerWidget {
  final VoidCallback onLeavePressed;

  MembersContainer({
    required this.onInvitePressed,
    required this.onLeavePressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(height: 8.0),
        _buildInviteButton(context, ref),
        Expanded(
          child: Column(
            children: <Widget>[
              // Show the UserStatusCard at the top of the selected pages
                const UserStatusCard(), // Updated to use Riverpod to fetch data
            ],
          ),
        ),
        LeavePartyButton(
            onPressed: () => ref.read(partyProvider.notifier).leaveParty()),
      ],
    );
  }

  Widget _buildInviteButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () =>
            _showInviteMemberDialog(context, ref), // Updated this line
        child: Text('Invite Members'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // Replace with your color
        ),
      ),
    );
  }

  void _showInviteMemberDialog(BuildContext context, WidgetRef ref) {
    TextEditingController _userNameController = TextEditingController();
    // Define a variable for error message.
    String errorMessage = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Add this StatefulBuilder to set state locally inside the dialog
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      margin: EdgeInsets.only(
                          top: 15,
                          right: 40,
                          left: 40), // adjusted for the 'X' button
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Invite Member',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          SizedBox(height: 15),
                          TextField(
                            controller: _userNameController,
                            decoration: InputDecoration(
                              labelText: 'User Name',
                              border: OutlineInputBorder(),
                              errorText: errorMessage.isNotEmpty
                                  ? errorMessage
                                  : null, // Use the error message
                            ),
                          ),
                          SizedBox(height: 24),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () async {
                                if (_userNameController.text.isEmpty) {
                                  setState(() {
                                    errorMessage = 'Please enter a username';
                                  });
                                } else {
                                  bool inviteSent = await ref
                                      .read(invitationProvider.notifier)
                                      .createInvitation(
                                          _userNameController.text);
                                  if (inviteSent) {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          'Invite sent to ${_userNameController.text}'),
                                      backgroundColor: Colors.green,
                                    ));
                                  } else {
                                    setState(() {
                                      errorMessage =
                                          'Failed to send invite. Please try again.';
                                    });
                                    print('Invitation failed to send.');
                                  }
                                }
                              },
                              child: Text('Add',
                                  style: TextStyle(color: Colors.blue)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: -40.0,
                      top: -40.0,
                      child: InkResponse(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: CircleAvatar(
                          child: Icon(Icons.close, color: Colors.white),
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMemberCard(Member member) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(member.avatar, width: 50, height: 50),
                SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(member.username,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold)),
                    Text('Lv ${member.level}',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.0),
            _buildStatsBar(member.stats[0], Colors.red, 'XP'),
            _buildStatsBar(member.stats[1], Colors.blue, 'HP'),
            _buildStatsBar(member.stats[2], Colors.yellow, 'MP'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsBar(int value, Color color, String label) {
    return Row(
      children: [
        Text(label),
        SizedBox(width: 8.0),
        Expanded(
          child: LinearProgressIndicator(
            value: value.toDouble(),
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        SizedBox(width: 8.0),
        Text('$value'),
      ],
    );
  }
}

class Member {
  final String username;
  final String avatar;
  final int level;
  final List<int> stats;

  Member({
    required this.username,
    required this.avatar,
    required this.level,
    required this.stats,
  });
}

//This is Chat Section

class ChatMessage {
  String text;
  bool isSystemMessage;
  bool isUserMessage;
  String username;
  ChatMessage(
      {required this.text,
      this.isSystemMessage = false,
      this.isUserMessage = false,
      this.username = ""});
}

class ChatContainer extends StatefulWidget {
  final List<ChatMessage> messages;

  ChatContainer({Key? key, required this.messages}) : super(key: key);

  @override
  _ChatContainerState createState() => _ChatContainerState();
}

class _ChatContainerState extends State<ChatContainer> {
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        widget.messages.add(ChatMessage(
          text: _messageController.text.trim(),
          isUserMessage: true, // Assuming all sent messages are by the user
          username: "Me", // Placeholder for the actual user's name
        ));
        _messageController.clear();
      });
      // Here you would also send the message to the backend or server.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.messages.length,
            itemBuilder: (context, index) {
              final message = widget.messages[index];
              return Align(
                alignment: message.isUserMessage
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color:
                        message.isUserMessage ? Colors.blue : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: message.isUserMessage
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.username,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(message.text),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
