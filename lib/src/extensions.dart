import 'package:time/time.dart';

import '../due_date.dart';
import 'every.dart';

extension AddDays on DateTime {
  /// Returns true if and only if this [weekday] is weekend.
  bool get isWeekend => Weekday.fromDateTimeValue(weekday).isWeekend;

  /// Returns true if and only if this [weekday] is workday.
  bool get isWorkDay => !isWeekend;

  /// Returns a new [DateTime] with the given [days] added to this [DateTime].
  /// Ignoring the [Weekday]s on [ignoring].
  DateTime addDays(int days, {Iterable<Weekday> ignoring = const []}) {
    final ignoreSet = ignoring.toSet();
    assert(
      ignoreSet.length < Weekday.values.length,
      'Too many ignore days, will skip forever.',
    );
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

extension WeekCalc on DateTime {
  /// Returns the [Weekday.monday] for the given [week] for the current [month].
  DateTime startOfWeek(Week week) {
    return week.weekOf(year, month);
  }

  /// Returns the next [weekday] after this.
  ///
  /// If this [DateTime.weekday] is [weekday] returns this.
  DateTime nextWeekday(Weekday weekday) {
    if (this.weekday == weekday.dateTimeValue) {
      return this;
    } else {
      return addDays(1).nextWeekday(weekday);
    }
  }

  /// Returns the previous [weekday] before this.
  ///
  /// If this [DateTime.weekday] is [weekday] returns this.
  DateTime previousWeekday(Weekday weekday) {
    if (this.weekday == weekday.dateTimeValue) {
      return this;
    } else {
      return subtractDays(1).previousWeekday(weekday);
    }
  }
}

extension ClampInMonth on DateTime {
  /// Returns a new [DueDateTime] with a [EveryDueDayMonth] based on [day].
  DueDateTime get dueDateTime => DueDateTime.fromDate(this);

  /// Returns a new [DateTime] clamped to the given [month].
  DateTime clampInMonth(DateTime month) {
    final monthStart = month.firstDayOfMonth;
    final monthEnd = monthStart.lastDayOfMonth;
    return clamp(min: monthStart, max: monthEnd);
  }
}

extension PreviousNext on Iterable<Weekday> {
  /// Returns the previous [Weekday]s in the [Iterable].
  Set<Weekday> get previousWeekdays {
    final set = <Weekday>{};
    for (final weekday in this) {
      set.add(weekday.previous);
    }
    return set;
  }

  /// Returns the next [Weekday]s in the [Iterable].
  Set<Weekday> get nextWeekdays {
    final set = <Weekday>{};
    for (final weekday in this) {
      set.add(weekday.next);
    }
    return set;
  }
}
