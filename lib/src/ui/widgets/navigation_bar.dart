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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          buildTabItem(
            index: 0,
            icon: Icon(Icons.home),
            label: 'Habits',
          ),
          buildTabItem(
            index: 1,
            icon: Icon(Icons.view_agenda),
            label: 'Dailies',
          ),

          buildTabItem(
            index: 2,
            icon: Icon(Icons.shop),
            label: 'Customizations',
          ),
          buildTabItem(
            index: 3,
            icon: Icon(Icons.card_giftcard),
            label: 'Rewards',
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
