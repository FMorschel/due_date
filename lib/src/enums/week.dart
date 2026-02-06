import 'package:time/time.dart';

import '../extensions/add_days.dart';
import '../extensions/week_calc.dart';
import '../periods/week_period.dart';
import 'weekday.dart';

/// Week occurrences inside a month.
///
/// The first week of the month is the one that contains the first day of the
/// month.
/// Sometimes the last week can be the same as the fourth.
enum Week implements Comparable<Week> {
  /// First week.
  first,

  /// Second week.
  second,

  /// Third week.
  third,

  /// Fourth week.
  fourth,

  /// Last week.
  last;

  /// Returns the [Week] constant that corresponds to the given [date].
  factory Week.from(DateTime date, {Weekday firstDayOfWeek = Weekday.monday}) {
    final firstWeekEnd =
        firstDayOfWeek.weekGenerator.of(date.firstDayOfMonth).end;
    final weekStart = firstDayOfWeek.weekGenerator.of(date).start;

    if (weekStart.compareTo(firstWeekEnd) <= 0) {
      return first;
    }
    if (weekStart.compareTo(firstWeekEnd.addDays(7)) <= 0) {
      return second;
    }
    if (weekStart.compareTo(firstWeekEnd.addDays(14)) <= 0) {
      return third;
    }
    if (weekStart.compareTo(firstWeekEnd.addDays(21)) <= 0) {
      return fourth;
    }
    return last;
  }

  /// Returns a WeekPeriod for the week of the given [year] and [month].
  WeekPeriod of(
    int year,
    int month, {
    Weekday firstDayOfWeek = Weekday.monday,
    bool utc = true,
  }) {
    final firstDayOfMonth =
        utc ? DateTime.utc(year, month) : DateTime(year, month);
    switch (this) {
      case first:
        return firstDayOfWeek.weekGenerator.of(firstDayOfMonth);
      case second:
        return firstDayOfWeek.weekGenerator.of(firstDayOfMonth.addDays(7));
      case third:
        return firstDayOfWeek.weekGenerator.of(firstDayOfMonth.addDays(14));
      case fourth:
        return firstDayOfWeek.weekGenerator.of(firstDayOfMonth.addDays(21));
      case last:
        final fourthWeek =
            fourth.of(year, month, firstDayOfWeek: firstDayOfWeek, utc: utc);
        if (fourthWeek.end.date.isBefore(firstDayOfMonth.lastDayOfMonth)) {
          return firstDayOfWeek.weekGenerator
              .of(firstDayOfMonth.lastDayOfMonth);
        }
        return fourthWeek;
    }
  }

  /// Returns the [DateTime] for [day] of the week of the selected week for the
  /// given [year] and [month].
  DateTime weekdayOf({
    required int year,
    required int month,
    required Weekday day,
    bool utc = true,
  }) {
    late final DateTime firstDayOfMonth;
    if (utc) {
      firstDayOfMonth = DateTime.utc(year, month);
    } else {
      firstDayOfMonth = DateTime(year, month);
    }
    var weekDay = firstDayOfMonth.nextWeekday(day);
    for (final week in [first, second, third, fourth]) {
      if (week == this) {
        return weekDay;
      }
      weekDay = weekDay.addDays(1).nextWeekday(day);
    }
    if (weekDay.compareTo(firstDayOfMonth.lastDayOfMonth) <= 0) {
      return weekDay;
    }
    return weekDay.subtractDays(1).previousWeekday(day);
  }

  @override
  int compareTo(Week other) => index.compareTo(other.index);

  /// Returns true if this is after [other].
  bool operator >(Week other) => index > other.index;

  /// Returns true if this is after or equal to [other].
  bool operator >=(Week other) => index >= other.index;

  /// Returns true if this is before than [other].
  bool operator <(Week other) => index < other.index;

  /// Returns true if this is before or equal to [other].
  bool operator <=(Week other) => index <= other.index;

  /// Returns the [Week] that corresponds to this added [weeks].
  /// Eg.:
  ///  - [first] + `1` returns [second].
  ///  - [fourth] + `3` returns [second].
  Week operator +(int weeks) => Week.values[(index + weeks) % values.length];

  /// Returns the [Week] that corresponds to this subtracted [weeks].
  /// Eg.:
  ///  - [second] - `1` returns [first].
  ///  - [second] - `3` returns [fourth].
  Week operator -(int weeks) => Week.values[(index - weeks) % values.length];

  /// Returns the [Week] previous to this.
  Week get previous {
    if (index == first.index) {
      return last;
    }
    return Week.values[index - 1];
  }

  /// Returns the [Week] next to this.
  Week get next {
    if (index == last.index) {
      return first;
    }
    return Week.values[index + 1];
  }
}
