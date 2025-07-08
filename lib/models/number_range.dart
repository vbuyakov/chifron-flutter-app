class NumberRange {
  final int min;
  final int max;
  final String label;
  const NumberRange(this.min, this.max, this.label);

  bool matches(int minValue, int maxValue, String label) {
    return min == minValue && max == maxValue && this.label == label;
  }
} 