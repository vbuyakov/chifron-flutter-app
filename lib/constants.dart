import 'package:chifron/models/number_range.dart';

const int maxReplayCount = 3;
const int maxDigits = 5;
const String emptyWrongValuePlaceholder = '***';
const int replayButtonCooldownMs = 500;

const List<NumberRange> numberRangePresets = [
  NumberRange(0, 100, '0-100'),
  NumberRange(100, 999, '100-999'),
  NumberRange(1000, 5000, '1000-5000'),
  NumberRange(1, 5000, '1-5000'),
  NumberRange(101, 10000, '101-10000'),
];
