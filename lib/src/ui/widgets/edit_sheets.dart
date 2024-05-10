import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpunk/src/model/daily.dart';
import 'package:habitpunk/src/model/notification.dart';
import 'package:habitpunk/src/riverpod/daily_provider.dart';
import 'package:habitpunk/src/riverpod/notification_provider.dart';
import 'package:intl/intl.dart';

class Reminder {
  TimeOfDay time;
  int? notificationId;

  Reminder({required this.time, required this.notificationId});
}

void showEditDailySheet(BuildContext context, WidgetRef ref, Daily daily) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext bc) {
      return FutureBuilder<List<NotificationModel>>(
        future:
            ref.read(notificationProvider).fetchNotificationsByDaily(daily.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Reminder> _reminders = snapshot.data!
                .map((notification) => Reminder(
                    time: TimeOfDay(
                      hour: int.parse(notification.scheduledTime.split(':')[0]),
                      minute:
                          int.parse(notification.scheduledTime.split(':')[1]),
                    ),
                    notificationId: notification
                        .id // Assuming each notification has an 'id' field
                    ))
                .toList();
            return _buildEditSheet(context, ref, daily, _reminders);
          } else {
            return _buildEditSheet(context, ref, daily, []);
          }
        },
      );
    },
  );
}

Widget _buildEditSheet(BuildContext context, WidgetRef ref, Daily daily,
    List<Reminder> _reminders) {
  List<bool> _difficultySelection =
      List.generate(4, (index) => index == daily.difficulty);
  TextEditingController _titleController =
      TextEditingController(text: daily.title);
  TextEditingController _notesController =
      TextEditingController(text: daily.note);

  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setModalState) {
      void _selectTime(BuildContext context, int? index) async {
        // Optional index parameter
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: index != null && index < _reminders.length
              ? _reminders[index].time
              : TimeOfDay.now(),
        );

        if (picked != null) {
          setModalState(() {
            if (index != null && index < _reminders.length) {
              // Create a new Reminder with the updated time and the existing notificationId
              Reminder updatedReminder = Reminder(
                  time: picked,
                  notificationId: _reminders[index].notificationId);
              // Replace the existing reminder with the updated one
              _reminders[index] = updatedReminder;
            } else {
              // Create a new Reminder (assuming a default or new notificationId is handled here)
              Reminder newReminder = Reminder(
                  time: picked,
                  notificationId:
                      null // You'll need to determine how to generate or retrieve this ID
                  );
              // Add the new reminder to the list
              _reminders.add(newReminder);
            }
          });

          // Format the time as a string "HH:mm"
          String formattedTime =
              "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";

          // Prepare and send the notification
          final notification = NotificationModel(
            deviceType: 'mobile', // Placeholder, adjust as necessary
            content: daily.title,
            dailyId: daily.id, // Assuming 'daily' is available in this scope
            scheduledTime: formattedTime, // Only time part as a string
          );

          // Assuming 'notificationProvider' is properly set up to handle this
          ref.read(notificationProvider).addNotification(notification);
        }
      }

      return DraggableScrollableSheet(
        initialChildSize: 0.9, // starts at 90% of the screen height
        minChildSize: 0.5, // can't shrink below 50% of the screen height
        maxChildSize: 1, // can expand to full screen
        expand: false, // Set to false so it doesn't remain expanded
        builder: (_, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Container(
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
                      'Edit Daily',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _titleController,
                    enabled: false,
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
                              Text('Easy',
                                  style: TextStyle(color: Colors.white)),
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
                              Text('Hard',
                                  style: TextStyle(color: Colors.white)),
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
                        // Reset all to false
                        _difficultySelection
                            .setAll(0, [false, false, false, false]);
                        // Set selected index to true
                        _difficultySelection[index] = true;
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
                            _reminders[i].time.hour,
                            _reminders[i].time.minute)),
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.white),
                        onPressed: () async {
                          try {
                            await ref
                                .read(notificationProvider)
                                .deleteNotification(_reminders[i].notificationId);
                            setModalState(() {
                              _reminders.removeAt(
                                  i); // Update UI to reflect the deletion
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Failed to delete notification: ${e.toString()}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                      onTap: () => _selectTime(context, i),
                    ),
                  ListTile(
                    title: Text('New reminder',
                        style: TextStyle(color: Colors.white)),
                    leading: Icon(Icons.alarm_add, color: Colors.white),
                    onTap: () => _selectTime(
                        context, null), // Pass null for new reminder
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: Text('Update Daily'),
                        onPressed: () {
                          Daily updatedDaily = Daily(
                            id: daily.id,
                            title: _titleController.text,
                            note: _notesController.text,
                            difficulty: _difficultySelection
                                .indexWhere((element) => element),
                          );
                          ref
                              .read(dailyProvider.notifier)
                              .updateDaily(daily.id, updatedDaily);
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Background color
                        ),
                        child: Text('Delete Daily'),
                        onPressed: () {
                           Daily(
                            id: '',
                            title: _titleController.text,
                            note: _notesController.text,
                            difficulty: _difficultySelection
                                .indexWhere((element) => element),
                          );
                          ref
                              .read(dailyProvider.notifier)
                              .deleteDaily(daily.id);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
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
