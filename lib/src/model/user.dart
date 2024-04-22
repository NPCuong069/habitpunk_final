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

  final int hatId; 
  final int costumeId; 
  final int facialId; 
  final int weaponId; 
  final int backgroundId;
  final int petId;
  final int capeId;
  final int chipId;

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

    required this.hatId, 
    required this.costumeId, 
    required this.facialId, 
    required this.weaponId, 
    required this.backgroundId,
    required this.petId,
    required this.capeId,
    required this.chipId,
    
  });

  factory User.fromJson(Map<String, dynamic> json) {
    int parseOrFallback(dynamic value, int fallback) {
      if (value == null) return fallback;
      return value is int ? value : int.tryParse(value.toString()) ?? fallback;
    }

    final int lvl = parseOrFallback(json['lvl'], 1);
    final maxHealth = lvl * 50;
    final nextLevelExp = lvl * 100;
    final maxMana = 100; // maxMana is fixed at 100

    return User(
      username: json['username'] ?? 'Unknown',
      hp: parseOrFallback(json['hp'], 100),
      xp: parseOrFallback(json['xp'], 0),
      en: parseOrFallback(json['en'], 100),
      lvl: lvl,
      coin: parseOrFallback(json['coin'], 0),
      maxHealth: maxHealth,
      nextLevelExp: nextLevelExp,
      maxMana: maxMana,
      userClass: json['userClass'] ?? 'DefaultClass',

      hatId: parseOrFallback(json['hat_id'], 0),
      costumeId: parseOrFallback(json['costume_id'], 0),
      facialId: parseOrFallback(json['facial_id'], 0),
      weaponId: parseOrFallback(json['weapon_id'], 0),
      backgroundId: parseOrFallback(json['background_id'], 0),
      petId: parseOrFallback(json['pet_id'], 0),
      capeId: parseOrFallback(json['cape_id'], 0),
      chipId: parseOrFallback(json['chip_id'], 0),
    );
  }
}
