class Quest {
  final int id;
  final String name;
  final String details;
  final int reward;
  final int hp;
  final int breakPoints;
  final int xp;

  Quest({
    required this.id,
    required this.name,
    required this.details,
    required this.reward,
    required this.hp,
    required this.breakPoints,
    required this.xp,
  });

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      id: json['id'],
      name: json['name'],
      details: json['details'],
      reward: json['reward'],
      hp: json['hp'],
      breakPoints: json['break'],
      xp: json['xp'],
    );
  }
}
