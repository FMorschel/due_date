import 'package:time/time.dart';

import '../date_validators/date_validators.dart';
import '../enums/enums.dart';
import '../enums/weekday.dart';
import '../helpers/helpers.dart';
import 'every_date_validator.dart';
import 'every_month.dart';
import 'exact_every.dart';
import 'workday_direction.dart';

/// Class that processes [DateTime] so that the [addMonths] always returns the
/// next month's with the [DateTime.day] being the [dueWorkday] workday of the
/// month clamped to fit in the length of the next month.
class EveryDueWorkdayMonth extends DateValidatorDueWorkdayMonth
    with EveryMonth
    implements EveryDateValidator, ExactEvery {
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

  static const _workdays = WorkdayHelper.every;
  static final _workdaysInWeek = _workdays.length;

  @override
  DateTime startDate(DateTime date) {
    if (valid(date)) return date;
    return next(date);
  }

  @override
  DateTime next(DateTime date) {
    return _calculate(
      date,
      dateGeneratorFunction: _getNextDate,
      isNext: true,
    );
  }

  @override
  DateTime previous(DateTime date) {
    return _calculate(
      date,
      dateGeneratorFunction: _getPreviousDate,
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
    var local = date.copyWith();
    local = WorkdayHelper.adjustToWorkday(local, isNext: isNext);
    if (local != date && valid(local)) return local;
    if (_shouldChangeMonth(date, isNext: isNext)) {
      local = local.copyWith(month: local.month + (isNext ? 1 : -1), day: 1);
    }
    local = _firstOrLastWorkdayOfMonth(local, first: isNext);
    while (invalid(local)) {
      local = dateGeneratorFunction(local);
    }
    return local;
  }

  DateTime _getNextDate(DateTime date) {
    return _getDate(
      date,
      isNext: true,
      condition: (measuredWorkday) => dueWorkday > measuredWorkday,
    );
  }

  DateTime _getPreviousDate(DateTime date) {
    return _getDate(
      date,
      isNext: false,
      condition: (measuredWorkday) => measuredWorkday > dueWorkday,
    );
  }

  DateTime _getDate(
    DateTime date, {
    required bool isNext,
    required bool Function(int measuredWorkday) condition,
  }) {
    final measuredWorkday = WorkdayHelper.getWorkdayNumberInMonth(date);
    if (condition(measuredWorkday)) {
      return _skipWeekIfPossible(
        date,
        isNext: isNext,
        measuredWorkday: measuredWorkday,
      );
    }
    return _firstOrLastWorkdayOfMonth(date, first: isNext);
  }

  DateTime _firstOrLastWorkdayOfMonth(DateTime date, {required bool first}) {
    if (first) return _workdays.startDate(date.firstDayOfMonth);
    return date.lastDayOfMonth.when(
      _workdays.valid,
      orElse: _workdays.previous,
    )!;
  }

  DateTime _skipWeekIfPossible(
    DateTime date, {
    required bool isNext,
    int? measuredWorkday,
  }) {
    measuredWorkday ??= WorkdayHelper.getWorkdayNumberInMonth(date);
    if (_isDifferenceGreaterOrEqualToWeekSize(
      measuredWorkday,
      isNext: isNext,
    )) {
      final currentEvery = Weekday.from(date).every;
      return isNext ? currentEvery.next(date) : currentEvery.previous(date);
    }
    return isNext ? _workdays.next(date) : _workdays.previous(date);
  }

  bool _isDifferenceGreaterOrEqualToWeekSize(
    int measuredWorkday, {
    required bool isNext,
  }) {
    if (isNext) return (measuredWorkday - dueWorkday) >= _workdaysInWeek;
    return (dueWorkday - measuredWorkday) >= _workdaysInWeek;
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
}
