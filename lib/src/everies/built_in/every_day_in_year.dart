import 'package:time/time.dart';

import '../../date_validators/built_in/date_validator_day_in_year.dart';
import '../../extensions/day_in_year.dart';
import '../every_date_validator_mixin.dart';
import '../every_year.dart';

/// Class that processes [DateTime] so that the [addYears] always returns the
/// next day where the difference in days between the date and the first day of
/// the year is equal to the [dayInYear].
class EveryDayInYear extends DateValidatorDayInYear
    with EveryYear, EveryDateValidatorMixin {
  /// Returns a [EveryDayInYear] with the given [dayInYear].
  const EveryDayInYear(super.dayInYear)
      : assert(
          dayInYear >= 1 && dayInYear <= 366,
          'Day In Year must be between 1 and 366',
        ),
        super(exact: false);

  /// Returns a [EveryDayInYear] with the [dayInYear] calculated by the given
  /// [date].
  factory EveryDayInYear.from(DateTime date) {
    return EveryDayInYear(date.dayInYear);
  }

  /// Returns a new [DateTime] where the year is [years] from this year and the
  /// [DateTime.day] is equal to [dayInYear]-1 added to January 1st.
  @override
  DateTime addYears(DateTime date, int years) {
    if (years == 0) return startDate(date);
    var localYears = years;
    var localDate = startDate(date);
    if (localYears.isNegative) {
      while (localYears < 0) {
        localDate = previous(localDate);
        localYears++;
      }
    } else {
      while (localYears > 0) {
        localDate = next(localDate);
        localYears--;
      }
    }
    return localDate;
  }

  /// Returns the next date that fits the [dayInYear].
  /// - If the current [date] - [DayInYear.dayInYear] is less than the
  /// [dayInYear], it's returned the same year with the [DayInYear.dayInYear]
  /// being the [dayInYear].
  /// - If the current [date] - [DayInYear.dayInYear] is greater than the
  /// [dayInYear], it's returned the next year with the [DayInYear.dayInYear]
  /// being the [dayInYear].
  @override
  DateTime next(DateTime date) {
    final thisYearDay = date.firstDayOfYear
        .add(Duration(days: dayInYear - 1))
        .clamp(max: date.lastDayOfYear)
        .add(date.timeOfDay);
    if (date.dayInYear < dayInYear) return thisYearDay;
    return date
        .copyWith(year: date.year + 1)
        .firstDayOfYear
        .add(Duration(days: dayInYear - 1))
        .clamp(max: date.copyWith(year: date.year + 1).lastDayOfYear)
        .add(date.timeOfDay);
  }

  /// Returns the previous date that fits the [dayInYear].
  /// - If the current [date] - [DayInYear.dayInYear] is greater than the
  /// [dayInYear], it's returned the same year with the [DayInYear.dayInYear]
  /// being the [dayInYear].
  /// - If the current [date] - [DayInYear.dayInYear] is less than the
  /// [dayInYear], it's returned the previous year with the
  /// [DayInYear.dayInYear] being the [dayInYear].
  @override
  DateTime previous(DateTime date) {
    final thisYearDay = date.firstDayOfYear
        .add(Duration(days: dayInYear - 1))
        .clamp(max: date.lastDayOfYear)
        .add(date.timeOfDay);
    if (date.dayInYear > dayInYear) return thisYearDay;
    return date
        .copyWith(year: date.year - 1)
        .firstDayOfYear
        .add(Duration(days: dayInYear - 1))
        .clamp(max: date.copyWith(year: date.year - 1).lastDayOfYear)
        .add(date.timeOfDay);
  }

  /// Returns the next date that fits the [dayInYear].
  /// - If the current [date] - [DayInYear.dayInYear] is equal to `zero`,
  /// [date] is returned.
  /// - If the current [date] - [DayInYear.dayInYear] is less than the
  /// [dayInYear], it's returned the same year with the [DayInYear.dayInYear]
  /// being the [dayInYear].
  /// - If the current [date] - [DayInYear.dayInYear] is greater than the
  /// [dayInYear], it's returned the next year with the [DayInYear.dayInYear]
  /// being the [dayInYear].
  @override
  DateTime startDate(DateTime date) => super.startDate(date);

  @override
  String toString() {
    return 'EveryDayInYear<$dayInYear>';
  }
}
