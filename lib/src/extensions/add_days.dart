import 'package:time/time.dart';

import '../enums/enums.dart';
import 'previous_next.dart';

/// Extension methods related to adding or subtracting days from a [DateTime].
extension AddDays on DateTime {
  /// Returns a new [DateTime] with the given [days] added to this [DateTime].
  /// Ignoring the [Weekday]s on [ignoring].
  DateTime addDays(int days, {Iterable<Weekday> ignoring = const []}) {
    final ignoreSet = ignoring.toSet();
    if (ignoreSet.length >= Weekday.values.length) {
      throw ArgumentError.value(
        ignoring,
        'ignoring',
        'Too many ignore days, will skip forever.',
      );
    }
    final day = Weekday.fromDateTimeValue(weekday);
    if (!ignoreSet.contains(day) && (days == 0)) return this;
    final dayToAdd = (days.isNegative ? -1 : 1).days;
    final set =
        days.isNegative ? ignoreSet.nextWeekdays : ignoreSet.previousWeekdays;
    if (!set.contains(day)) {
      return add(dayToAdd).addDays(
        days.isNegative ? days + 1 : days - 1,
        ignoring: ignoreSet,
      );
    }
    return add(dayToAdd).addDays(days, ignoring: ignoreSet);
  }

  /// Returns a new [DateTime] with the given [days] subtracted from this
  /// [DateTime]. Ignoring the [Weekday]s on [ignoring].
  DateTime subtractDays(int days, {Iterable<Weekday> ignoring = const []}) {
    return addDays(-days, ignoring: ignoring);
  }

  /// Returns a new [DateTime] with the given [days] added to this [DateTime].
  /// Skipping the weekend.
  DateTime addWorkDays(int days) {
    return addDays(days, ignoring: Weekday.weekend);
  }

  /// Returns a new [DateTime] with the given [days] subtracted from this
  /// [DateTime]. Skipping the weekend.
  DateTime subtractWorkDays(int days) {
    return subtractDays(days, ignoring: Weekday.weekend);
  }
}
