import 'package:equatable/equatable.dart';
import 'package:time/time.dart';

import '../extensions/extensions.dart';
import '../helpers/helpers.dart';
import 'date_validator.dart';
import 'date_validator_mixin.dart';
import 'exact_date_validator.dart';

/// A [DateValidator] that validates a [DateTime] if the [DateTime.day] is the
/// [dayInYear] of the year.
class DateValidatorDayInYear extends ExactDateValidator
    with EquatableMixin, DateValidatorMixin
    implements Comparable<DateValidatorDayInYear> {
  /// A [DateValidator] that validates a [DateTime] if the [DateTime.day] is the
  /// [dayInYear] of the year.
  const DateValidatorDayInYear(
    this.dayInYear, {
    super.exact,
  }) : assert(
          dayInYear >= 1 && dayInYear <= 366,
          'Day In Year must be between 1 and 366',
        );

  /// A [DateValidator] that validates a [DateTime] if the [DateTime.day] is the
  /// [dayInYear] of the year.
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
