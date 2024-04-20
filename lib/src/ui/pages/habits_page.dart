import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HabitsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(child: HabitList()),
        ],
      ),
    );
  }
}

class HabitList extends StatelessWidget {
  final List<Map<String, String>> habits = [
    {
      'title': 'Tap here to edit this into a bad habit you\'d like to quit',
      'note': 'Additional note for the habit 1',
    },
    {
      'title': 'Add a task to HabitPunk',
      'note': 'Additional note for the habit 2',
    },
    {
      'title': 'Study a master of the craft',
      'note': 'Additional note for the habit 3',
    },
    {
      'title': 'Process email',
      'note': 'Additional note for the habit 4',
    },
    {
      'title': 'Process email',
      'note': 'Additional note for the habit 4',
    },
    {
      'title': 'Process email',
      'note': 'Additional note for the habit 4',
    },
    // More static habits can be added here
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: habits.length,
      itemBuilder: (context, index) {
        return HabitItem(
          title: habits[index]['title']!,
          note: habits[index]['note']!,
        );
      },
    );
  }
}

class HabitItem extends StatelessWidget {
  final String title;
  final String note;

  const HabitItem({
    Key? key,
    required this.title,
    required this.note,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 36, 38, 50), // Background color of the item
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
      ),
      child: Column(
        children: [
          Container(
// Set the height of the container
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Container to wrap the add icon button with a background color
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blue, // Background color for the add icon
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.0), // Top-left corner rounded
                      bottomLeft:
                          Radius.circular(4.0), // Bottom-left corner rounded
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      // TODO: Implement habit increment action
                    },
                  ),
                ),
                // Text content in the middle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                          height: 4.0), // Add some space between title and note
                      Text(
                        note,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
                // Container to wrap the remove icon button with a background color
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.red, // Background color for the remove icon
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4.0), // Top-left corner rounded
                      bottomRight:
                          Radius.circular(4.0), // Bottom-left corner rounded
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.remove, color: Colors.white),
                    onPressed: () {
                      // TODO: Implement habit decrement action
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
