import '../date_validators/date_validators.dart';
import '../enums/enums.dart';
import '../extensions/extensions.dart';
import 'every_date_validator.dart';
import 'every_month.dart';

/// Class that processes [DateTime] so that the [addMonths] always returns the
/// next month's with the [week] occurrence of the [day] ([DateTime.weekday]
/// is the [day]'s [Weekday.dateTimeValue]).
///
/// E.g.
/// ```dart
/// const firstMonday = EveryDayOfWeek(day: Weekday.monday, week: Week.first);
/// firstMonday.addMonths(DateTime(2020, 1, 1), 1); // DateTime(2020, 2, 3).
/// const lastFriday = EveryDayOfWeek(day: Weekday.friday, week: Week.last);
/// lastFriday.addMonths(DateTime(2020, 1, 1), 1); // DateTime(2020, 2, 28).
/// ```
class EveryWeekdayCountInMonth extends DateValidatorWeekdayCountInMonth
    with EveryMonth
    implements EveryDateValidator {
  /// Returns a [EveryWeekdayCountInMonth] with the given [day] and [week].
  const EveryWeekdayCountInMonth({
    required super.week,
    required super.day,
  });

  /// Returns a [EveryWeekdayCountInMonth] with the given [day] and [week] from
  /// the given [date].
  factory EveryWeekdayCountInMonth.from(DateTime date) {
    return EveryWeekdayCountInMonth(
      day: Weekday.fromDateTimeValue(date.weekday),
      week: Week.from(date),
    );
  }

  /// Returns the next date that fits the [day] and the [week].
  /// - If the current [date] - [DateTime.day] is less than the [DateTime.month]
  /// [week], it's returned the same month with the [DateTime.day] being the
  /// [day] of the [week].
  /// - If the current [date] - [DateTime.day] is greater than the
  /// [DateTime.month], [week], it's returned the next month with the
  /// [DateTime.day] being the [day] of the [week].
  @override
  DateTime startDate(DateTime date) {
    if (valid(date)) return date;
    return next(date);
  }

  /// Returns the next date that fits the [day] and the [week].
  /// - If the current [date] - [DateTime.day] is less than the [DateTime.month]
  /// [week], it's returned the same month with the [DateTime.day] being the
  /// [day] of the [week].
  /// - If the current [date] - [DateTime.day] is greater than the
  /// [DateTime.month], [week], it's returned the next month with the
  /// [DateTime.day] being the [day] of the [week].
  @override
  DateTime next(DateTime date) {
    final thisMonthDay = week
        .weekdayOf(
          year: date.year,
          month: date.month,
          day: day,
          utc: date.isUtc,
        )
        .add(date.exactTimeOfDay);
    if (date.day < thisMonthDay.day) return thisMonthDay;
    return week
        .weekdayOf(
          year: date.year,
          month: date.month + 1,
          day: day,
          utc: date.isUtc,
        )
        .add(date.exactTimeOfDay);
  }

  /// Returns the previous date that fits the [day] and the [week].
  /// - If the current [date] - [DateTime.day] is less than the [DateTime.month]
  /// [week], it's returned the same month with the [DateTime.day] being the
  /// [day] of the [week].
  /// - If the current [date] - [DateTime.day] is greater than the
  /// [DateTime.month], [week], it's returned the previous month with the
  /// [DateTime.day] being the [day] of the [week].
  @override
  DateTime previous(DateTime date) {
    final thisMonthDay = week
        .weekdayOf(
          year: date.year,
          month: date.month,
          day: day,
          utc: date.isUtc,
        )
        .add(date.exactTimeOfDay);
    if (date.day > thisMonthDay.day) return thisMonthDay;
    return week
        .weekdayOf(
          year: date.year,
          month: date.month - 1,
          day: day,
          utc: date.isUtc,
        )
        .add(date.exactTimeOfDay);
  }

  /// Returns the [date] - [DateTime.month] + [months] with the [week]
  /// occurrence of the [day].
  @override
  DateTime addMonths(DateTime date, int months) {
    if (months == 0) return startDate(date);
    var localMonths = months;
    var localDate = startDate(date);
    if (localMonths.isNegative) {
      while (localMonths < 0) {
        localDate = previous(localDate);
        localMonths++;
      }
    } else {
      while (localMonths > 0) {
        localDate = next(localDate);
        localMonths--;
      }
    }
    return localDate;
  }

  @override
  String toString() {
    return 'EveryWeekdayCountInMonth<$week, $day>';
  }

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is EveryWeekdayCountInMonth) &&
            (week == other.week) &&
            (day == other.day));
  }
}
