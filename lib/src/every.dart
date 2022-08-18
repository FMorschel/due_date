import 'package:equatable/equatable.dart';
import 'package:time/time.dart';

import 'enums.dart';
import 'extensions.dart';

/// Abstract class that, when extended, processes [DateTime] with custom logic.
abstract class Every {
  const Every();
  DateTime startDate(DateTime date);
}

/// Abstract class that, when extended, processes [DateTime] with custom logic.
abstract class EveryWeek extends Every {
  const EveryWeek();
  DateTime addWeeks(DateTime date, int weeks);
}

/// Abstract class that, when extended, processes [DateTime] with custom logic.
abstract class EveryMonth extends Every {
  const EveryMonth();
  DateTime addMonths(DateTime date, int months);
}

/// Abstract class that, when extended, processes [DateTime] with custom logic.
abstract class EveryYear extends Every {
  const EveryYear();
  DateTime addYears(DateTime date, int years);
}

/// Class that processes [DateTime] so that the [addWeeks] always returns the
/// next week's with the [DateTime.weekday] equals to the [weekday].
class EveryWeekday extends EveryWeek
    with EquatableMixin
    implements Comparable<EveryWeekday> {
  const EveryWeekday(this.weekday);

  /// The expected weekday.
  final Weekday weekday;

  /// Returns the next date that fits the [weekday].
  @override
  DateTime startDate(DateTime date) {
    final day = weekday.fromThisWeek(date);
    if (day.toUtc().date.isBefore(date.toUtc().date)) {
      final nextDay = day.toUtc().add(const Duration(days: 1));
      if (date.isUtc) {
        return nextDay.nextWeekday(weekday);
      } else {
        return nextDay.toLocal().nextWeekday(weekday);
      }
    } else {
      return day;
    }
  }

  /// Returns a new [DateTime] where the week is [weeks] from this week and the
  /// [DateTime.weekday] is equal to [weekday].
  @override
  DateTime addWeeks(DateTime date, int weeks) {
    final day = date.toUtc().add(Duration(days: weeks * 7));
    if (date.isUtc) {
      return weekday.fromThisWeek(day);
    } else {
      return weekday.fromThisWeek(day.toLocal());
    }
  }

  @override
  int compareTo(EveryWeekday other) {
    return weekday.compareTo(other.weekday);
  }

  @override
  List<Object?> get props => [weekday];
}

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
class EveryDueDayMonth extends EveryMonth
    with EquatableMixin
    implements EveryYear, Comparable<EveryDueDayMonth> {
  const EveryDueDayMonth(this.dueDay)
      : assert(
          (dueDay >= 1) && (dueDay <= 31),
          'Due day must be between 1 and 31',
        );

  /// The expected day of the month.
  final int dueDay;

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
    final firstDay = date.copyWith(month: date.month + months, day: 1);
    return firstDay.copyWith(day: dueDay).clamp(
          min: firstDay,
          max: firstDay.lastDayOfMonth,
        );
  }

  @override
  DateTime addYears(DateTime date, int years) => addMonths(date, years * 12);

  @override
  int compareTo(EveryDueDayMonth other) {
    return dueDay.compareTo(other.dueDay);
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

  @override
  List<Object?> get props => [dueDay];
}

/// Class that processes [DateTime] so that the [addMonths] always returns the
/// next month's with the [week] occurence of the [day] ([DateTime.weekday]
/// is the [day]'s [Weekday.dateTimeValue]).
///
/// E.g.
/// ```dart
/// const firstMonday = EveryDayOfWeek(day: Weekday.monday, week: Week.first);
/// firstMonday.addMonths(DateTime(2020, 1, 1), 1); // DateTime(2020, 2, 3).
/// const lastFriday = EveryDayOfWeek(day: Weekday.friday, week: Week.last);
/// lastFriday.addMonths(DateTime(2020, 1, 1), 1); // DateTime(2020, 2, 28).
/// ```
class EveryWeekdayCountInMonth extends EveryMonth
    with EquatableMixin
    implements EveryYear, Comparable<EveryWeekdayCountInMonth> {
  const EveryWeekdayCountInMonth({
    required this.week,
    required this.day,
  });

  final Week week;
  final Weekday day;

  /// Returns the next date that fits the [day] and the [week].
  /// - If the current [date] - [DateTime.day] is less than the [DateTime.month]
  /// [week], it's returned the same month with the [DateTime.day] being the
  /// [day] of the [week].
  /// - If the current [date] - [DateTime.day] is greater than the [DateTime.month]
  /// [week], it's returned the next month with the [DateTime.day] being the
  /// [day] of the [week].
  @override
  DateTime startDate(DateTime date) {
    final thisMonth = addMonths(date, 0);
    if (thisMonth.compareTo(date) >= 0) {
      return thisMonth;
    } else {
      return addMonths(date, 1);
    }
  }

  /// Returns the [date] - [DateTime.month] + [months] with the [week] occurence
  /// of the [day].
  @override
  DateTime addMonths(DateTime date, int months) {
    return week
        .weekdayOf(
          year: date.year,
          month: date.month + months,
          day: day,
          utc: date.isUtc,
        )
        .add(date.timeOfDay);
  }

  @override
  DateTime addYears(DateTime date, int years) => addMonths(date, years * 12);

  @override
  int compareTo(EveryWeekdayCountInMonth other) {
    final result = week.compareTo(other.week);
    if (result == 0) {
      return day.compareTo(other.day);
    } else {
      return result;
    }
  }

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is EveryWeekdayCountInMonth) &&
            (week == other.week) &&
            (day == other.day));
  }

  @override
  List<Object?> get props => [week, day];
}

/// Class that processes [DateTime] so that the [addYears] always returns the
/// next day where the difference in days between the date and the first day of
/// the year is equal to the [dayInYear].
class EveryDayOfYear extends EveryYear
    with EquatableMixin
    implements Comparable<EveryDayOfYear> {
  const EveryDayOfYear(this.dayInYear)
      : assert(
          dayInYear >= 1 && dayInYear <= 366,
          'dayInYear must be between 1 and 366',
        );

  /// The day in the year.
  ///
  /// - The first day of the year is 1.
  /// - The last day of the year is 365/366.
  final int dayInYear;

  /// Returns the next date that fits the [dayInYear].
  @override
  DateTime startDate(DateTime date) {
    final firstDayOfYear = date.firstDayOfYear;
    final dayOfYear =
        firstDayOfYear.toUtc().add(Duration(days: dayInYear - 1)).clamp(
              max: firstDayOfYear.lastDayOfYear,
            );
    if (date.toUtc().date.isBefore(dayOfYear)) {
      return date.isUtc
          ? dayOfYear.add(date.timeOfDay)
          : dayOfYear.toLocal().add(date.timeOfDay);
    } else {
      return addYears(date, 1);
    }
  }

  /// Returns a new [DateTime] where the year is [years] from this year and the
  /// [DateTime.day] is equal to [dayInYear]-1 added to January 1st.
  @override
  DateTime addYears(DateTime date, int years) {
    final firstDaySelectedYear = date.firstDayOfYear.copyWith(
      year: date.year + years,
    );
    final dayNextYear = firstDaySelectedYear
        .toUtc()
        .add(Duration(days: dayInYear - 1))
        .clamp(max: firstDaySelectedYear.lastDayOfYear);
    return date.isUtc
        ? dayNextYear.add(date.timeOfDay)
        : dayNextYear.toLocal().add(date.timeOfDay);
  }

  @override
  int compareTo(EveryDayOfYear other) {
    return dayInYear.compareTo(other.dayInYear);
  }

  @override
  List<Object?> get props => [dayInYear];
}
