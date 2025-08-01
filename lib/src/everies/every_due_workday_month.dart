import 'package:time/time.dart';

import '../date_validators/date_validators.dart';
import '../extensions/exact_time_of_day.dart';
import '../helpers/helpers.dart';
import 'every_date_validator_mixin.dart';
import 'every_date_validator_union.dart';
import 'every_due_day_month.dart';
import 'every_month.dart';
import 'every_weekday.dart';
import 'exact_every.dart';
import 'workday_direction.dart';

/// Class that processes [DateTime] so that the [addMonths] always returns the
/// next month's with the [DateTime.day] being the [dueWorkday] workday of the
/// month clamped to fit in the length of the next month.
class EveryDueWorkdayMonth extends DateValidatorDueWorkdayMonth
    with EveryMonth, EveryDateValidatorMixin
    implements ExactEvery {
  /// Returns a [EveryDueWorkdayMonth] with the given [dueWorkday].
  ///
  /// A month can have at most 23 workdays.
  ///
  /// When you call [next] or [previous], it will return the [dueWorkday]
  /// workday of the next or previous month.
  const EveryDueWorkdayMonth(super.dueWorkday)
      : assert(
          (dueWorkday >= 1) && (dueWorkday <= 23),
          'Due workday must be between 1 and 23',
        ),
        super();

  /// Returns a [EveryDueWorkdayMonth] with the [dueWorkday] being the
  /// workday (monday, tuesday, wednesday, thursday or friday) of the given
  /// month.
  ///
  /// When you call [next] or [previous] on, it will return the [dueWorkday]
  /// workday of the next or previous month.
  ///
  /// If [direction] is [WorkdayDirection.forward], it will return the next
  /// workday if the given date is not a workday (monday).
  ///
  /// If [direction] is [WorkdayDirection.backward], it will return the previous
  /// workday if the given date is not a workday (friday).
  ///
  /// If [direction] is [WorkdayDirection.none], it will throw an
  /// [ArgumentError] if the given date is not a workday.
  factory EveryDueWorkdayMonth.from(
    DateTime date, {
    WorkdayDirection direction = WorkdayDirection.forward,
  }) {
    var local = date.copyWith();
    if (!direction.isNone) {
      local = WorkdayHelper.adjustToWorkday(date, isNext: direction.isForward);
    }
    return EveryDueWorkdayMonth(
      WorkdayHelper.getWorkdayNumberInMonth(
        local,
        shouldThrow: direction.isNone,
      ),
    );
  }

  static const EveryDateValidatorUnion<EveryWeekday> _workdays =
      WorkdayHelper.every;

  @override
  DateTime next(DateTime date) {
    return _calculate(
      date,
      dateGeneratorFunction: _workdays.next,
      isNext: true,
    );
  }

  @override
  DateTime previous(DateTime date) {
    return _calculate(
      date,
      dateGeneratorFunction: _workdays.previous,
      isNext: false,
    );
  }

  @override
  DateTime addMonths(DateTime date, int months) {
    if (months == 0) return startDate(date);
    if (months.isNegative) {
      if (months == -1) return previous(date);
      return previous(addMonths(date, months + 1));
    }
    return next(addMonths(date, months - 1));
  }

  @override
  String toString() {
    return 'EveryDueWorkdayMonth<$dueWorkday>';
  }

  DateTime _calculate(
    DateTime date, {
    required DateTime Function(DateTime date) dateGeneratorFunction,
    required bool isNext,
  }) {
    var local = WorkdayHelper.adjustToWorkday(date, isNext: isNext);
    if (local != date && valid(local)) {
      return local.date.add(date.exactTimeOfDay);
    }
    if (_shouldChangeMonth(date, isNext: isNext)) {
      local = local.copyWith(month: local.month + (isNext ? 1 : -1), day: 1);
    }
    local = _firstOrLastWorkdayOfMonth(local, first: isNext);
    while (invalid(local)) {
      local = dateGeneratorFunction(local);
    }
    return local.date.add(date.exactTimeOfDay);
  }

  DateTime _firstOrLastWorkdayOfMonth(DateTime date, {required bool first}) {
    if (first) return _workdays.startDate(date.firstDayOfMonth);
    return date.lastDayOfMonth.when(
      _workdays.valid,
      orElse: _workdays.previous,
    )!;
  }

  bool _shouldChangeMonth(DateTime date, {required bool isNext}) {
    final measuredWorkday = WorkdayHelper.getWorkdayNumberInMonth(
      WorkdayHelper.adjustToWorkday(date, isNext: isNext),
    );
    return (isNext
        ? ((measuredWorkday >= dueWorkday) ||
            (_firstOrLastWorkdayOfMonth(date, first: false) == date))
        : (measuredWorkday <= dueWorkday));
  }

  @override
  DateTime addYears(DateTime date, int years) =>
      next(const EveryDueDayMonth(1).addYears(date, years));
}
