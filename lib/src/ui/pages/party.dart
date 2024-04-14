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
            ? QuestContainer() // Pass in selected quest details to this widget
            : NoQuestScreen(startQuest: _showQuestSelection);
      case 1:
        return MembersContainer(); // Implement this widget to show party members
      //case 2:
        //return ChatContainer(messages: const []); // Implement this to show chat messages
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Party'),
        actions: [
          
        ],
      ),
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

class MembersContainer extends StatelessWidget {
  const MembersContainer({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data representing party members
    final List<Member> members = [
      Member(
        name: 'Piraka',
        username: '@Piraka',
        level: 14,
        avatarUrl: 'path_to_avatar_image',
        progress: MemberProgress(
          currentHealth: 26,
          maxHealth: 50,
          currentExp: 137,
          nextLevelExp: 330,
          currentMana: 44,
          maxMana: 44,
          level: 16,
        ),
      ),
      // ... other members
    ];

    return ListView(
      children: [
        // ... potentially other widgets like Party Challenges button, etc.
        ...members.map((member) => MemberTile(member: member)).toList(),
        LeavePartyButton(
          onPressed: () {
            // Handle leave party logic here
          },
        ),
      ],
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



class MemberTile extends StatelessWidget {
  final Member member;

  const MemberTile({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(member.avatarUrl), // Make sure the asset exists
      ),
      title: Text(member.name),
      subtitle: Text(member.username),
      trailing: MemberProgressIndicator(progress: member.progress),
    );
  }
}

// This widget will represent the health and mana bars
class MemberProgressIndicator extends StatelessWidget {
  final MemberProgress progress;

  MemberProgressIndicator({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // This is important to avoid layout errors
      children: [
        Text('Lvl ${progress.level}'),
        SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress.currentHealth / progress.maxHealth,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
        // You can add a mana bar similarly
      ],
    );
  }
}



// Member model to represent each party member's data
class Member {
  String name;
  String username;
  int level;
  String avatarUrl;
  MemberProgress progress;

  Member({
    required this.name,
    required this.username,
    required this.level,
    required this.avatarUrl,
    required this.progress,
  });
}

class MemberProgress {
  int currentHealth;
  int maxHealth;
  int currentExp;
  int nextLevelExp;
  int currentMana;
  int maxMana;
  int level; // Added level property

  MemberProgress({
    required this.currentHealth,
    required this.maxHealth,
    required this.currentExp,
    required this.nextLevelExp,
    required this.currentMana,
    required this.maxMana,
    required this.level,
  });
}



