import 'package:equatable/equatable.dart';
import 'package:time/time.dart';

import '../helpers/bool_compare.dart';
import '../helpers/object_extension.dart';
import 'date_validator.dart';
import 'date_validator_mixin.dart';
import 'exact_date_validator.dart';

/// A [DateValidator] that validates a [DateTime] if the [DateTime.day] is the
/// same value as [dueDay].
/// If [exact] is false, and the [dueDay] is greater than the days in month,
/// the [DateTime] will be valid if the [DateTime.day] is the last day of the
/// month.
class DateValidatorDueDayMonth extends ExactDateValidator
    with EquatableMixin, DateValidatorMixin
    implements Comparable<DateValidatorDueDayMonth> {
  /// A [DateValidator] that validates a [DateTime] if the [DateTime.day] is the
  /// same value as [dueDay].
  /// If [exact] is false, and the [dueDay] is greater than the days in month,
  /// the [DateTime] will be valid if the [DateTime.day] is the last day of the
  /// month.
  const DateValidatorDueDayMonth(
    this.dueDay, {
    super.exact,
  }) : assert(
          (dueDay >= 1) && (dueDay <= 31),
          'Due day must be between 1 and 31',
        );

  /// A [DateValidator] that validates a [DateTime] if the [DateTime.day] is the
  /// same value as [dueDay].
  /// If [exact] is false, and the [dueDay] is greater than the days in month,
  /// the [DateTime] will be valid if the [DateTime.day] is the last day of the
  /// month.
  factory DateValidatorDueDayMonth.from(
    DateTime date, {
    bool exact = false,
  }) {
    return DateValidatorDueDayMonth(date.day, exact: exact);
  }

  /// The expected day of the month.
  final int dueDay;

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is DateValidatorDueDayMonth) &&
            (dueDay == other.dueDay) &&
            (exact == other.exact));
  }

  @override
  bool valid(DateTime date) {
    if (exact) return date.day == dueDay;
    final actualDay = dueDay.clamp(
      date.firstDayOfMonth.day,
      date.lastDayOfMonth.day,
    );
    return date.day == actualDay;
  }

  @override
  int compareTo(DateValidatorDueDayMonth other) =>
      dueDay.compareTo(other.dueDay).when2((v) => v != 0).orElse(
            (_) => boolCompareTo(exact, other.exact),
          );

  /// If true, the day of the month must be exactly this [dueDay].
  ///
  /// If false, and the [dueDay] is greater than the days in month, the
  /// [DateTime] will be valid if the [DateTime.day] is the last day of the
  /// month.
  @override
  bool get exact => super.exact;

  /// Returns whether the [DateTime] passed to [valid] or [invalid] can be
  /// inexact.
  ///
  /// If [exact] is true, this will return false.
  ///
  /// If this is false, and the month has less than [dueDay] days, the last day
  /// will be considered valid.
  @override
  bool get inexact => super.inexact;

  @override
  List<Object> get props => [dueDay, exact];
}
