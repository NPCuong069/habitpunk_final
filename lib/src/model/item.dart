class Item {
  final int id;
  final String name;
  final int coin;
  final String type;
  final bool owned;

  Item({
    required this.id,
    required this.name,
    required this.coin,
    required this.type,
    required this.owned,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      coin: json['coin'],
      type: json['type'],
      owned: json['owned'],
    );
  }
}
