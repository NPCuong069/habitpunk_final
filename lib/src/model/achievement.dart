class Achievement {
  final String title;
  final String description;
  final bool isCompleted;

  Achievement({required this.title, required this.description, required this.isCompleted});
}

List<Achievement> achievements = [
  Achievement(title: 'First Quest', description: 'Complete your first quest', isCompleted: false),
  Achievement(title: 'Brave Adventurer', description: 'Complete 10 quests', isCompleted: true),
  // Add more achievements...
];
