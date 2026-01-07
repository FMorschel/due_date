import 'package:time/time.dart';

import '../date_validators/date_validator_weekday.dart';
import '../enums/week.dart';
import '../enums/weekday.dart';
import '../extensions/add_days.dart';
import 'every_date_validator.dart';
import 'every_date_validator_mixin.dart';
import 'every_date_validator_union.dart';
import 'every_month.dart';
import 'every_week.dart';
import 'every_weekday_count_in_month.dart';

/// Class that processes [DateTime] so that the [addWeeks] always returns the
/// next week's with the [DateTime.weekday] equals to the [weekday].
class EveryWeekday extends DateValidatorWeekday
    with EveryWeek, EveryDateValidatorMixin
    implements EveryMonth {
  /// Returns a [EveryWeekday] with the given [weekday].
  /// When you call [next] or [previous] on this [EveryWeekday], it will return
  /// the [weekday] of the next or previous week.
  const EveryWeekday(super.weekday);

  /// Returns a [EveryWeekday] with the [weekday] being the weekday of
  /// the given [date].
  /// When you call [next] or [previous] on this [EveryWeekday], it will return
  /// the [weekday] of the next or previous week.
  factory EveryWeekday.from(DateTime date) {
    return EveryWeekday(Weekday.fromDateTimeValue(date.weekday));
  }

  /// An [EveryDateValidator] that generates a [DateTime] that is a workday.
  static const EveryDateValidatorUnion<EveryWeekday> workdays =
      EveryDateValidatorUnion(
    DateValidatorWeekday.workdays,
  );

  /// An [EveryDateValidator] that generates a [DateTime] that is a weekend.
  static const EveryDateValidatorUnion<EveryWeekday> weekend =
      EveryDateValidatorUnion(
    DateValidatorWeekday.weekend,
  );

  /// Returns the previous date that fits the [weekday].
  ///
  /// Always returns the first [DateTime] that fits the [weekday], ignoring
  /// the given [date] as an option.
  @override
  DateTime next(DateTime date) {
    if (date.weekday < weekday.dateTimeValue) return weekday.fromWeekOf(date);
    return weekday.fromWeekOf(
      date.lastDayOfWeek.addDays(1).add(date.timeOfDay),
    );
  }

  /// Returns the previous date that fits the [weekday].
  ///
  /// Always returns the last [DateTime] that fits the [weekday], ignoring
  /// the given [date] as an option.
  @override
  DateTime previous(DateTime date) {
    if (date.weekday > weekday.dateTimeValue) return weekday.fromWeekOf(date);
    return weekday.fromWeekOf(
      date.firstDayOfWeek.subtractDays(1).add(date.timeOfDay),
    );
  }

  /// Returns a new [DateTime] where the week is [weeks] from this week and the
  /// [DateTime.weekday] is equal to [weekday].
  @override
  DateTime addWeeks(DateTime date, int weeks) {
    if (weeks == 0) return date;
    final localDate = date.copyWith();
    if (!valid(localDate)) {
      return addWeeks(startDate(date), weeks + (weeks.isNegative ? 0 : -1));
    }
    final day = localDate.toUtc().addDays(weeks * 7);
    return _solveFor(localDate, day);
  }

  /// Returns a new [DateTime] where the week is the same([Week]) inside the
  /// month and is [months] months from this week and the [DateTime.weekday] is
  /// equal to [weekday].
  @override
  DateTime addMonths(DateTime date, int months) {
    final every = EveryWeekdayCountInMonth.from(date);
    return every.addMonths(date, months);
  }

  /// Returns a new [DateTime] where the week is the same inside the month and
  /// is [years] years from this week and the [DateTime.weekday] is equal to
  /// [weekday].
  @override
  DateTime addYears(DateTime date, int years) => addMonths(date, years * 12);

  @override
  String toString() => 'EveryWeekday<$weekday>';

  /// Solves the date for the given [date] and [day].
  DateTime _solveFor(DateTime date, DateTime day) {
    if (date.isUtc) {
      return weekday.fromWeekOf(day.date).add(date.timeOfDay);
    }
    return weekday.fromWeekOf(day.toLocal().date).add(date.timeOfDay);
  }
}
