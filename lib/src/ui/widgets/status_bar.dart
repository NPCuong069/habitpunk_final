import 'package:flutter/material.dart';

class StatBar extends StatelessWidget {
  final String label;
  final int value;
  final int maxValue;
  final Color color;
  final IconData icon;

  const StatBar({
    Key? key,
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          SizedBox(width: 4),
          Expanded(
            child: LinearProgressIndicator(
              value: value / maxValue.toDouble(),
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          SizedBox(width: 4),
          Text('$value / $maxValue', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

AppBar buildAppBar() {
  return AppBar(
        centerTitle: true,

        backgroundColor: Color.fromARGB(255, 5, 23, 37),
        title: Text('Dailies', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19,  color: Colors.white),),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
            },
          ),
        ],
      );
}
