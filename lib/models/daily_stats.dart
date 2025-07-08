class DailyStats {
  final DateTime date;
  final int correct;
  final int wrong;
  final double percent;

  DailyStats({
    required this.date,
    required this.correct,
    required this.wrong,
  }) : percent =
            (correct + wrong) > 0 ? (correct / (correct + wrong)) * 100 : 0;

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'correct': correct,
      'wrong': wrong,
    };
  }

  factory DailyStats.fromJson(Map<String, dynamic> json) {
    return DailyStats(
      date: DateTime.parse(json['date']),
      correct: json['correct'] ?? 0,
      wrong: json['wrong'] ?? 0,
    );
  }

  DailyStats copyWith({
    DateTime? date,
    int? correct,
    int? wrong,
  }) {
    return DailyStats(
      date: date ?? this.date,
      correct: correct ?? this.correct,
      wrong: wrong ?? this.wrong,
    );
  }
}
