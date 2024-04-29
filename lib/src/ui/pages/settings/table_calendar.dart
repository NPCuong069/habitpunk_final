import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HabitCalendarPage extends StatefulWidget {
  final String habitName;

  HabitCalendarPage({required this.habitName});

  @override
  _HabitCalendarPageState createState() => _HabitCalendarPageState();
}

class _HabitCalendarPageState extends State<HabitCalendarPage> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> _kEventSource = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    
    // Fill the _kEventSource Map with your events.
    List<DateTime> dates = [
      DateTime.now().subtract(Duration(days: 1)),
      DateTime.now().subtract(Duration(days: 2)),
      DateTime.now().subtract(Duration(days: 3)),
      // Add more dates with dummy data here
    ];

    for (DateTime date in dates) {
      _kEventSource[date] = [Event('Completed Habit')];
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _kEventSource[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habitName),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarFormat: _calendarFormat,
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedEvents.value = _getEventsForDay(selectedDay);
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            // ... Rest of your TableCalendar setup
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.orange,
                      child: Text(
                        '${value[index]}',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }
}

class Event {
  final String title;

  Event(this.title);

  @override
  String toString() => title;
}
