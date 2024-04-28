import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:habitpunk/src/riverpod/habit_provider.dart';
import 'package:habitpunk/src/riverpod/habit_provider.dart';
// ... other imports as necessary

class AnalyticsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the habit data from the provider
    final habitData = ref.watch(habitProvider);
    // If you want to trigger fetching the habits when the page loads:
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(habitProvider.notifier).fetchHabits();
    // });

    // This is dummy data for our chart
    final List<FlSpot> habitSpots = habitData
      .map((habit) {
        // Convert your timestamp to DateTime if necessary
     
        final double x = (habit.negClicks ?? 0).toDouble();
        final double y = (habit.posClicks ?? 0).toDouble(); // Assuming posClicks is an int and can be null
        return FlSpot(x, y);
      })
      .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: habitSpots.isEmpty
            ? Text(
                'No habit data available.',
                style: TextStyle(color: Colors.white),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    minX: habitSpots.first.x,
                    maxX: habitSpots.last.x,
                    minY: 0,
                    maxY: habitSpots.map((spot) => spot.y).reduce(
                          (value, element) => value > element ? value : element,
                        ),
                    lineBarsData: [
                      LineChartBarData(spots: habitSpots),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
