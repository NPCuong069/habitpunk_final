class Party {
  final String id;
  final String name;
  final String leaderId;
  final int? questId;  // Nullable fields are marked with a '?'
  final int? hp;
  final int? breakPoints;  // 'break' is a keyword in Dart, so use a different name
  final DateTime? createdAt;
  final int? status;
  final String? questName;
  final int? maxHp;
  final int? questReward;
  final String? questDescription;
  final int? questXP;
  final int? maxBreak;
  Party({
    required this.id,
    required this.name,
    required this.leaderId,
    this.questId,
    this.hp,
    this.breakPoints,
    this.createdAt,
    this.status,
    this.questName,
    this.maxHp,
    this.questReward,
    this.questDescription,
    this.questXP,
    this.maxBreak
  });

  factory Party.fromJson(Map<String, dynamic> json) {
    return Party(
      id: json['id'].toString(),
      name: json['party_name'],
      leaderId: json['leader_id'],
      questId: json['quest_id'] as int?,  // Casting to nullable type
      hp: json['hp'] as int?,
      breakPoints: json['break'] as int?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      status: json['status'] as int?,
      questName: json['quest_name'],
      maxHp: json['max_hp'] as int?,
      questDescription: json['quest_details'],
      questXP: json['quest_xp'] as int?,
      questReward: json['quest_reward'] as int?,
      maxBreak: json['max_break'] as int?
    );
  }
}
