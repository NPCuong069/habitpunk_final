import 'package:flutter/material.dart';


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

class PartyScreen extends StatefulWidget {
  
  @override
  _PartyScreenState createState() => _PartyScreenState();
}

class _PartyScreenState extends State<PartyScreen> {
  bool hasQuestAssigned = false; // This flag determines which screen to show
  int _selectedSegment = 0; // This will help to determine which segment is currently selected.

  // Add a list for storing chat messages
  List<ChatMessage> chatMessages = [
    ChatMessage(text: 'A new quest has begun!', isSystemMessage: true),
    ChatMessage(text: 'Welcome to the party chat!'),
    ChatMessage(text: 'Hey everyone, let’s coordinate our strategies.'),
  ];

  void _cancelQuest() {
    setState(() {
      hasQuestAssigned = false;
    });
  }

  void _showQuestSelection() {
    // Navigate to the quest selection screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestListScreen(
          onQuestSelected: _selectQuest,
        ),
      ),
    );
  }

  void _selectQuest(String questName) {
    // Handle the selected quest and update the state
    setState(() {
      hasQuestAssigned = true;
      // You may want to save the selected quest name in the state as well
    });
    // Optionally, navigate back to the main party screen after selecting a quest
    Navigator.pop(context);
  }
  void _showQuestDetails() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => QuestDetailsScreen()),
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
              onCancelQuest: _cancelQuest, // Pass the cancel quest function
            )
          : NoQuestScreen(startQuest: _showQuestSelection);
      case 1:
        // Handle 'Members' segment
      return MembersContainer(
        onInvitePressed: () {
          // TODO: Implement the invite members functionality
        },
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

  QuestContainer({required this.onCancelQuest});

  // ... Rest of your code
  @override
  Widget build(BuildContext context) {
    double healthPercentage = 100; // Assuming 100% health for the example
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
                  'The Basi-List',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuestDetailsScreen()),
                    );
                },
              ),
              ElevatedButton(
            onPressed: onCancelQuest,
            child: Text('Cancel Quest'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
            ],
          ),
          SizedBox(height: 16.0),
          Placeholder(fallbackHeight: 100), // Placeholder for quest image
          SizedBox(height: 16.0),
          Text(
            'The Basi-List',
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
              value: healthPercentage / 100,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          ),
          SizedBox(height: 4.0),
          // Health Text and Mechanics
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('100 / 100', style: TextStyle(color: Colors.black)),
              
            ],
          ),
        ],
      ),
    );
  }
}

class QuestDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Replace Quest Name here'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Quit Quest'),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset('assets/quest_icon.png', width: 80, height: 80), // Placeholder for quest icon
            SizedBox(height: 8),
            Text(
              'Replace Quest Name here',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Started by Example User',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Replace quest details here",
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text(
              'Participants 1',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Replace User here'),
            // ... Add more widgets if needed
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

class QuestListScreen extends StatelessWidget {
  final Function(String) onQuestSelected;

  QuestListScreen({Key? key, required this.onQuestSelected}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Replace with your actual list of quests
    final List<String> quests = ['Quest 1', 'Quest 2', 'Quest 3'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Quest'),
      ),
      body: ListView.builder(
        itemCount: quests.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(quests[index]),
            onTap: () => onQuestSelected(quests[index]), // Pass the quest name back
          );
        },
      ),
    );
  }
}

//This is Member section

class MembersContainer extends StatelessWidget {
  final VoidCallback onInvitePressed;
  final VoidCallback onLeavePressed;

  MembersContainer({
    required this.onInvitePressed,
    required this.onLeavePressed,
  });

  final List<Member> members = [
    Member(
      username: 'Piraka',
      avatar: 'assets/avatar_piraka.png',
      level: 14,
      stats: [34, 137, 44],
    ),
    // ... Add other members
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8.0),
        _buildInviteButton(),
        Expanded(
          child: ListView.builder(
            itemCount: members.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildMemberCard(members[index]);
            },
          ),
        ),
        LeavePartyButton(onPressed: onLeavePressed),
      ],
    );
  }

  Widget _buildInviteButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: onInvitePressed,
        child: Text('Invite Members'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // Replace with your color
        ),
      ),
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
                    Text(member.username, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                    Text('Lv ${member.level}', style: TextStyle(color: Colors.grey)),
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

  ChatMessage({required this.text, this.isSystemMessage = false});
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
        widget.messages.add(ChatMessage(text: _messageController.text.trim()));
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
              return ListTile(
                title: Text(message.text),
                subtitle: message.isSystemMessage ? Text('System Message') : null,
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







