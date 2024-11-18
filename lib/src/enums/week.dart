import 'package:time/time.dart';

import '../extensions/extensions.dart';
import '../period.dart';
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
  factory Week.from(DateTime date) {
    const weekDuration = Duration(days: 7);
    final seventhDayOfMonth = date.toUtc().firstDayOfMonth.add(
          const Duration(days: 6),
        );
    final monday = date.toUtc().firstDayOfWeek;
    if (monday.compareTo(seventhDayOfMonth) <= 0) {
      return first;
    } else if (monday.compareTo(seventhDayOfMonth.add(weekDuration)) <= 0) {
      return second;
    } else if (monday.compareTo(seventhDayOfMonth.add(weekDuration * 2)) <= 0) {
      return third;
    } else if (monday.compareTo(seventhDayOfMonth.add(weekDuration * 3)) <= 0) {
      return fourth;
    } else if (monday.compareTo(seventhDayOfMonth.add(weekDuration * 4)) <= 0) {
      return last;
    }
    throw Exception('Unsupported week');
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
        return firstDayOfWeek.weekGenerator.of(
          utc ? DateTime.utc(year, month, 8) : DateTime(year, month, 8),
        );
      case third:
        return firstDayOfWeek.weekGenerator.of(
          utc ? DateTime.utc(year, month, 15) : DateTime(year, month, 15),
        );
      case fourth:
        return firstDayOfWeek.weekGenerator.of(
          utc ? DateTime.utc(year, month, 22) : DateTime(year, month, 22),
        );
      case last:
        final fourthWeek = fourth.of(year, month);
        if (fourthWeek.end.isBefore(firstDayOfMonth.lastDayOfMonth)) {
          return firstDayOfWeek.weekGenerator.of(
            utc
                ? DateTime.utc(year, month).lastDayOfMonth
                : DateTime(year, month).lastDayOfMonth,
          );
        } else {
          return fourthWeek;
        }
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
      } else {
        weekDay = weekDay.addDays(1).nextWeekday(day);
      }
    }
    if (weekDay.compareTo(firstDayOfMonth.lastDayOfMonth) <= 0) {
      return weekDay;
    } else {
      return weekDay.subtractDays(1).previousWeekday(day);
    }
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
    if (index != first.index) {
      return Week.values[index - 1];
    } else {
      return last;
    }
  }

  /// Returns the [Week] next to this.
  Week get next {
    if (index != last.index) {
      return Week.values[index + 1];
    } else {
      return first;
    }
  }
}
