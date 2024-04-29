import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:table_calendar/table_calendar.dart';

class AnalyticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy data for total positive and negative clicks
    final int totalPosClicks = 120; // Example positive clicks count
    final int totalNegClicks = 30; // Example negative clicks count

    // Dummy data for the habit streak
    final int habitStreak = 5; // Example streak count

    // Example list of habits
  final List<String> habits = [
    "Meditate in the morning",
    "Daily Jogging",
    "Read a book",
    // Add more habits here
  ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView( // Enables scrolling when more widgets are added to the column
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Card for Habit Clicks Overview
              Card(
                elevation: 4,
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Habit Clicks Overview',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AspectRatio(
                        aspectRatio: 1,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: (totalPosClicks > totalNegClicks ? totalPosClicks : totalNegClicks).toDouble(),
                            barTouchData: BarTouchData(enabled: false),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (double value, TitleMeta meta) {
                                    final textStyle = TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    );
                                    String text;
                                    switch (value.toInt()) {
                                      case 0:
                                        text = 'Positive';
                                        break;
                                      case 1:
                                        text = 'Negative';
                                        break;
                                      default:
                                        text = '';
                                        break;
                                    }
                                    return Padding(padding: EdgeInsets.only(top: 10), child: Text(text, style: textStyle));
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (double value, TitleMeta meta) {
                                    return Text(
                                      '${value.toInt()}',
                                      style: TextStyle(color: Colors.white, fontSize: 14),
                                    );
                                  },
                                ),
                              ),
                            ),
                            gridData: FlGridData(show: false),
                            borderData: FlBorderData(show: true, border: Border.all(color: Colors.white)),
                            barGroups: [
                              BarChartGroupData(
                                x: 0,
                                barRods: [BarChartRodData(toY: totalPosClicks.toDouble(), color: Colors.green)],
                              ),
                              BarChartGroupData(
                                x: 1,
                                barRods: [BarChartRodData(toY: totalNegClicks.toDouble(), color: Colors.red)],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20), // Spacing between cards
              // Card for Current Streak
              Card(
                elevation: 4,
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Streak',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          '$habitStreak Days',
                          style: TextStyle(
                            fontSize: 48,
                            color: Colors.lightBlueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                        child: const Text(
                          'Keep it up!',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
              elevation: 4,
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Habit',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    // Scrollable list of habits
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(), // to disable ListView's scrolling
                      itemCount: habits.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            habits[index],
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            // Navigate to the HabitCalendarPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HabitCalendarPage(habitName: habits[index]),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
              // ... Add more cards for additional analytics as needed
            ],
          ),
        ),
      ),
    );
  }
}

class HabitCalendarPage extends StatelessWidget {
  final String habitName;

  HabitCalendarPage({required this.habitName});

  @override
  Widget build(BuildContext context) {
    // Dummy data for the days the habit was done
    final kEvents = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll({
        DateTime.now().subtract(Duration(days: 1)): ['Completed Habit'],
        DateTime.now().subtract(Duration(days: 2)): ['Completed Habit'],
        DateTime.now().subtract(Duration(days: 3)): ['Completed Habit'],
        // Add more dates here
      });

    return Scaffold(
      appBar: AppBar(
        title: Text(habitName),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: DateTime.now(),
        eventLoader: (day) => kEvents[day] ?? [],
        calendarStyle: CalendarStyle(
          markerDecoration: BoxDecoration(
            color: Colors.pink,
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleTextStyle: TextStyle(color: Colors.white),
          leftChevronIcon: Icon(Icons.arrow_back_ios, color: Colors.white),
          rightChevronIcon: Icon(Icons.arrow_forward_ios, color: Colors.white),
          decoration: BoxDecoration(
            color: Colors.black,
          ),
        ),
        // ... other properties
      ),
    );
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }
}