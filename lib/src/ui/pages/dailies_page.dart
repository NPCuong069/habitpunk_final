import 'package:flutter/material.dart';
import 'setting_page.dart';

class DailiesPage extends StatefulWidget {
  @override
  _DailiesPageState createState() => _DailiesPageState();
}

class _DailiesPageState extends State<DailiesPage> {
  final List<Task> _tasks = [
    Task(
        title: "Morning Workout",
        description: "30 mins of cardio",
        completed: false),
    Task(
        title: "Read a Book",
        description: "Read one chapter of a novel",
        completed: false),
    Task(title: "Meditation", description: "15 mins session", completed: false),
  ];

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 5, 23, 37),
    
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ListTile(
            leading: Checkbox(
              value: task.completed,
              onChanged: (bool? value) {
                setState(() {
                  task.completed = value ?? false;
                });
              },
            ),
            title: Text(task.title),
            subtitle: Text(task.description),
          );
        },
      ),
    );
  }
}



class Task {
  String title;
  String description;
  bool completed;

  Task(
      {required this.title, required this.description, this.completed = false});
}
