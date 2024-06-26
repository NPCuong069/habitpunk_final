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
  String userClass;

  final int hatId;
  final int costumeId;
  final int facialId;
  final int weaponId;
  final int backgroundId;
  final int petId;
  final int capeId;
  final int chipId;

  final int? partyId; // Nullable party ID
  final DateTime? subscriptionEndDate;

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
    this.partyId,
    this.subscriptionEndDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    int parseOrFallback(dynamic value, int fallback) {
      if (value == null) return fallback;
      return value is int ? value : int.tryParse(value.toString()) ?? fallback;
    }

    String determineClass(int chipId) {
      switch (chipId) {
        case 801:
          return 'Datablader';
        case 802:
          return 'Breaker';
        case 803:
          return 'Fixer';
        default:
          return 'DefaultClass'; // Fallback class
      }
    }

    final int lvl = parseOrFallback(json['lvl'], 1);
    final int maxHealth = lvl * 50;
    final int nextLevelExp = lvl * 100;
    final int maxMana = 100; // maxMana is fixed at 100
    final int chipId = parseOrFallback(json['chip_id'], 0);
    final String userClass = determineClass(chipId);

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
      userClass: userClass, // Set based on chipId
      hatId: parseOrFallback(json['hat_id'], 0),
      costumeId: parseOrFallback(json['costume_id'], 0),
      facialId: parseOrFallback(json['facial_id'], 0),
      weaponId: parseOrFallback(json['weapon_id'], 0),
      backgroundId: parseOrFallback(json['background_id'], 0),
      petId: parseOrFallback(json['pet_id'], 0),
      capeId: parseOrFallback(json['cape_id'], 0),
      chipId: chipId,
      partyId: json['party_id'] != null ? int.tryParse(json['party_id'].toString()) : null,
      subscriptionEndDate: json['subscription_end_date'] != null ? DateTime.parse(json['subscription_end_date']) : null,
    );
  }
}
