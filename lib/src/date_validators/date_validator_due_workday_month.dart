import 'package:equatable/equatable.dart';
import 'package:time/time.dart';

import '../everies/built_in/every_weekday.dart';
import '../everies/group/every_date_validator_union.dart';
import '../everies/workday_direction.dart';
import '../helpers/workday_helper.dart';
import 'date_validator.dart';
import 'date_validator_mixin.dart';
import 'exact_date_validator.dart';

/// A [DateValidator] that validates a [DateTime] if the [DateTime.day] is the
/// same value as [dueWorkday].
/// If [exact] is false, and the [dueWorkday] is greater than the days in month,
/// the [DateTime] will be valid if the [DateTime.day] is the last day of the
/// month.
class DateValidatorDueWorkdayMonth extends ExactDateValidator
    with EquatableMixin, DateValidatorMixin
    implements Comparable<DateValidatorDueWorkdayMonth> {
  /// A [DateValidator] that validates a [DateTime] if the [DateTime.day] is the
  /// same value as [dueWorkday].
  /// If [exact] is false, and the [dueWorkday] is greater than the days in
  /// month, the [DateTime] will be valid if the [DateTime.day] is the last day
  /// of the month.
  const DateValidatorDueWorkdayMonth(
    this.dueWorkday, {
    super.exact,
  }) : assert(
          (dueWorkday >= 1) && (dueWorkday <= 23),
          'Due workday must be between 1 and 23',
        );

  /// A [DateValidator] that validates a [DateTime] if the [DateTime.day] is the
  /// same value as [dueWorkday].
  /// If [exact] is false, and the [dueWorkday] is greater than the days in
  /// month, the [DateTime] will be valid if the [DateTime.day] is the last day
  /// of the month.
  factory DateValidatorDueWorkdayMonth.from(
    DateTime date, {
    WorkdayDirection direction = WorkdayDirection.forward,
    bool exact = false,
  }) {
    var local = date.copyWith();
    if (!direction.isNone) {
      local = WorkdayHelper.adjustToWorkday(date, isNext: direction.isForward);
    }
    return DateValidatorDueWorkdayMonth(
      WorkdayHelper.getWorkdayNumberInMonth(
        local,
        shouldThrow: direction.isNone,
      ),
      exact: exact,
    );
  }

  static const EveryDateValidatorUnion<EveryWeekday> _workdays =
      WorkdayHelper.every;

  /// The expected workday of the month.
  final int dueWorkday;

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is DateValidatorDueWorkdayMonth) &&
            (dueWorkday == other.dueWorkday) &&
            (exact == other.exact));
  }

  @override
  bool valid(DateTime date) {
    if (_workdays.invalid(date)) return false;
    final count = WorkdayHelper.getWorkdayNumberInMonth(date);
    if (count == dueWorkday) return true;
    if (exact) return false;
    var local = date.copyWith();
    local = _workdays.next(date);
    if (!local.isAtSameMonthAs(date) && count < dueWorkday) return true;
    return false;
  }

  @override
  int compareTo(DateValidatorDueWorkdayMonth other) =>
      dueWorkday.compareTo(other.dueWorkday);

  /// Returns whether the [DateTime] passed to [valid] or [invalid] can be
  /// inexact.
  ///
  /// If [exact] is true, this will return false.
  ///
  /// If this is false, and the month has less than [dueWorkday] workdays, the
  /// last workday will be considered valid.
  @override
  bool get inexact => super.inexact;

  /// If true, the workday of the month must be exactly this [dueWorkday].
  /// If false, and the [dueWorkday] is greater than the workdays in month, the
  /// [DateTime] will be valid if the [DateTime.day] is the last workday of the
  /// month.
  @override
  bool get exact => super.exact;

  @override
  List<Object> get props => [dueWorkday, exact];
}
