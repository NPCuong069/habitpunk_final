import 'package:flutter/material.dart';
// Make sure to create a 'stat_bar.dart' if you haven't already.
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
          Icon(
            icon, // Change this line
            color: color,
            size: 16,
          ),
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
class UserStatusCard extends StatelessWidget {
  final String avatarUrl;
  final int health;
  final int maxHealth;
  final int experience;
  final int nextLevelExp;
  final int mana;
  final int maxMana;
  final int level;
  final String userClass;

  const UserStatusCard({
    Key? key,
    required this.avatarUrl,
    required this.health,
    required this.maxHealth,
    required this.experience,
    required this.nextLevelExp,
    required this.mana,
    required this.maxMana,
    required this.level,
    required this.userClass,
  }) : super(key: key);

 @override
  Widget build(BuildContext context) {
    // Sample data to simulate a user profile
    final String avatarUrl = 'https://via.placeholder.com/150';
    final int health = 44;
    final int maxHealth = 50;
    final int experience = 123;
    final int nextLevelExp = 330;
    final int mana = 54;
    final int maxMana = 58;
    final int level = 14;
    final String userClass = 'Bulwark';

    return Container(
// Background color for the status bar
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Image.network(avatarUrl, width: 70, height: 70), // User avatar
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StatBar(
                        label: 'Health',
                        value: health,
                        maxValue: maxHealth,
                        color: Colors.red,
                        icon: Icons.favorite,
                      ),
                      StatBar(
                        label: 'Energy',
                        value: mana,
                        maxValue: maxMana,
                        color: Colors.blue,
                        icon: Icons.electric_bolt,
                      ),
                      StatBar(
                        label: 'Experience',
                        value: experience,
                        maxValue: nextLevelExp,
                        color: Colors.amber,
                        icon: Icons.star,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Level $level', style: TextStyle(color: Colors.white)),
                Text(userClass, style: TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.5, color: Color.fromARGB(255,14,31,46)),
        ),
      ),
    );
  }
}