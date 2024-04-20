class User {
  final String username;
  final int hp;
  final int xp;
  final int en;
  final int lvl;
  final int coin;
  final int maxHealth;
  final int nextLevelExp;
  final int maxMana;
  final String userClass;

  User({
    required this.username,
    required this.hp,
    required this.xp,
    required this.en,
    required this.lvl,
    required this.coin,
    required this.maxHealth,
    required this.nextLevelExp,
    required this.maxMana,
    required this.userClass,
    // Initialize the rest of the fields...
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final lvl = json['lvl'];
        // Here we calculate the values based on the level
        final maxHealth = lvl * 50;
        final nextLevelExp = lvl * 100;
        final maxMana = 100; // maxMana is fixed at 100 as per your requirement

    return User(
      username: json['username'],
      hp: json['hp'],
      xp: json['xp'],
      en: json['en'],
      lvl: json['lvl'],
      coin: json['coin'],
      maxHealth: maxHealth,
      nextLevelExp: nextLevelExp,
      maxMana: maxMana,
      userClass: json['userClass'] ?? 'DefaultClass', // Provide a default class if not specified
    );
  }
}
