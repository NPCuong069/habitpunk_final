import 'package:flutter/material.dart';
import 'package:habitpunk/src/model/achievement.dart';


class AchievementsPage extends StatelessWidget {
  final List<Achievement> achievements;

  AchievementsPage({Key? key, required this.achievements}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter achievements based on completion status
    List<Achievement> ongoingAchievements = achievements.where((achievement) => !achievement.isCompleted).toList();
    List<Achievement> completedAchievements = achievements.where((achievement) => achievement.isCompleted).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Achievements'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(title: Text('Currently Doing', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white))),
          ...ongoingAchievements.map((achievement) => AchievementTile(achievement: achievement)).toList(),
          ListTile(title: Text('Done', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white))),
          ...completedAchievements.map((achievement) => AchievementTile(achievement: achievement)).toList(),
        ],
      ),
    );
  }
}

class AchievementTile extends StatelessWidget {
  final Achievement achievement;

  AchievementTile({Key? key, required this.achievement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(achievement.title, style: TextStyle(fontWeight:FontWeight.bold, color: Colors.white)),
      subtitle: Text(achievement.description),
      trailing: achievement.isCompleted
          ? Icon(Icons.check, color: Colors.green)
          : CircularProgressIndicator(),
    );
  }
}
