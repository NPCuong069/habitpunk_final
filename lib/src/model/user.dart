class User {
  final int id;
  final String firebaseUid;
  final String username;
  final String email;
  final DateTime createdAt;
  
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

  final DateTime loginTime;
  final DateTime? subscriptionDate;
  final int partyId;

  User({
    required this.id,
    required this.username,
    required this.firebaseUid,
    required this.email,
    required this.createdAt,

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

    required this.loginTime,
    this.subscriptionDate,
    required this.partyId,
    
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
      id: parseOrFallback(json['id'], 0),
      firebaseUid: json['firebase_uid'] ?? '',
      username: json['username'] ?? 'Unknown',
      email: json['email'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),

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

      loginTime: DateTime.tryParse(json['login_time'] ?? '') ?? DateTime.now(),
      subscriptionDate: json['subscription_date'] != null ? DateTime.tryParse(json['subscription_date']) : null,
      partyId: parseOrFallback(json['party_id'], 0),
    );
  }
}
