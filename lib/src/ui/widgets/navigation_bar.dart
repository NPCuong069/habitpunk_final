import 'package:flutter/material.dart';

class NavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  NavigationBar({required this.currentIndex, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 6.0,
      color: Color.fromARGB(255,14,31,46),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          buildTabItem(
            index: 0,
            icon: Icon(Icons.work),
            label: 'Habits',
          ),
          buildTabItem(
            index: 1,
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Dailies',
          ),
          buildTabItem(
            index: 2,
            icon: Icon(Icons.checklist),
            label: 'To-Dos',
          ),
          buildTabItem(
            index: 3,
            icon: Icon(Icons.card_giftcard),
            label: 'Rewards',
          ),
          buildTabItem(
            index: 4,
            icon: Icon(Icons.list),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget buildTabItem({
    required int index,
    required Icon icon,
    required String label,
  }) {
    return IconButton(
      icon: icon,
      color: currentIndex == index ? Colors.purple : Colors.grey,
      onPressed: () => onItemSelected(index),
      tooltip: label,
    );
  }
}
