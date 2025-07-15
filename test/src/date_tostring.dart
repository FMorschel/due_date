class DateToString extends DateTime {
  DateToString(super.year, super.month, super.day);

  factory DateToString.from(DateTime date) =>
      DateToString(date.year, date.month, date.day);

  @override
  String toString() {
    return super.toIso8601String().substring(0, 10);
  }
}
