class Habit {
  final String id;
  final String title;
  final String note;
  final int difficulty;
  final int posClicks;
  final int negClicks;

  Habit({
    required this.id,
    required this.title,
    required this.note,
    required this.difficulty,
    this.posClicks = 0,
    this.negClicks = 0,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'].toString(),
      title: json['title'],
      note: json['note'],
      difficulty: json['difficulty'],
      posClicks: json['pos_clicks'] ?? 0,
      negClicks: json['neg_clicks'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'difficulty': difficulty,
      'pos_clicks': posClicks,
      'neg_clicks': negClicks,
    };
  }
}
