import 'package:drift/drift.dart';
import 'package:chifron/data/app_database.dart';

class StatisticsRepository {
  final AppDatabase db;
  StatisticsRepository(this.db);

  // --- Number Game Records ---

  Future<int> addOrUpdateNumberGameRecord({
    required int number,
    required String lastResult,
    required int totalCorrect,
    required int totalWrong,
    required DateTime playedAt,
    String? audioFileName,
  }) async {
    final numberScore = (totalCorrect + totalWrong) > 0
        ? (totalCorrect / (totalCorrect + totalWrong)) * 100
        : 0.0;
    // Check if record exists
    final existing = await db
        .select(db.numberGameRecords)
        .where((tbl) => tbl.number.equals(number))
        .getSingleOrNull();
    if (existing != null) {
      await db.update(db.numberGameRecords).replace(
            NumberGameRecordsCompanion(
              id: Value(existing.id),
              number: Value(number),
              lastResult: Value(lastResult),
              totalCorrect: Value(totalCorrect),
              totalWrong: Value(totalWrong),
              numberScore: Value(numberScore),
              playedAt: Value(playedAt),
              audioFileName: Value(audioFileName),
            ),
          );
      return existing.id;
    } else {
      return db.into(db.numberGameRecords).insert(
            NumberGameRecordsCompanion(
              number: Value(number),
              lastResult: Value(lastResult),
              totalCorrect: Value(totalCorrect),
              totalWrong: Value(totalWrong),
              numberScore: Value(numberScore),
              playedAt: Value(playedAt),
              audioFileName: Value(audioFileName),
            ),
          );
    }
  }

  Future<NumberGameRecord?> getNumberGameRecord(int number) async {
    return await db
        .select(db.numberGameRecords)
        .where((tbl) => tbl.number.equals(number))
        .getSingleOrNull();
  }

  Future<List<NumberGameRecord>> getAllNumberGameRecords() async {
    return await db.select(db.numberGameRecords).get();
  }

  Future<List<NumberGameRecord>> getTopNumbersByScore(int limit) async {
    return await (db.select(db.numberGameRecords)
          ..orderBy([
            (tbl) => OrderingTerm(
                expression: tbl.numberScore, mode: OrderingMode.desc),
          ])
          ..limit(limit))
        .get();
  }

  Future<void> deleteAllNumberGameRecords() async {
    await db.delete(db.numberGameRecords).go();
  }

  // --- Daily Stats ---

  Future<int> addOrUpdateDailyStats({
    required DateTime date,
    required int correct,
    required int wrong,
  }) async {
    final percent =
        (correct + wrong) > 0 ? (correct / (correct + wrong)) * 100 : 0.0;
    // Check if record exists
    final existing = await db
        .select(db.dailyStats)
        .where((tbl) => tbl.date.equals(date))
        .getSingleOrNull();
    if (existing != null) {
      await db.update(db.dailyStats).replace(
            DailyStatsCompanion(
              id: Value(existing.id),
              date: Value(date),
              correct: Value(correct),
              wrong: Value(wrong),
              percent: Value(percent),
            ),
          );
      return existing.id;
    } else {
      return db.into(db.dailyStats).insert(
            DailyStatsCompanion(
              date: Value(date),
              correct: Value(correct),
              wrong: Value(wrong),
              percent: Value(percent),
            ),
          );
    }
  }

  Future<DailyStat?> getDailyStats(DateTime date) async {
    return await db
        .select(db.dailyStats)
        .where((tbl) => tbl.date.equals(date))
        .getSingleOrNull();
  }

  Future<List<DailyStat>> getAllDailyStats() async {
    return await db.select(db.dailyStats).get();
  }

  Future<double> getOverallPercent() async {
    final stats = await getAllDailyStats();
    final totalCorrect = stats.fold<int>(0, (sum, s) => sum + s.correct);
    final totalWrong = stats.fold<int>(0, (sum, s) => sum + s.wrong);
    if (totalCorrect + totalWrong == 0) return 0.0;
    return (totalCorrect / (totalCorrect + totalWrong)) * 100;
  }

  Future<void> deleteAllDailyStats() async {
    await db.delete(db.dailyStats).go();
  }

  // --- Reset all data ---
  Future<void> resetAll() async {
    await deleteAllNumberGameRecords();
    await deleteAllDailyStats();
  }
}
