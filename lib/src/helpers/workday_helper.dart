import 'package:time/time.dart';

import '../everies/everies.dart';

/// Helper class to work with workdays.
class WorkdayHelper {
  const WorkdayHelper._();

  /// An every that generates workdays (monday to friday).
  static const every = EveryWeekday.workdays;

  // ignore: format-comment, false positive
  /// Returns the workday number in the month of the [date].
  ///
  /// Throws if [shouldThrow] is true and [date] is not a workday (weekend:
  /// saturday or sunday).
  /// If [shouldThrow] is false and [date] is not a workday (weekend: saturday
  /// or sunday), returns 0.
  static int getWorkdayNumberInMonth(
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

  /// Adjusts a [date] to the next or previous workday.
  static DateTime adjustToWorkday(DateTime date, {required bool isNext}) {
    const workdays = EveryWeekday.workdays;
    if (workdays.valid(date)) return date;
    if (isNext) return workdays.next(date);
    return workdays.previous(date);
  }
}
