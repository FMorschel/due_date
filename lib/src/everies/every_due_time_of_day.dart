import 'package:time/time.dart';

import '../date_validators/date_validators.dart';
import '../extensions/extensions.dart';
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
  factory EveryDueTimeOfDay.from(DateTime date) =>
      EveryDueTimeOfDay(date.exactTimeOfDay);

  @override
  DateTime startDate(DateTime date) {
    if (valid(date)) return date;
    return next(date);
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
