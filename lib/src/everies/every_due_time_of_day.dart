import 'package:time/time.dart';

import '../date_validator.dart';
import '../extensions.dart';
import 'every_date_validator.dart';

/// {@template everyDay}
/// Class that processes [DateTime] so that [next] always returns the next day
/// with the same hour, minute, second, millisecond and microsecond as the
/// [DateTime] that is being processed.
/// {@endtemplate}
class EveryDueTimeOfDay extends DateValidatorTimeOfDay
    implements EveryDateValidator {
  /// {@macro everyDay}
  const EveryDueTimeOfDay(super.timeOfDay);

  /// Constructor that takes the time of day from [date].
  factory EveryDueTimeOfDay.from(DateTime date) {
    return EveryDueTimeOfDay(date.timeOfDay);
  }

  @override
  DateTime startDate(DateTime date) {
    if (date.timeOfDay <= timeOfDay) {
      return date.date.add(timeOfDay);
    } else {
      return next(date);
    }
  }

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