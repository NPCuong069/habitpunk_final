import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpunk/src/model/daily.dart';
import 'package:habitpunk/src/model/habit.dart';
import 'package:habitpunk/src/riverpod/daily_provider.dart';
import 'package:habitpunk/src/riverpod/habit_provider.dart';
import 'package:intl/intl.dart';

void showAddDailySheet(BuildContext context, WidgetRef ref) {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  // State for difficulty selection
  List<bool> _difficultySelection = [true, false, false, false];
  List<TimeOfDay> _reminders = [];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext bc) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          void _selectTime(BuildContext context, int? index) async {
            // Optional index parameter
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: index != null && index < _reminders.length
                  ? _reminders[index]
                  : TimeOfDay.now(),
            );
            if (picked != null) {
              setModalState(() {
                if (index != null && index < _reminders.length) {
                  // Update existing reminder
                  _reminders[index] = picked;
                } else {
                  // Add new reminder
                  _reminders.add(picked);
                }
              });
            }
          }

          return Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 5, 23, 37),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Text(
                    'New Daily',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _notesController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Notes',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Difficulty',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                ToggleButtons(
                  borderColor: Colors.transparent,
                  fillColor: Colors.purple.withOpacity(0.5),
                  selectedBorderColor: Colors.purple,
                  selectedColor: Colors.white,
                  splashColor: Colors.purpleAccent,
                  children: <Widget>[
                    Container(
                        width: (MediaQuery.of(context).size.width - 45) / 4,
                        child: Column(
                          children: [
                            Icon(Icons.star,
                                color: _difficultySelection[0]
                                    ? Colors.white
                                    : Colors.grey),
                            Text('Easy', style: TextStyle(color: Colors.white)),
                          ],
                        )),
                    Container(
                        width: (MediaQuery.of(context).size.width - 45) / 4,
                        child: Column(
                          children: [
                            Icon(Icons.star_half,
                                color: _difficultySelection[1]
                                    ? Colors.white
                                    : Colors.grey),
                            Text('Medium',
                                style: TextStyle(color: Colors.white)),
                          ],
                        )),
                    Container(
                        width: (MediaQuery.of(context).size.width - 45) / 4,
                        child: Column(
                          children: [
                            Icon(Icons.star_border,
                                color: _difficultySelection[2]
                                    ? Colors.white
                                    : Colors.grey),
                            Text('Hard', style: TextStyle(color: Colors.white)),
                          ],
                        )),
                    Container(
                        width: (MediaQuery.of(context).size.width - 45) / 4,
                        child: Column(
                          children: [
                            Icon(Icons.stars,
                                color: _difficultySelection[3]
                                    ? Colors.white
                                    : Colors.grey), // For Expert
                            Text('Expert',
                                style: TextStyle(color: Colors.white)),
                          ],
                        )),
                  ],
                  onPressed: (int index) {
                    setModalState(() {
                      for (int buttonIndex = 0;
                          buttonIndex < _difficultySelection.length;
                          buttonIndex++) {
                        _difficultySelection[buttonIndex] =
                            buttonIndex == index;
                      }
                    });
                  },
                  isSelected: _difficultySelection,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Reminders',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                for (var i = 0; i < _reminders.length; i++)
                  ListTile(
                    title: Text(
                      DateFormat('hh:mm a').format(DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          _reminders[i].hour,
                          _reminders[i].minute)),
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.white),
                      onPressed: () {
                        setModalState(() {
                          _reminders.removeAt(i);
                        });
                      },
                    ),
                    onTap: () => _selectTime(context, i),
                  ),
                ListTile(
                  title: Text('New reminder',
                      style: TextStyle(color: Colors.white)),
                  leading: Icon(Icons.alarm_add, color: Colors.white),
                  onTap: () =>
                      _selectTime(context, null), // Pass null for new reminder
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Add Daily'),
                  onPressed: () {
                    final newDaily = Daily(
                      id: '',
                      title: _titleController.text,
                      note: _notesController.text,
                      difficulty:
                          _difficultySelection.indexWhere((element) => element),
                    );
                    ref.read(dailyProvider.notifier).addDaily(newDaily);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

void showAddHabitSheet(BuildContext context, WidgetRef ref) {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  // State for difficulty selection
  List<bool> _difficultySelection = [true, false, false, false];
  List<TimeOfDay> _reminders = [];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext bc) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          void _selectTime(BuildContext context, int? index) async {
            // Optional index parameter
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: index != null && index < _reminders.length
                  ? _reminders[index]
                  : TimeOfDay.now(),
            );
            if (picked != null) {
              setModalState(() {
                if (index != null && index < _reminders.length) {
                  // Update existing reminder
                  _reminders[index] = picked;
                } else {
                  // Add new reminder
                  _reminders.add(picked);
                }
              });
            }
          }

          return Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 5, 23, 37),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Text(
                    'New Habit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _notesController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Notes',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Difficulty',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                ToggleButtons(
                  borderColor: Colors.transparent,
                  fillColor: Colors.purple.withOpacity(0.5),
                  selectedBorderColor: Colors.purple,
                  selectedColor: Colors.white,
                  splashColor: Colors.purpleAccent,
                  children: <Widget>[
                    Container(
                        width: (MediaQuery.of(context).size.width - 45) / 4,
                        child: Column(
                          children: [
                            Icon(Icons.star,
                                color: _difficultySelection[0]
                                    ? Colors.white
                                    : Colors.grey),
                            Text('Easy', style: TextStyle(color: Colors.white)),
                          ],
                        )),
                    Container(
                        width: (MediaQuery.of(context).size.width - 45) / 4,
                        child: Column(
                          children: [
                            Icon(Icons.star_half,
                                color: _difficultySelection[1]
                                    ? Colors.white
                                    : Colors.grey),
                            Text('Medium',
                                style: TextStyle(color: Colors.white)),
                          ],
                        )),
                    Container(
                        width: (MediaQuery.of(context).size.width - 45) / 4,
                        child: Column(
                          children: [
                            Icon(Icons.star_border,
                                color: _difficultySelection[2]
                                    ? Colors.white
                                    : Colors.grey),
                            Text('Hard', style: TextStyle(color: Colors.white)),
                          ],
                        )),
                    Container(
                        width: (MediaQuery.of(context).size.width - 45) / 4,
                        child: Column(
                          children: [
                            Icon(Icons.stars,
                                color: _difficultySelection[3]
                                    ? Colors.white
                                    : Colors.grey), // For Expert
                            Text('Expert',
                                style: TextStyle(color: Colors.white)),
                          ],
                        )),
                  ],
                  onPressed: (int index) {
                    setModalState(() {
                      for (int buttonIndex = 0;
                          buttonIndex < _difficultySelection.length;
                          buttonIndex++) {
                        _difficultySelection[buttonIndex] =
                            buttonIndex == index;
                      }
                    });
                  },
                  isSelected: _difficultySelection,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Reminders',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                for (var i = 0; i < _reminders.length; i++)
                  ListTile(
                    title: Text(
                      DateFormat('hh:mm a').format(DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          _reminders[i].hour,
                          _reminders[i].minute)),
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.white),
                      onPressed: () {
                        setModalState(() {
                          _reminders.removeAt(i);
                        });
                      },
                    ),
                    onTap: () => _selectTime(context, i),
                  ),
                ListTile(
                  title: Text('New reminder',
                      style: TextStyle(color: Colors.white)),
                  leading: Icon(Icons.alarm_add, color: Colors.white),
                  onTap: () =>
                      _selectTime(context, null), // Pass null for new reminder
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Add Habit'),
                  onPressed: () {
                    final newHabit = Habit(
                      id: '',
                      title: _titleController.text,
                      note: _notesController.text,
                      difficulty:
                          _difficultySelection.indexWhere((element) => element),
                    );
                    ref.read(habitProvider.notifier).addHabit(newHabit);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
