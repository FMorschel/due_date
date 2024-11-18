import 'package:time/time.dart';

import '../date_validators/date_validators.dart';
import 'every_date_validator.dart';
import 'every_month.dart';

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
    with EveryMonth
    implements EveryDateValidator {
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

  /// Returns the next date that fits the [dueDay].
  /// - If the [date] - [DateTime.day] is less than the [dueDay], it's returned
  /// the same month with the [DateTime.day] being [dueDay], clamped to the
  /// months length.
  /// - If the [date] - [DateTime.day] is greater than the [dueDay], it's
  /// returned the next month with the [DateTime.day] being [dueDay], clamped to
  /// the months length.
  @override
  DateTime startDate(DateTime date) {
    if (date.day == dueDay) {
      return date;
    } else if (date.day < dueDay) {
      return _thisMonthsDay(date);
    } else {
      return _nextMonthsDay(date);
    }
  }

  /// Returns the [date] - [DateTime.month] + [months] with the [DateTime.day]
  /// as the [dueDay], clamped to the months length.
  @override
  DateTime addMonths(DateTime date, int months) {
    if (months == 0) return date;
    var localMonths = months;
    var localDate = date.copyWith();
    if (!valid(localDate)) {
      if (localMonths.isNegative) {
        if (localDate.day < dueDay) {
          localDate =
              localDate.firstDayOfMonth.subtract(const Duration(days: 1));
        }
        localDate = _thisMonthsDay(localDate);
        localMonths++;
      } else {
        if (localDate.day > dueDay) {
          localDate = localDate.lastDayOfMonth.add(const Duration(days: 1));
        }
        localDate = _thisMonthsDay(localDate);
        localMonths--;
      }
    }
    final day =
        localDate.copyWith(month: localDate.month + localMonths, day: 1);
    return day.copyWith(day: dueDay).clamp(max: day.lastDayOfMonth);
  }

  @override
  String toString() {
    return 'EveryDueDayMonth<$dueDay>';
  }

  DateTime _nextMonthsDay(DateTime date) {
    final dueNextMonth = _nextMonthDueDay(date);
    final endNextMonth = _endNextMonth(date);
    return dueNextMonth.clamp(max: endNextMonth);
  }

  DateTime _nextMonthDueDay(DateTime date) {
    return date.copyWith(month: date.month + 1, day: dueDay);
  }

  DateTime _endNextMonth(DateTime date) {
    return date.copyWith(month: date.month + 1, day: 1).lastDayOfMonth;
  }

  DateTime _thisMonthsDay(DateTime date) {
    return date.copyWith(day: dueDay).clamp(max: date.lastDayOfMonth);
  }
}
