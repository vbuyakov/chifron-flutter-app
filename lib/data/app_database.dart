import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

class NumberGameRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get number => integer()();
  TextColumn get lastResult => text()(); // 'correct' or 'wrong'
  IntColumn get totalCorrect => integer()();
  IntColumn get totalWrong => integer()();
  RealColumn get numberScore => real()();
  DateTimeColumn get playedAt =>
      dateTime()(); // renamed from dateTime to playedAt
  TextColumn get audioFileName =>
      text().nullable()(); // New column for audio file name
}

class DailyStats extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get correct => integer()();
  IntColumn get wrong => integer()();
  RealColumn get percent => real()();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [NumberGameRecords, DailyStats])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;
}
