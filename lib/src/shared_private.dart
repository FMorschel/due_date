import 'package:time/time.dart';

import '../due_date.dart';

// ignore: format-comment, false positive
/// Returns the workday number in the month of the [date].
///
/// Throws if [shouldThrow] is true and [date] is not a workday (weekend:
/// saturday or sunday).
/// If [shouldThrow] is false and [date] is not a workday (weekend: saturday or
/// sunday), returns 0.
int getWorkdayNumberInMonth(
  DateTime date, {
  bool shouldThrow = false,
}) {
  const workdays = EveryWeekday.workdays;
  if (workdays.invalid(date)) {
    if (shouldThrow) {
      throw ArgumentError.value(
        date,
        'date',
        'Must be a workday. Workdays: '
            '${workdays.map((e) => e.weekday.name).join(', ')}',
      );
    }
    return 0;
  }
  var local = date.copyWith();
  var workdaysCount = 0;
  while (local.isAtSameMonthAs(date)) {
    if (workdays.valid(local)) workdaysCount++;
    local = workdays.previous(local);
  }
  return workdaysCount;
}

/// Extension for [Object]s.
extension ObjectExt<T extends Object> on T {
  /// Returns the result of [orElse] if [predicate] returns false, otherwise
  /// returns this.
  T? when(bool Function(T self) predicate, {T? Function(T self)? orElse}) =>
      predicate(this) ? this : orElse?.call(this);

  /// Applies [f] to this object and returns the result.
  R apply<R>(R Function(T self) f) => f(this);
}
