import 'package:equatable/equatable.dart';
import 'package:time/time.dart';

import '../../extensions/day_in_year.dart';
import '../../helpers/bool_compare.dart';
import '../../helpers/object_extension.dart';
import '../date_validator.dart';
import '../date_validator_mixin.dart';
import '../exact_date_validator.dart';

/// {@template dateValidatorDayInYear}
/// A [DateValidator] that validates a [DateTime] if the [DateTime.day] is the
/// [dayInYear] of the year.
///
/// If [exact] is false, and the [dayInYear] is greater than the days in year,
/// the [DateTime] will be valid if the [DateTime.day] is the last day of the
/// year.
/// {@endtemplate}
class DateValidatorDayInYear extends ExactDateValidator
    with EquatableMixin, DateValidatorMixin
    implements Comparable<DateValidatorDayInYear> {
  /// {@macro dateValidatorDayInYear}
  const DateValidatorDayInYear(
    this.dayInYear, {
    super.exact,
  }) : assert(
          dayInYear >= 1 && dayInYear <= 366,
          'Day In Year must be between 1 and 366',
        );

  /// Returns a [DateValidator] that validates a [DateTime] if the
  /// [DateTime.day] is the [dayInYear] of the year, clamped to the year's
  /// length.
  factory DateValidatorDayInYear.from(
    DateTime date, {
    bool exact = false,
  }) {
    return DateValidatorDayInYear(date.dayInYear, exact: exact);
  }

  /// The expected day in the year.
  ///
  /// - The first day of the year is 1.
  /// - The last day of the year is 365/366.
  final int dayInYear;

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is DateValidatorDayInYear) &&
            (dayInYear == other.dayInYear) &&
            (exact == other.exact));
  }

  @override
  bool valid(DateTime date) {
    if (exact) return date.dayInYear == dayInYear;
    final actualDay = dayInYear.clamp(
      date.firstDayOfYear.dayInYear,
      date.lastDayOfYear.dayInYear,
    );
    return date.dayInYear == actualDay;
  }

  @override
  int compareTo(DateValidatorDayInYear other) => dayInYear
      .compareTo(other.dayInYear)
      .when2((v) => v != 0)
      .orElse((_) => boolCompareTo(exact, other.exact));

  @override
  List<Object> get props => [dayInYear, exact];
}
