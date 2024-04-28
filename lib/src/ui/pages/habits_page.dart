import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpunk/src/riverpod/habit_provider.dart';
import 'package:habitpunk/src/storage/SecureStorage.dart';

class HabitsPage extends ConsumerStatefulWidget {
  @override
  HabitsPageState createState() => HabitsPageState();
}

class HabitsPageState extends ConsumerState<HabitsPage> {
  String _jwt = "";
  @override
  void initState() {
    super.initState();
    _loadJwtAndDailies();
  }

  Future<void> _onRefresh() async {
    await _loadJwtAndDailies(); // Re-fetch the dailies when pulled to refresh
  }

  Future<void> _loadJwtAndDailies() async {
    String? jwt = await SecureStorage().readSecureData('deviceToken');
    if (jwt != null) {
      setState(() {
        _jwt = jwt;
      });
      ref.read(habitProvider.notifier).fetchHabits();
    }
  }

  @override
  Widget build(BuildContext context) {
    final habits = ref.watch(habitProvider);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 20),
          itemCount: habits.length,
          itemBuilder: (context, index) {
            final habit = habits[index];
            return HabitItem(
              title: habit.title,
              note: habit.note,
              habitId: habit.id,
              onPositive: () =>
                  performHabitAction(context, ref, habit.id, 'positive'),
              onNegative: () =>
                  performHabitAction(context, ref, habit.id, 'negative'),
            );
          },
        ),
      ),
    );
  }
}

void performHabitAction(
    BuildContext context, WidgetRef ref, String habitId, String action) async {
  try {
    await ref.read(habitProvider.notifier).performAction(habitId, action);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Complete habit successfully"),
      duration: Duration(seconds: 2),
    ));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Failed to perform action: $e"),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    ));
  }
}

class HabitItem extends StatelessWidget {
  final String title;
  final String note;
  final String habitId;
  final VoidCallback onPositive;
  final VoidCallback onNegative;

  const HabitItem({
    Key? key,
    required this.title,
    required this.note,
    required this.habitId,
    required this.onPositive,
    required this.onNegative,
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
                    onPressed: onPositive,
                  ),
                ),
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
                    onPressed: onNegative,
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
