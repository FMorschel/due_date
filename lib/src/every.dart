import 'package:equatable/equatable.dart';
import 'package:time/time.dart';

import 'enums.dart';
import 'extensions.dart';

/// Abstract class that, when extended, processes [DateTime] with custom logic.
/// 
/// See [EveryWeekday], [EveryDueDayMonth], [EveryWeekdayCountInMonth] (also 
/// [WeekdayOccurrence]) and [EveryDayOfYear] for complete base implementations.
/// 
/// See [EveryWeek], [EveryMonth], [EveryYear] for your base implementations.
abstract class Every {

  /// Abstract class that, when extended, processes [DateTime] with custom logic.
  /// 
  /// See [EveryWeekday], [EveryDueDayMonth], [EveryWeekdayCountInMonth] (also 
  /// [WeekdayOccurrence]) and [EveryDayOfYear] for complete base 
  /// implementations.
  /// 
  /// See [EveryWeek], [EveryMonth], [EveryYear] for your base implementations.
  const Every();

  /// Returns the next [DateTime] that matches the [Every] pattern.
  DateTime startDate(DateTime date);

  /// Returns the next instance of the given [date] considering this [Every]
  /// base process.
  DateTime next(DateTime date);

  /// Returns the previous instance of the given [date] considering this [Every]
  /// base process.
  DateTime previous(DateTime date);
}

/// Processes [DateTime] with custom logic.
mixin EveryWeek implements Every {
  /// This mixin's implementation of [Every.next] and [Every.previous].
  DateTime addWeeks(DateTime date, int weeks);

  /// Returns the next week of the given [date] considering this [EveryWeek]
  /// implementation.
  ///
  /// Returns the next instance of the given [date] considering this [Every]
  /// base process.
  @override
  DateTime next(DateTime date) => addWeeks(date, 1);

  /// Returns the previous week of the given [date] considering this [EveryWeek]
  /// implementation.
  ///
  /// Returns the previous instance of the given [date] considering this [Every]
  /// base process.
  @override
  DateTime previous(DateTime date) => addWeeks(date, -1);
}

/// Processes [DateTime] with custom logic.
mixin EveryMonth implements Every {
  /// This mixin's implementation of [Every.next] and [Every.previous].
  DateTime addMonths(DateTime date, int months);

  /// Returns the next month of the given [date] considering this [EveryMonth]
  /// implementation.
  ///
  /// Returns the next instance of the given [date] considering this [Every]
  /// base process.
  @override
  DateTime next(DateTime date) => addMonths(date, 1);

  /// Returns the previous month of the given [date] considering this
  /// [EveryMonth] implementation.
  ///
  /// Returns the previous instance of the given [date] considering this [Every]
  /// base process.
  @override
  DateTime previous(DateTime date) => addMonths(date, -1);
}

/// Processes [DateTime] with custom logic.
mixin EveryYear implements Every {
  /// This mixin's implementation of [Every.next] and [Every.previous].
  DateTime addYears(DateTime date, int years);

  /// Returns the next year of the given [date] considering this [EveryYear]
  /// implementation.
  ///
  /// Returns the next instance of the given [date] considering this [Every]
  /// base process.
  @override
  DateTime next(DateTime date) => addYears(date, 1);

  /// Returns the previous year of the given [date] considering this [EveryYear]
  /// implementation.
  ///
  /// Returns the previous instance of the given [date] considering this [Every]
  /// base process.
  @override
  DateTime previous(DateTime date) => addYears(date, -1);
}

/// Class that processes [DateTime] so that the [addWeeks] always returns the
/// next week's with the [DateTime.weekday] equals to the [weekday].
class EveryWeekday extends Every
    with EveryWeek, EquatableMixin
    implements EveryMonth, EveryYear, Comparable<EveryWeekday> {
  
  /// Returns a [EveryWeekday] with the given [weekday].
  /// When you call [next] or [previous] on this [EveryWeekday], it will return
  /// the [weekday] of the next or previous week.
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
      return weekday.fromThisWeek(day.date).add(date.timeOfDay);
    } else {
      return weekday.fromThisWeek(day.toLocal().date).add(date.timeOfDay);
    }
  }

  /// Returns a new [DateTime] where the week is the same([Week]) inside the
  /// month and is [months] months from this week and the [DateTime.weekday] is
  /// equal to [weekday].
  @override
  DateTime addMonths(DateTime date, int months) {
    final every = EveryWeekdayCountInMonth.from(date);
    return every.addMonths(date, months);
  }

  /// Returns a new [DateTime] where the week is the same inside the month and
  /// is [years] years from this week and the [DateTime.weekday] is equal to
  /// [weekday].
  @override
  DateTime addYears(DateTime date, int years) => addMonths(date, years * 12);

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
class EveryDueDayMonth extends Every
    with EveryMonth, EquatableMixin
    implements EveryYear, Comparable<EveryDueDayMonth> {

  /// Returns a [EveryDueDayMonth] with the given [dueDay].
  /// When you call [next] or [previous] on this [EveryDueDayMonth], it will
  /// return the [dueDay] of the next or previous month.
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

  /// Returns the [date] - [DateTime.year] + [years] with the [DateTime.day] as
  /// the [dueDay], clamped to the months length.
  /// 
  /// Basically, it's the same as [addMonths] but with the months parameter
  /// multiplied by 12.
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
class EveryWeekdayCountInMonth extends Every
    with EveryMonth, EquatableMixin
    implements EveryYear, Comparable<EveryWeekdayCountInMonth> {

  /// Returns a [EveryWeekdayCountInMonth] with the given [day] and [week].
  const EveryWeekdayCountInMonth({
    required this.week,
    required this.day,
  });

  /// Returns a [EveryWeekdayCountInMonth] with the given [day] and [week] from 
  /// the given [date].
  factory EveryWeekdayCountInMonth.from(DateTime date) =>
      EveryWeekdayCountInMonth(
        day: Weekday.fromDateTimeValue(date.weekday),
        week: Week.from(date),
      );

  /// The expected week of the month.
  final Week week;

  /// The expected day of the week.
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

  /// Returns the [date] - [DateTime.year] + [years] with the [week] occurence 
  /// of the [day].
  /// 
  /// Basically, it's the same as [addMonths] but with the months parameter
  /// multiplied by 12.
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
class EveryDayOfYear extends Every
    with EveryYear, EquatableMixin
    implements Comparable<EveryDayOfYear> {

  /// Returns a [EveryDayOfYear] with the given [dayInYear].
  const EveryDayOfYear(this.dayInYear)
      : assert(
          dayInYear >= 1 && dayInYear <= 366,
          'dayInYear must be between 1 and 366',
        );

  /// The expected day in the year.
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
