import 'package:time/time.dart';

import '../date_validators/date_validator_union.dart';
import '../everies/built_in/every_weekday.dart';
import '../everies/group/every_date_validator_union.dart';

/// Helper class to work with workdays.
abstract class WorkdayHelper {
  /// An every that generates workdays (monday to friday).
  static const EveryDateValidatorUnion<EveryWeekday> every =
      EveryWeekday.workdays;

  /// A date validator that validates workdays (monday to friday).
  static const DateValidatorUnion<EveryWeekday> dateValidator = every;

  // ignore: format-comment, false positive
  /// {@template getWorkdayNumberInMonth}
  /// Returns the workday number in the month of the [date].
  ///
  /// Throws if [shouldThrow] is true and [date] is not a workday (weekend:
  /// saturday or sunday).
  /// If [shouldThrow] is false and [date] is not a workday (weekend: saturday
  /// or sunday), returns 0.
  /// {@endtemplate}
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

  /// {@template adjustToWorkday}
  /// Adjusts a [date] to the next or previous workday.
  /// {@endtemplate}
  static DateTime adjustToWorkday(DateTime date, {required bool isNext}) {
    const workdays = EveryWeekday.workdays;
    if (workdays.valid(date)) return date;
    if (isNext) return workdays.next(date);
    return workdays.previous(date);
  }
}
