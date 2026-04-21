import 'package:meta/meta.dart';

import '../enums/week.dart';
import '../enums/weekday.dart';
import 'built_in/date_validator_day_in_year.dart';
import 'built_in/date_validator_due_day_month.dart';
import 'built_in/date_validator_due_workday_month.dart';
import 'built_in/date_validator_opposite.dart';
import 'built_in/date_validator_time_of_day.dart';
import 'built_in/date_validator_weekday.dart';
import 'built_in/date_validator_weekday_count_in_month.dart';
import 'date_validator_mixin.dart';
import 'exact_date_validator.dart';
import 'group/date_validator_difference.dart';
import 'group/date_validator_intersection.dart';
import 'group/date_validator_union.dart';

/// A class to save a specific validation for a [DateTime].
///
/// See also [ExactDateValidator].
@immutable
abstract class DateValidator {
  /// A class to save a specific validation for a [DateTime].
  const DateValidator();

  /// {@macro dateValidatorWeekday}
  const factory DateValidator.weekday(Weekday weekday) = DateValidatorWeekday;

  /// {@macro dateValidatorDueDayMonth}
  const factory DateValidator.dueDayMonth(int dueDay, {bool exact}) =
      DateValidatorDueDayMonth;

  /// {@macro dateValidatorDayInYear}
  const factory DateValidator.dayInYear(int dayInYear, {bool exact}) =
      DateValidatorDayInYear;

  /// {@macro dateValidatorWeekdayCountInMonth}
  const factory DateValidator.weekdayCountInMonth({
    required Week week,
    required Weekday day,
  }) = DateValidatorWeekdayCountInMonth;

  /// {@macro dateValidatorDueWorkdayMonth}
  const factory DateValidator.dueWorkdayMonth(int workday, {bool exact}) =
      DateValidatorDueWorkdayMonth;

  /// {@macro dateValidatorDay}
  const factory DateValidator.timeOfDay(Duration timeOfDay) =
      DateValidatorTimeOfDay;

  /// {@macro dateValidatorDay}
  const factory DateValidator.opposite(DateValidator validator) =
      DateValidatorOpposite;

  /// {@macro dateValidatorUnion}
  const factory DateValidator.union(List<DateValidator> validators) =
      DateValidatorUnion;

  /// {@macro dateValidatorIntersection}
  const factory DateValidator.intersection(List<DateValidator> validators) =
      DateValidatorIntersection;

  /// {@macro dateValidatorDifference}
  const factory DateValidator.difference(List<DateValidator> validators) =
      DateValidatorDifference;

  /// Returns true if the [date] is valid for this [DateValidator].
  ///
  /// This is the opposite of [valid].
  /// Implementations that return true for invalid should also return false for
  /// valid.
  bool valid(DateTime date);

  /// Returns true if the [date] is invalid for this [DateValidator].
  ///
  /// This is the opposite of [valid].
  /// Implementations that return true for invalid should also return false for
  /// valid.
  ///
  /// Usually, this will be implemented as `!valid(date)` by
  /// [DateValidatorMixin]. However, if there is a simpler way to check
  /// for invalid dates, it can be implemented here.
  bool invalid(DateTime date);

  /// A [DateValidator] with the opposite logic.
  DateValidator operator -();

  /// Returns the valid dates for this [DateValidator] in [dates].
  Iterable<DateTime> filterValidDates(Iterable<DateTime> dates);
}
