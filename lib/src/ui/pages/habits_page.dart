import 'package:flutter/material.dart';

class HabitsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // TODO: Implement settings navigation
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          UserInfo(),
          Expanded(child: HabitList()),
        ],
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Replace with user's avatar image
            radius: 30,
          ),
          SizedBox(width: 16), // Provide some horizontal spacing
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildProgressBarWithIcon('Health', 50, 50, Colors.red, Icons.favorite, '50'),
                SizedBox(height: 4), // Spacing between the bars
                _buildProgressBarWithIcon('Experience', 0, 25, Colors.blue, Icons.star, '0'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBarWithIcon(String label, int value, int maxValue, Color color, IconData icon, String number) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(fontSize: 12)),
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: value / maxValue,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                backgroundColor: color.withOpacity(0.5),
                minHeight: 8, // Set a minHeight for a thicker progress bar
              ),
            ),
            SizedBox(width: 8), // Spacing between the bar and the icon
            Icon(icon, color: color, size: 16),
            SizedBox(width: 4), // Spacing between the icon and the number
            Text(number, style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }
}

class HabitList extends StatelessWidget {
  final List<String> habits = [
    'Tap here to edit this into a bad habit you\'d like to quit',
    'Add a task to HabitPunk',
    'Study a master of the craft',
    'Process email',
    // More static habits can be added here
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: habits.length,
      itemBuilder: (context, index) {
        return HabitItem(habit: habits[index]);
      },
    );
  }
}

class HabitItem extends StatelessWidget {
  final String habit;

  const HabitItem({Key? key, required this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(habit),
      leading: IconButton(
        icon: Icon(Icons.add, color: Colors.green),
        onPressed: () {
          // TODO: Implement habit increment action
        },
      ),
      trailing: Wrap(
        spacing: 12, // space between two icons
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.remove, color: Colors.red),
            onPressed: () {
              // TODO: Implement habit decrement action
            },
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.grey),
            onPressed: () {
              // TODO: Implement habit edit action
            },
          ),
        ],
      ),
    );
  }
}
