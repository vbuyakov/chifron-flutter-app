class NumberGameRecord {
  final int number;
  final String lastResult; // 'correct' or 'wrong'
  final int totalCorrect;
  final int totalWrong;
  final DateTime dateTime;
  final double numberScore;
  final String? audioFileName;

  NumberGameRecord({
    required this.number,
    required this.lastResult,
    required this.totalCorrect,
    required this.totalWrong,
    required this.dateTime,
    this.audioFileName,
  }) : numberScore = (totalCorrect + totalWrong) > 0
            ? (totalCorrect / (totalCorrect + totalWrong)) * 100
            : 0;

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'lastResult': lastResult,
      'totalCorrect': totalCorrect,
      'totalWrong': totalWrong,
      'dateTime': dateTime.toIso8601String(),
      'numberScore': numberScore,
      'audioFileName': audioFileName,
    };
  }

  factory NumberGameRecord.fromJson(Map<String, dynamic> json) {
    final totalCorrect = json['totalCorrect'] ?? 0;
    final totalWrong = json['totalWrong'] ?? 0;
    return NumberGameRecord(
      number: json['number'] ?? 0,
      lastResult: json['lastResult'] ?? 'wrong',
      totalCorrect: totalCorrect,
      totalWrong: totalWrong,
      dateTime: DateTime.parse(json['dateTime']),
      audioFileName: json['audioFileName'],
    );
  }

  NumberGameRecord copyWith({
    int? number,
    String? lastResult,
    int? totalCorrect,
    int? totalWrong,
    DateTime? dateTime,
    String? audioFileName,
  }) {
    return NumberGameRecord(
      number: number ?? this.number,
      lastResult: lastResult ?? this.lastResult,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      totalWrong: totalWrong ?? this.totalWrong,
      dateTime: dateTime ?? this.dateTime,
      audioFileName: audioFileName ?? this.audioFileName,
    );
  }
}
