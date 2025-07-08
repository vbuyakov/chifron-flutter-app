// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $NumberGameRecordsTable extends NumberGameRecords
    with TableInfo<$NumberGameRecordsTable, NumberGameRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NumberGameRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
      'number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastResultMeta =
      const VerificationMeta('lastResult');
  @override
  late final GeneratedColumn<String> lastResult = GeneratedColumn<String>(
      'last_result', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalCorrectMeta =
      const VerificationMeta('totalCorrect');
  @override
  late final GeneratedColumn<int> totalCorrect = GeneratedColumn<int>(
      'total_correct', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _totalWrongMeta =
      const VerificationMeta('totalWrong');
  @override
  late final GeneratedColumn<int> totalWrong = GeneratedColumn<int>(
      'total_wrong', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _numberScoreMeta =
      const VerificationMeta('numberScore');
  @override
  late final GeneratedColumn<double> numberScore = GeneratedColumn<double>(
      'number_score', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _playedAtMeta =
      const VerificationMeta('playedAt');
  @override
  late final GeneratedColumn<DateTime> playedAt = GeneratedColumn<DateTime>(
      'played_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _audioFileNameMeta =
      const VerificationMeta('audioFileName');
  @override
  late final GeneratedColumn<String> audioFileName = GeneratedColumn<String>(
      'audio_file_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        number,
        lastResult,
        totalCorrect,
        totalWrong,
        numberScore,
        playedAt,
        audioFileName
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'number_game_records';
  @override
  VerificationContext validateIntegrity(Insertable<NumberGameRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('last_result')) {
      context.handle(
          _lastResultMeta,
          lastResult.isAcceptableOrUnknown(
              data['last_result']!, _lastResultMeta));
    } else if (isInserting) {
      context.missing(_lastResultMeta);
    }
    if (data.containsKey('total_correct')) {
      context.handle(
          _totalCorrectMeta,
          totalCorrect.isAcceptableOrUnknown(
              data['total_correct']!, _totalCorrectMeta));
    } else if (isInserting) {
      context.missing(_totalCorrectMeta);
    }
    if (data.containsKey('total_wrong')) {
      context.handle(
          _totalWrongMeta,
          totalWrong.isAcceptableOrUnknown(
              data['total_wrong']!, _totalWrongMeta));
    } else if (isInserting) {
      context.missing(_totalWrongMeta);
    }
    if (data.containsKey('number_score')) {
      context.handle(
          _numberScoreMeta,
          numberScore.isAcceptableOrUnknown(
              data['number_score']!, _numberScoreMeta));
    } else if (isInserting) {
      context.missing(_numberScoreMeta);
    }
    if (data.containsKey('played_at')) {
      context.handle(_playedAtMeta,
          playedAt.isAcceptableOrUnknown(data['played_at']!, _playedAtMeta));
    } else if (isInserting) {
      context.missing(_playedAtMeta);
    }
    if (data.containsKey('audio_file_name')) {
      context.handle(
          _audioFileNameMeta,
          audioFileName.isAcceptableOrUnknown(
              data['audio_file_name']!, _audioFileNameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NumberGameRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NumberGameRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      number: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}number'])!,
      lastResult: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_result'])!,
      totalCorrect: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_correct'])!,
      totalWrong: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_wrong'])!,
      numberScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}number_score'])!,
      playedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}played_at'])!,
      audioFileName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_file_name']),
    );
  }

  @override
  $NumberGameRecordsTable createAlias(String alias) {
    return $NumberGameRecordsTable(attachedDatabase, alias);
  }
}

class NumberGameRecord extends DataClass
    implements Insertable<NumberGameRecord> {
  final int id;
  final int number;
  final String lastResult;
  final int totalCorrect;
  final int totalWrong;
  final double numberScore;
  final DateTime playedAt;
  final String? audioFileName;
  const NumberGameRecord(
      {required this.id,
      required this.number,
      required this.lastResult,
      required this.totalCorrect,
      required this.totalWrong,
      required this.numberScore,
      required this.playedAt,
      this.audioFileName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['number'] = Variable<int>(number);
    map['last_result'] = Variable<String>(lastResult);
    map['total_correct'] = Variable<int>(totalCorrect);
    map['total_wrong'] = Variable<int>(totalWrong);
    map['number_score'] = Variable<double>(numberScore);
    map['played_at'] = Variable<DateTime>(playedAt);
    if (!nullToAbsent || audioFileName != null) {
      map['audio_file_name'] = Variable<String>(audioFileName);
    }
    return map;
  }

  NumberGameRecordsCompanion toCompanion(bool nullToAbsent) {
    return NumberGameRecordsCompanion(
      id: Value(id),
      number: Value(number),
      lastResult: Value(lastResult),
      totalCorrect: Value(totalCorrect),
      totalWrong: Value(totalWrong),
      numberScore: Value(numberScore),
      playedAt: Value(playedAt),
      audioFileName: audioFileName == null && nullToAbsent
          ? const Value.absent()
          : Value(audioFileName),
    );
  }

  factory NumberGameRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NumberGameRecord(
      id: serializer.fromJson<int>(json['id']),
      number: serializer.fromJson<int>(json['number']),
      lastResult: serializer.fromJson<String>(json['lastResult']),
      totalCorrect: serializer.fromJson<int>(json['totalCorrect']),
      totalWrong: serializer.fromJson<int>(json['totalWrong']),
      numberScore: serializer.fromJson<double>(json['numberScore']),
      playedAt: serializer.fromJson<DateTime>(json['playedAt']),
      audioFileName: serializer.fromJson<String?>(json['audioFileName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'number': serializer.toJson<int>(number),
      'lastResult': serializer.toJson<String>(lastResult),
      'totalCorrect': serializer.toJson<int>(totalCorrect),
      'totalWrong': serializer.toJson<int>(totalWrong),
      'numberScore': serializer.toJson<double>(numberScore),
      'playedAt': serializer.toJson<DateTime>(playedAt),
      'audioFileName': serializer.toJson<String?>(audioFileName),
    };
  }

  NumberGameRecord copyWith(
          {int? id,
          int? number,
          String? lastResult,
          int? totalCorrect,
          int? totalWrong,
          double? numberScore,
          DateTime? playedAt,
          Value<String?> audioFileName = const Value.absent()}) =>
      NumberGameRecord(
        id: id ?? this.id,
        number: number ?? this.number,
        lastResult: lastResult ?? this.lastResult,
        totalCorrect: totalCorrect ?? this.totalCorrect,
        totalWrong: totalWrong ?? this.totalWrong,
        numberScore: numberScore ?? this.numberScore,
        playedAt: playedAt ?? this.playedAt,
        audioFileName:
            audioFileName.present ? audioFileName.value : this.audioFileName,
      );
  NumberGameRecord copyWithCompanion(NumberGameRecordsCompanion data) {
    return NumberGameRecord(
      id: data.id.present ? data.id.value : this.id,
      number: data.number.present ? data.number.value : this.number,
      lastResult:
          data.lastResult.present ? data.lastResult.value : this.lastResult,
      totalCorrect: data.totalCorrect.present
          ? data.totalCorrect.value
          : this.totalCorrect,
      totalWrong:
          data.totalWrong.present ? data.totalWrong.value : this.totalWrong,
      numberScore:
          data.numberScore.present ? data.numberScore.value : this.numberScore,
      playedAt: data.playedAt.present ? data.playedAt.value : this.playedAt,
      audioFileName: data.audioFileName.present
          ? data.audioFileName.value
          : this.audioFileName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NumberGameRecord(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('lastResult: $lastResult, ')
          ..write('totalCorrect: $totalCorrect, ')
          ..write('totalWrong: $totalWrong, ')
          ..write('numberScore: $numberScore, ')
          ..write('playedAt: $playedAt, ')
          ..write('audioFileName: $audioFileName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, number, lastResult, totalCorrect,
      totalWrong, numberScore, playedAt, audioFileName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NumberGameRecord &&
          other.id == this.id &&
          other.number == this.number &&
          other.lastResult == this.lastResult &&
          other.totalCorrect == this.totalCorrect &&
          other.totalWrong == this.totalWrong &&
          other.numberScore == this.numberScore &&
          other.playedAt == this.playedAt &&
          other.audioFileName == this.audioFileName);
}

class NumberGameRecordsCompanion extends UpdateCompanion<NumberGameRecord> {
  final Value<int> id;
  final Value<int> number;
  final Value<String> lastResult;
  final Value<int> totalCorrect;
  final Value<int> totalWrong;
  final Value<double> numberScore;
  final Value<DateTime> playedAt;
  final Value<String?> audioFileName;
  const NumberGameRecordsCompanion({
    this.id = const Value.absent(),
    this.number = const Value.absent(),
    this.lastResult = const Value.absent(),
    this.totalCorrect = const Value.absent(),
    this.totalWrong = const Value.absent(),
    this.numberScore = const Value.absent(),
    this.playedAt = const Value.absent(),
    this.audioFileName = const Value.absent(),
  });
  NumberGameRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int number,
    required String lastResult,
    required int totalCorrect,
    required int totalWrong,
    required double numberScore,
    required DateTime playedAt,
    this.audioFileName = const Value.absent(),
  })  : number = Value(number),
        lastResult = Value(lastResult),
        totalCorrect = Value(totalCorrect),
        totalWrong = Value(totalWrong),
        numberScore = Value(numberScore),
        playedAt = Value(playedAt);
  static Insertable<NumberGameRecord> custom({
    Expression<int>? id,
    Expression<int>? number,
    Expression<String>? lastResult,
    Expression<int>? totalCorrect,
    Expression<int>? totalWrong,
    Expression<double>? numberScore,
    Expression<DateTime>? playedAt,
    Expression<String>? audioFileName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (number != null) 'number': number,
      if (lastResult != null) 'last_result': lastResult,
      if (totalCorrect != null) 'total_correct': totalCorrect,
      if (totalWrong != null) 'total_wrong': totalWrong,
      if (numberScore != null) 'number_score': numberScore,
      if (playedAt != null) 'played_at': playedAt,
      if (audioFileName != null) 'audio_file_name': audioFileName,
    });
  }

  NumberGameRecordsCompanion copyWith(
      {Value<int>? id,
      Value<int>? number,
      Value<String>? lastResult,
      Value<int>? totalCorrect,
      Value<int>? totalWrong,
      Value<double>? numberScore,
      Value<DateTime>? playedAt,
      Value<String?>? audioFileName}) {
    return NumberGameRecordsCompanion(
      id: id ?? this.id,
      number: number ?? this.number,
      lastResult: lastResult ?? this.lastResult,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      totalWrong: totalWrong ?? this.totalWrong,
      numberScore: numberScore ?? this.numberScore,
      playedAt: playedAt ?? this.playedAt,
      audioFileName: audioFileName ?? this.audioFileName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (lastResult.present) {
      map['last_result'] = Variable<String>(lastResult.value);
    }
    if (totalCorrect.present) {
      map['total_correct'] = Variable<int>(totalCorrect.value);
    }
    if (totalWrong.present) {
      map['total_wrong'] = Variable<int>(totalWrong.value);
    }
    if (numberScore.present) {
      map['number_score'] = Variable<double>(numberScore.value);
    }
    if (playedAt.present) {
      map['played_at'] = Variable<DateTime>(playedAt.value);
    }
    if (audioFileName.present) {
      map['audio_file_name'] = Variable<String>(audioFileName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NumberGameRecordsCompanion(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('lastResult: $lastResult, ')
          ..write('totalCorrect: $totalCorrect, ')
          ..write('totalWrong: $totalWrong, ')
          ..write('numberScore: $numberScore, ')
          ..write('playedAt: $playedAt, ')
          ..write('audioFileName: $audioFileName')
          ..write(')'))
        .toString();
  }
}

class $DailyStatsTable extends DailyStats
    with TableInfo<$DailyStatsTable, DailyStat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _correctMeta =
      const VerificationMeta('correct');
  @override
  late final GeneratedColumn<int> correct = GeneratedColumn<int>(
      'correct', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _wrongMeta = const VerificationMeta('wrong');
  @override
  late final GeneratedColumn<int> wrong = GeneratedColumn<int>(
      'wrong', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _percentMeta =
      const VerificationMeta('percent');
  @override
  late final GeneratedColumn<double> percent = GeneratedColumn<double>(
      'percent', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, date, correct, wrong, percent];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_stats';
  @override
  VerificationContext validateIntegrity(Insertable<DailyStat> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('correct')) {
      context.handle(_correctMeta,
          correct.isAcceptableOrUnknown(data['correct']!, _correctMeta));
    } else if (isInserting) {
      context.missing(_correctMeta);
    }
    if (data.containsKey('wrong')) {
      context.handle(
          _wrongMeta, wrong.isAcceptableOrUnknown(data['wrong']!, _wrongMeta));
    } else if (isInserting) {
      context.missing(_wrongMeta);
    }
    if (data.containsKey('percent')) {
      context.handle(_percentMeta,
          percent.isAcceptableOrUnknown(data['percent']!, _percentMeta));
    } else if (isInserting) {
      context.missing(_percentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyStat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyStat(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      correct: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}correct'])!,
      wrong: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}wrong'])!,
      percent: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}percent'])!,
    );
  }

  @override
  $DailyStatsTable createAlias(String alias) {
    return $DailyStatsTable(attachedDatabase, alias);
  }
}

class DailyStat extends DataClass implements Insertable<DailyStat> {
  final int id;
  final DateTime date;
  final int correct;
  final int wrong;
  final double percent;
  const DailyStat(
      {required this.id,
      required this.date,
      required this.correct,
      required this.wrong,
      required this.percent});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['correct'] = Variable<int>(correct);
    map['wrong'] = Variable<int>(wrong);
    map['percent'] = Variable<double>(percent);
    return map;
  }

  DailyStatsCompanion toCompanion(bool nullToAbsent) {
    return DailyStatsCompanion(
      id: Value(id),
      date: Value(date),
      correct: Value(correct),
      wrong: Value(wrong),
      percent: Value(percent),
    );
  }

  factory DailyStat.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyStat(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      correct: serializer.fromJson<int>(json['correct']),
      wrong: serializer.fromJson<int>(json['wrong']),
      percent: serializer.fromJson<double>(json['percent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'correct': serializer.toJson<int>(correct),
      'wrong': serializer.toJson<int>(wrong),
      'percent': serializer.toJson<double>(percent),
    };
  }

  DailyStat copyWith(
          {int? id,
          DateTime? date,
          int? correct,
          int? wrong,
          double? percent}) =>
      DailyStat(
        id: id ?? this.id,
        date: date ?? this.date,
        correct: correct ?? this.correct,
        wrong: wrong ?? this.wrong,
        percent: percent ?? this.percent,
      );
  DailyStat copyWithCompanion(DailyStatsCompanion data) {
    return DailyStat(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      correct: data.correct.present ? data.correct.value : this.correct,
      wrong: data.wrong.present ? data.wrong.value : this.wrong,
      percent: data.percent.present ? data.percent.value : this.percent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyStat(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('correct: $correct, ')
          ..write('wrong: $wrong, ')
          ..write('percent: $percent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, correct, wrong, percent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyStat &&
          other.id == this.id &&
          other.date == this.date &&
          other.correct == this.correct &&
          other.wrong == this.wrong &&
          other.percent == this.percent);
}

class DailyStatsCompanion extends UpdateCompanion<DailyStat> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> correct;
  final Value<int> wrong;
  final Value<double> percent;
  const DailyStatsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.correct = const Value.absent(),
    this.wrong = const Value.absent(),
    this.percent = const Value.absent(),
  });
  DailyStatsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required int correct,
    required int wrong,
    required double percent,
  })  : date = Value(date),
        correct = Value(correct),
        wrong = Value(wrong),
        percent = Value(percent);
  static Insertable<DailyStat> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? correct,
    Expression<int>? wrong,
    Expression<double>? percent,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (correct != null) 'correct': correct,
      if (wrong != null) 'wrong': wrong,
      if (percent != null) 'percent': percent,
    });
  }

  DailyStatsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<int>? correct,
      Value<int>? wrong,
      Value<double>? percent}) {
    return DailyStatsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      correct: correct ?? this.correct,
      wrong: wrong ?? this.wrong,
      percent: percent ?? this.percent,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (correct.present) {
      map['correct'] = Variable<int>(correct.value);
    }
    if (wrong.present) {
      map['wrong'] = Variable<int>(wrong.value);
    }
    if (percent.present) {
      map['percent'] = Variable<double>(percent.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyStatsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('correct: $correct, ')
          ..write('wrong: $wrong, ')
          ..write('percent: $percent')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NumberGameRecordsTable numberGameRecords =
      $NumberGameRecordsTable(this);
  late final $DailyStatsTable dailyStats = $DailyStatsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [numberGameRecords, dailyStats];
}

typedef $$NumberGameRecordsTableCreateCompanionBuilder
    = NumberGameRecordsCompanion Function({
  Value<int> id,
  required int number,
  required String lastResult,
  required int totalCorrect,
  required int totalWrong,
  required double numberScore,
  required DateTime playedAt,
  Value<String?> audioFileName,
});
typedef $$NumberGameRecordsTableUpdateCompanionBuilder
    = NumberGameRecordsCompanion Function({
  Value<int> id,
  Value<int> number,
  Value<String> lastResult,
  Value<int> totalCorrect,
  Value<int> totalWrong,
  Value<double> numberScore,
  Value<DateTime> playedAt,
  Value<String?> audioFileName,
});

class $$NumberGameRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $NumberGameRecordsTable> {
  $$NumberGameRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastResult => $composableBuilder(
      column: $table.lastResult, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalCorrect => $composableBuilder(
      column: $table.totalCorrect, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalWrong => $composableBuilder(
      column: $table.totalWrong, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get numberScore => $composableBuilder(
      column: $table.numberScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get playedAt => $composableBuilder(
      column: $table.playedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get audioFileName => $composableBuilder(
      column: $table.audioFileName, builder: (column) => ColumnFilters(column));
}

class $$NumberGameRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $NumberGameRecordsTable> {
  $$NumberGameRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastResult => $composableBuilder(
      column: $table.lastResult, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalCorrect => $composableBuilder(
      column: $table.totalCorrect,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalWrong => $composableBuilder(
      column: $table.totalWrong, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get numberScore => $composableBuilder(
      column: $table.numberScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get playedAt => $composableBuilder(
      column: $table.playedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audioFileName => $composableBuilder(
      column: $table.audioFileName,
      builder: (column) => ColumnOrderings(column));
}

class $$NumberGameRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NumberGameRecordsTable> {
  $$NumberGameRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get lastResult => $composableBuilder(
      column: $table.lastResult, builder: (column) => column);

  GeneratedColumn<int> get totalCorrect => $composableBuilder(
      column: $table.totalCorrect, builder: (column) => column);

  GeneratedColumn<int> get totalWrong => $composableBuilder(
      column: $table.totalWrong, builder: (column) => column);

  GeneratedColumn<double> get numberScore => $composableBuilder(
      column: $table.numberScore, builder: (column) => column);

  GeneratedColumn<DateTime> get playedAt =>
      $composableBuilder(column: $table.playedAt, builder: (column) => column);

  GeneratedColumn<String> get audioFileName => $composableBuilder(
      column: $table.audioFileName, builder: (column) => column);
}

class $$NumberGameRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NumberGameRecordsTable,
    NumberGameRecord,
    $$NumberGameRecordsTableFilterComposer,
    $$NumberGameRecordsTableOrderingComposer,
    $$NumberGameRecordsTableAnnotationComposer,
    $$NumberGameRecordsTableCreateCompanionBuilder,
    $$NumberGameRecordsTableUpdateCompanionBuilder,
    (
      NumberGameRecord,
      BaseReferences<_$AppDatabase, $NumberGameRecordsTable, NumberGameRecord>
    ),
    NumberGameRecord,
    PrefetchHooks Function()> {
  $$NumberGameRecordsTableTableManager(
      _$AppDatabase db, $NumberGameRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NumberGameRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NumberGameRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NumberGameRecordsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> number = const Value.absent(),
            Value<String> lastResult = const Value.absent(),
            Value<int> totalCorrect = const Value.absent(),
            Value<int> totalWrong = const Value.absent(),
            Value<double> numberScore = const Value.absent(),
            Value<DateTime> playedAt = const Value.absent(),
            Value<String?> audioFileName = const Value.absent(),
          }) =>
              NumberGameRecordsCompanion(
            id: id,
            number: number,
            lastResult: lastResult,
            totalCorrect: totalCorrect,
            totalWrong: totalWrong,
            numberScore: numberScore,
            playedAt: playedAt,
            audioFileName: audioFileName,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int number,
            required String lastResult,
            required int totalCorrect,
            required int totalWrong,
            required double numberScore,
            required DateTime playedAt,
            Value<String?> audioFileName = const Value.absent(),
          }) =>
              NumberGameRecordsCompanion.insert(
            id: id,
            number: number,
            lastResult: lastResult,
            totalCorrect: totalCorrect,
            totalWrong: totalWrong,
            numberScore: numberScore,
            playedAt: playedAt,
            audioFileName: audioFileName,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NumberGameRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NumberGameRecordsTable,
    NumberGameRecord,
    $$NumberGameRecordsTableFilterComposer,
    $$NumberGameRecordsTableOrderingComposer,
    $$NumberGameRecordsTableAnnotationComposer,
    $$NumberGameRecordsTableCreateCompanionBuilder,
    $$NumberGameRecordsTableUpdateCompanionBuilder,
    (
      NumberGameRecord,
      BaseReferences<_$AppDatabase, $NumberGameRecordsTable, NumberGameRecord>
    ),
    NumberGameRecord,
    PrefetchHooks Function()>;
typedef $$DailyStatsTableCreateCompanionBuilder = DailyStatsCompanion Function({
  Value<int> id,
  required DateTime date,
  required int correct,
  required int wrong,
  required double percent,
});
typedef $$DailyStatsTableUpdateCompanionBuilder = DailyStatsCompanion Function({
  Value<int> id,
  Value<DateTime> date,
  Value<int> correct,
  Value<int> wrong,
  Value<double> percent,
});

class $$DailyStatsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyStatsTable> {
  $$DailyStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get correct => $composableBuilder(
      column: $table.correct, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wrong => $composableBuilder(
      column: $table.wrong, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get percent => $composableBuilder(
      column: $table.percent, builder: (column) => ColumnFilters(column));
}

class $$DailyStatsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyStatsTable> {
  $$DailyStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get correct => $composableBuilder(
      column: $table.correct, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wrong => $composableBuilder(
      column: $table.wrong, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get percent => $composableBuilder(
      column: $table.percent, builder: (column) => ColumnOrderings(column));
}

class $$DailyStatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyStatsTable> {
  $$DailyStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<int> get wrong =>
      $composableBuilder(column: $table.wrong, builder: (column) => column);

  GeneratedColumn<double> get percent =>
      $composableBuilder(column: $table.percent, builder: (column) => column);
}

class $$DailyStatsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DailyStatsTable,
    DailyStat,
    $$DailyStatsTableFilterComposer,
    $$DailyStatsTableOrderingComposer,
    $$DailyStatsTableAnnotationComposer,
    $$DailyStatsTableCreateCompanionBuilder,
    $$DailyStatsTableUpdateCompanionBuilder,
    (DailyStat, BaseReferences<_$AppDatabase, $DailyStatsTable, DailyStat>),
    DailyStat,
    PrefetchHooks Function()> {
  $$DailyStatsTableTableManager(_$AppDatabase db, $DailyStatsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> correct = const Value.absent(),
            Value<int> wrong = const Value.absent(),
            Value<double> percent = const Value.absent(),
          }) =>
              DailyStatsCompanion(
            id: id,
            date: date,
            correct: correct,
            wrong: wrong,
            percent: percent,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            required int correct,
            required int wrong,
            required double percent,
          }) =>
              DailyStatsCompanion.insert(
            id: id,
            date: date,
            correct: correct,
            wrong: wrong,
            percent: percent,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DailyStatsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DailyStatsTable,
    DailyStat,
    $$DailyStatsTableFilterComposer,
    $$DailyStatsTableOrderingComposer,
    $$DailyStatsTableAnnotationComposer,
    $$DailyStatsTableCreateCompanionBuilder,
    $$DailyStatsTableUpdateCompanionBuilder,
    (DailyStat, BaseReferences<_$AppDatabase, $DailyStatsTable, DailyStat>),
    DailyStat,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NumberGameRecordsTableTableManager get numberGameRecords =>
      $$NumberGameRecordsTableTableManager(_db, _db.numberGameRecords);
  $$DailyStatsTableTableManager get dailyStats =>
      $$DailyStatsTableTableManager(_db, _db.dailyStats);
}
