import 'package:flutter/material.dart';
import 'package:habitpunk/src/storage/secureStorage.dart';

class DailiesPage extends StatefulWidget {
  @override
  DailiesPage({Key? key}) : super(key: key);
  DailiesPageState createState() => DailiesPageState();
}

class DailiesPageState extends State<DailiesPage> {
  final List<DailyTask> _tasks = [
    ['Morning Workout', '30 mins of cardio', 'false'],
    ['Read a Book', 'Read one chapter of a novel', 'false'],
    ['Meditation', '15 mins session', 'false'],
  ].map((data) => DailyTask.fromJson(data)).toList();
  final GlobalKey<DailiesPageState> dailiesPageKey = GlobalKey();
  String _jwt = "";

  @override
  void initState() {
    super.initState();
    _loadJwt();
  }

  Future<void> _loadJwt() async {
    String? jwt = await SecureStorage().readSecureData('jwt');
    if (jwt != null) {
      setState(() {
        _jwt = jwt;
      });
    }
  }

  void showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Search'),
        content: TextField(
          decoration: InputDecoration(hintText: 'Enter search query'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Perform search action here
              Navigator.pop(context);
            },
            child: Text('Search'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: dailiesPageKey,
      backgroundColor: Color.fromARGB(255, 5, 23, 37),
        appBar: AppBar(
        title: Text('Dailies'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('JWT Token'),
                  content: SelectableText(_jwt.isEmpty ? "No token loaded." : _jwt),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return DailyItem(
            task: task,
            onTap: () {
              setState(() {
                task.completed = !task.completed;
              });
            },
          );
        },
      ),
    );
  }
}

class DailyItem extends StatelessWidget {
  final DailyTask task;
  final VoidCallback onTap;

  const DailyItem({
    Key? key,
    required this.task,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 36, 38, 50), // Background color of the item
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
      ),
      child: ListTile(
        leading: Checkbox(
          value: task.completed,
          onChanged: (value) => onTap(),
        ),
        title: Text(
          task.title,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          task.note,
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}

class DailyTask {
  String title;
  String note;
  bool completed;

  DailyTask({
    required this.title,
    required this.note,
    this.completed = false,
  });

  factory DailyTask.fromJson(List<String> data) {
    return DailyTask(
      title: data[0],
      note: data[1],
      completed: data[2] == 'true',
    );
  }
}
