import 'package:time/time.dart';

import '../date_validators/date_validator_time_of_day.dart';
import '../extensions/add_days.dart';
import 'every_date_validator_mixin.dart';

/// {@template everyDay}
/// Class that processes [DateTime] so that [next] always returns the next day
/// with the same hour, minute, second, millisecond and microsecond as the
/// [DateTime] that is being processed.
/// {@endtemplate}
class EveryDueTimeOfDay extends DateValidatorTimeOfDay
    with EveryDateValidatorMixin {
  /// {@macro everyDay}
  const EveryDueTimeOfDay(super.timeOfDay);

  /// Constructor that takes the time of day from [date].
  factory EveryDueTimeOfDay.from(DateTime date) =>
      EveryDueTimeOfDay(date.timeOfDay);

  /// An [EveryDueTimeOfDay] that represents midnight (00:00).
  static const midnight = EveryDueTimeOfDay(Duration.zero);

  /// An [EveryDueTimeOfDay] that represents the last microsecond of the day.
  static const EveryDueTimeOfDay lastMicrosecond = EveryDueTimeOfDay(
    Duration(
      hours: 23,
      minutes: 59,
      seconds: 59,
      milliseconds: 999,
      microseconds: 999,
    ),
  );

  @override
  DateTime next(DateTime date) {
    final sameDateWithTime = date.date.add(timeOfDay);
    if (sameDateWithTime == date || sameDateWithTime.isBefore(date)) {
      return sameDateWithTime.addDays(1);
    }
    return sameDateWithTime;
  }

  @override
  DateTime previous(DateTime date) {
    final sameDateWithTime = date.date.add(timeOfDay);
    if (sameDateWithTime == date || sameDateWithTime.isAfter(date)) {
      return sameDateWithTime.subtractDays(1);
    }
    return sameDateWithTime;
  }
}
