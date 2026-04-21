import 'package:meta/meta.dart';

import '../enums/week.dart';
import '../enums/weekday.dart';
import '../enums/weekday_occurrence.dart';
import 'built_in/every_day_in_year.dart';
import 'built_in/every_due_day_month.dart';
import 'built_in/every_due_time_of_day.dart';
import 'built_in/every_due_workday_month.dart';
import 'built_in/every_weekday.dart';
import 'built_in/every_weekday_count_in_month.dart';
import 'every_date_validator.dart';
import 'every_month.dart';
import 'every_week.dart';
import 'every_year.dart';
import 'group/every_date_validator_difference.dart';
import 'group/every_date_validator_intersection.dart';
import 'group/every_date_validator_union.dart';

/// Abstract class that, when extended, processes [DateTime] with custom logic.
///
/// See [EveryWeekday], [EveryDueDayMonth], [EveryWeekdayCountInMonth] (also
/// [WeekdayOccurrence]) and [EveryDayInYear] for complete base implementations.
///
/// See [EveryWeek], [EveryMonth], [EveryYear] for your base implementations.
@immutable
abstract class Every {
  /// Abstract class that, when extended, processes [DateTime] with custom
  /// logic.
  ///
  /// See [EveryWeekday], [EveryDueDayMonth], [EveryWeekdayCountInMonth] (also
  /// [WeekdayOccurrence]) and [EveryDayInYear] for complete base
  /// implementations.
  ///
  /// See [EveryWeek], [EveryMonth], [EveryYear] for your base implementations.
  const Every();

  /// {@macro every_weekday}
  const factory Every.weekday(Weekday weekday) = EveryWeekday;

  /// {@macro every_due_day_month}
  const factory Every.dueDayMonth(int dueDay) = EveryDueDayMonth;

  /// {@macro every_day_in_year}
  const factory Every.dayInYear(int dayInYear) = EveryDayInYear;

  /// {@macro every_weekday_count_in_month}
  const factory Every.weekdayCountInMonth({
    required Week week,
    required Weekday day,
  }) = EveryWeekdayCountInMonth;

  /// {@macro every_due_workday_month}
  const factory Every.dueWorkdayMonth(int workday) = EveryDueWorkdayMonth;

  /// {@macro every_time_of_day}
  const factory Every.dueTimeOfDay(Duration timeOfDay) = EveryDueTimeOfDay;

  /// {@macro every_date_validator_union}
  const factory Every.union(List<EveryDateValidator> everies) =
      EveryDateValidatorUnion;

  /// {@macro every_date_validator_intersection}
  const factory Every.intersection(List<EveryDateValidator> everies) =
      EveryDateValidatorIntersection;

  /// {@macro every_date_validator_difference}
  const factory Every.difference(List<EveryDateValidator> everies) =
      EveryDateValidatorDifference;

  /// {@template next}
  /// Returns the next instance of the given [date] considering this [Every]
  /// base process.
  ///
  /// If the [date] is a [DateTime] that matches the [Every] pattern, a new
  /// [DateTime] will be generated.
  /// {@endtemplate}
  DateTime next(DateTime date);

  /// {@template previous}
  /// Returns the previous instance of the given [date] considering this [Every]
  /// base process.
  ///
  /// If the [date] is a [DateTime] that matches the [Every] pattern, a new
  /// [DateTime] will be generated.
  /// {@endtemplate}
  DateTime previous(DateTime date);
}
