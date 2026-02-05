import 'package:time/time.dart';

import '../../date_validators/built_in/date_validator_due_day_month.dart';
import '../every_date_validator_mixin.dart';
import '../every_month.dart';

/// Class that processes [DateTime] so that the [addMonths] always returns the
/// next month's with the [DateTime.day] as the [dueDay] clamped to fit in the
/// length of the next month.
///
/// E.g.
/// - If the [dueDay] is 31 and the next month end at 28, the [addMonths] will
/// return the next month with the [DateTime.day] as 28.
/// - If the [dueDay] is 31 and the next month end at 31, the [addMonths] will
/// return the next month with the [DateTime.day] as 31.
/// - If the [dueDay] is 15, the [addMonths] will return the next month with the
/// [DateTime.day] as 15.
class EveryDueDayMonth extends DateValidatorDueDayMonth
    with EveryMonth, EveryDateValidatorMixin {
  /// Returns a [EveryDueDayMonth] with the given [dueDay].
  /// When you call [next] or [previous] on this [EveryDueDayMonth], it will
  /// return the [dueDay] of the next or previous month.
  const EveryDueDayMonth(super.dueDay)
      : assert(
          (dueDay >= 1) && (dueDay <= 31),
          'Due day must be between 1 and 31',
        ),
        super(exact: false);

  /// Returns a [EveryDueDayMonth] with the [dueDay] being the [DateTime.day] of
  /// the given [date].
  /// When you call [next] or [previous] on this [EveryDueDayMonth], it will
  /// return the [dueDay] of the next or previous month.
  factory EveryDueDayMonth.from(DateTime date) => EveryDueDayMonth(date.day);

  /// Returns the [date] - [DateTime.month] + [months] with the [DateTime.day]
  /// as the [dueDay], clamped to the months length.
  @override
  DateTime addMonths(DateTime date, int months) {
    if (months == 0) return date;
    if (months.isNegative) return addMonths(previous(date), months + 1);
    return addMonths(next(date), months - 1);
  }

  @override
  DateTime addYears(DateTime date, int years) => addMonths(date, years * 12);

  @override
  DateTime next(DateTime date) {
    if (date.day < dueDay) {
      return _monthsDay(date, monthDelta: 0);
    }
    return _monthsDay(date, monthDelta: 1);
  }

  @override
  DateTime previous(DateTime date) {
    if (date.day > dueDay) {
      return _monthsDay(date, monthDelta: 0);
    }
    return _monthsDay(date, monthDelta: -1);
  }

  /// Returns the next date that fits the [dueDay].
  /// - If the [date] - [DateTime.day] is less than the [dueDay], it's returned
  /// the same month with the [DateTime.day] being [dueDay], clamped to the
  /// months length.
  /// - If the [date] - [DateTime.day] is greater than the [dueDay], it's
  /// returned the next month with the [DateTime.day] being [dueDay], clamped to
  /// the months length.
  @override
  DateTime startDate(DateTime date) => super.startDate(date);

  @override
  String toString() {
    return 'EveryDueDayMonth<$dueDay>';
  }

  DateTime _monthsDay(DateTime date, {required int monthDelta}) {
    final dueMonth = date.copyWith(month: date.month + monthDelta, day: dueDay);
    final endMonth = date
        .copyWith(
          month: date.month + monthDelta,
          day: 1,
        )
        .lastDayOfMonth
        .add(date.timeOfDay);
    return dueMonth.clamp(max: endMonth);
  }
}
