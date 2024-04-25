class Daily {
  final String id;
  final String title;
  final String note;
  final bool completed;
  final int difficulty;

  Daily({required this.id, required this.title, required this.note, this.completed = false, required this.difficulty});

  factory Daily.fromJson(Map<String, dynamic> json) {
    return Daily(
       id: json['id'].toString(), 
      title: json['title'],
      note: json['note'],
      completed: json['ischeck'],
      difficulty: json['difficulty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'note': note,
      'difficulty': difficulty,
    };
  }
}