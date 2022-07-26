import 'package:equatable/equatable.dart';
import 'package:time/time.dart';

import 'date_validator.dart';
import 'enums.dart';
import 'extensions.dart';

/// Abstract class that, when extended, processes [DateTime] with custom logic.
///
/// See [EveryWeekday], [EveryDueDayMonth], [EveryWeekdayCountInMonth] (also
/// [WeekdayOccurrence]) and [EveryDayInYear] for complete base implementations.
///
/// See [EveryWeek], [EveryMonth], [EveryYear] for your base implementations.
abstract class Every {
  /// Abstract class that, when extended, processes [DateTime] with custom logic.
  ///
  /// See [EveryWeekday], [EveryDueDayMonth], [EveryWeekdayCountInMonth] (also
  /// [WeekdayOccurrence]) and [EveryDayInYear] for complete base
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

/// Abstract class that forces the implementation of [Every] to have a
/// limit parameter for the [startDate], [next] and [previous] methods.
abstract class LimitedEvery extends Every {
  /// Abstract class that, when extended, processes [DateTime] with custom logic.
  ///
  /// See [EveryWeekday], [EveryDueDayMonth], [EveryWeekdayCountInMonth] (also
  /// [WeekdayOccurrence]) and [EveryDayInYear] for complete base
  /// implementations.
  ///
  /// See [EveryWeek], [EveryMonth], [EveryYear] for your base implementations.
  const LimitedEvery();

  /// Returns the next [DateTime] that matches the [Every] pattern.
  @override
  DateTime startDate(DateTime date, {DateTime? limit});

  /// Returns the next instance of the given [date] considering this [Every]
  /// base process.
  @override
  DateTime next(DateTime date, {DateTime? limit});

  /// Returns the previous instance of the given [date] considering this [Every]
  /// base process.
  @override
  DateTime previous(DateTime date, {DateTime? limit});
}

/// Processes [DateTime] with custom logic.
///
/// ### WARNING:
/// Only mix in your class this if your are not mixing [EveryMonth] or
/// [EveryYear] in your class.
///
/// Mixin all three will result in strange behavior. The last one mixed will
/// override the [next] and [previous] methods.
///
/// Try to only implement the two that are not the main focus of your [Every]
/// class.
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
///
/// ### WARNING:
/// Only mix in your class this if your are not mixing [EveryWeek] or
/// [EveryYear] in your class.
///
/// Mixin all three will result in strange behavior. The last one mixed will
/// override the [next] and [previous] methods.
///
/// Try to only implement the two that are not the main focus of your [Every]
/// class.
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
///
/// ### WARNING:
/// Only mix in your class this if your are not mixing [EveryWeek] or
/// [EveryMonth] in your class.
///
/// Mixin all three will result in strange behavior. The last one mixed will
/// override the [next] and [previous] methods.
///
/// Try to only implement the two that are not the main focus of your [Every]
/// class.
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

abstract class EveryDateValidator extends Every with DateValidatorMixin {
  const EveryDateValidator();
}

/// Class that processes [DateTime] so that the [addWeeks] always returns the
/// next week's with the [DateTime.weekday] equals to the [weekday].
class EveryWeekday extends DateValidatorWeekday
    with EveryWeek
    implements EveryMonth, EveryYear, EveryDateValidator {
  /// Returns a [EveryWeekday] with the given [weekday].
  /// When you call [next] or [previous] on this [EveryWeekday], it will return
  /// the [weekday] of the next or previous week.
  const EveryWeekday(super.weekday);

  /// Returns a [EveryWeekday] with the [weekday] being the weekday of
  /// the given [date].
  /// When you call [next] or [previous] on this [EveryWeekday], it will return
  /// the [weekday] of the next or previous week.
  factory EveryWeekday.from(DateTime date) {
    return EveryWeekday(Weekday.fromDateTimeValue(date.weekday));
  }

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
    if (weeks == 0) return date;
    if (!valid(date)) {
      if (weeks.isNegative) {
        if (date.weekday < weekday.dateTimeValue) {
          date = date.firstDayOfWeek.subtract(const Duration(days: 1));
        }
        date = weekday.fromThisWeek(date);
        weeks++;
      } else {
        if (date.weekday > weekday.dateTimeValue) {
          date = date.lastDayOfWeek.add(const Duration(days: 1));
        }
        date = weekday.fromThisWeek(date);
        weeks--;
      }
    }
    final day = date.toUtc().add(Duration(days: weeks * 7));
    return _solveFor(date, day);
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
  String toString() => 'EveryWeekday<$weekday>';

  /// Solves the date for the given [date] and [day].
  DateTime _solveFor(DateTime date, DateTime day) {
    if (date.isUtc) return weekday.fromThisWeek(day.date).add(date.timeOfDay);
    return weekday.fromThisWeek(day.toLocal().date).add(date.timeOfDay);
  }
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
class EveryDueDayMonth extends DateValidatorDueDayMonth
    with EveryMonth
    implements EveryYear, EveryDateValidator {
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
    if (!valid(date)) {
      if (months.isNegative) {
        if (date.day < dueDay) {
          date = date.firstDayOfMonth.subtract(const Duration(days: 1));
        }
        date = _thisMonthsDay(date);
        months++;
      } else {
        if (date.day > dueDay) {
          date = date.lastDayOfMonth.add(const Duration(days: 1));
        }
        date = _thisMonthsDay(date);
        months--;
      }
    }
    final day = date.copyWith(month: date.month + months, day: 1);
    return day.copyWith(day: dueDay).clamp(max: day.lastDayOfMonth);
  }

  /// Returns the [date] - [DateTime.year] + [years] with the [DateTime.day] as
  /// the [dueDay], clamped to the months length.
  ///
  /// Basically, it's the same as [addMonths] but with the months parameter
  /// multiplied by 12.
  @override
  DateTime addYears(DateTime date, int years) => addMonths(date, years * 12);

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
class EveryWeekdayCountInMonth extends DateValidatorWeekdayCountInMonth
    with EveryMonth
    implements EveryYear, EveryDateValidator {
  /// Returns a [EveryWeekdayCountInMonth] with the given [day] and [week].
  const EveryWeekdayCountInMonth({
    required super.week,
    required super.day,
  });

  /// Returns a [EveryWeekdayCountInMonth] with the given [day] and [week] from
  /// the given [date].
  factory EveryWeekdayCountInMonth.from(DateTime date) {
    return EveryWeekdayCountInMonth(
      day: Weekday.fromDateTimeValue(date.weekday),
      week: Week.from(date),
    );
  }

  /// Returns the next date that fits the [day] and the [week].
  /// - If the current [date] - [DateTime.day] is less than the [DateTime.month]
  /// [week], it's returned the same month with the [DateTime.day] being the
  /// [day] of the [week].
  /// - If the current [date] - [DateTime.day] is greater than the [DateTime.month]
  /// [week], it's returned the next month with the [DateTime.day] being the
  /// [day] of the [week].
  @override
  DateTime startDate(DateTime date) {
    if (valid(date)) return date;
    final thisMonthDay = week.weekdayOf(
      year: date.year,
      month: date.day,
      day: day,
      utc: date.isUtc,
    );
    if (date.day < thisMonthDay.day) return thisMonthDay;
    return week.weekdayOf(
      year: date.year,
      month: date.month + 1,
      day: day,
      utc: date.isUtc,
    );
  }

  /// Returns the [date] - [DateTime.month] + [months] with the [week] occurence
  /// of the [day].
  @override
  DateTime addMonths(DateTime date, int months) {
    if (months == 0) return date;
    if (!valid(date)) {
      final thisMonthsDay = week.weekdayOf(
        year: date.year,
        month: date.month,
        day: day,
        utc: date.isUtc,
      );
      if (months.isNegative) {
        if (date.day < thisMonthsDay.day) {
          date = date.firstDayOfMonth.subtract(const Duration(days: 1));
          months++;
        }
      } else {
        if (date.day > thisMonthsDay.day) {
          date = date.lastDayOfMonth.add(const Duration(days: 1));
          months--;
        }
      }
    }
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
  String toString() {
    return 'EveryWeekdayCountInMonth<$week, $day>';
  }

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is EveryWeekdayCountInMonth) &&
            (week == other.week) &&
            (day == other.day));
  }
}

/// Class that processes [DateTime] so that the [addYears] always returns the
/// next day where the difference in days between the date and the first day of
/// the year is equal to the [dayInYear].
class EveryDayInYear extends DateValidatorDayInYear
    with EveryYear
    implements EveryDateValidator {
  /// Returns a [EveryDayInYear] with the given [dayInYear].
  const EveryDayInYear(super.dayInYear)
      : assert(
          dayInYear >= 1 && dayInYear <= 366,
          'Day In Year must be between 1 and 366',
        ),
        super(exact: false);

  /// Returns a [EveryDayInYear] with the [dayInYear] calculated by the given
  /// [date].
  factory EveryDayInYear.from(DateTime date) {
    return EveryDayInYear(date.dayInYear);
  }

  /// Returns the next date that fits the [dayInYear].
  @override
  DateTime startDate(DateTime date) {
    if (valid(date)) return date;
    final thisYearDay = date.firstDayOfYear
        .add(Duration(days: dayInYear - 1))
        .clamp(max: date.lastDayOfYear);
    if (date.dayInYear <= dayInYear) return thisYearDay;
    return date.lastDayOfYear
        .add(Duration(days: dayInYear))
        .clamp(max: date.copyWith(year: date.year + 1).lastDayOfYear);
  }

  /// Returns a new [DateTime] where the year is [years] from this year and the
  /// [DateTime.day] is equal to [dayInYear]-1 added to January 1st.
  @override
  DateTime addYears(DateTime date, int years) {
    if (years == 0) return date;
    if (!valid(date)) {
      final thisYearsDay = date.firstDayOfYear
          .add(Duration(days: dayInYear - 1))
          .clamp(max: date.lastDayOfYear);
      if (years.isNegative) {
        if (date.day < thisYearsDay.day) {
          date = date.firstDayOfYear.subtract(const Duration(days: 1));
          years++;
        }
      } else {
        if (date.day > thisYearsDay.day) {
          date = date.lastDayOfYear.add(const Duration(days: 1));
          years--;
        }
      }
    }
    return date.firstDayOfYear
        .copyWith(year: date.year + years)
        .add(Duration(days: dayInYear - 1))
        .clamp(max: date.copyWith(year: date.year + years).lastDayOfYear);
  }

  @override
  String toString() {
    return 'EveryDayInYear<$dayInYear>';
  }
}

/// Wrapper for [EveryDateValidator] that skips the [startDate], [next] and
/// [previous] result in a specific way.
///
/// This is an abstract class, look for [SkipCount], [SkipWhen] and
/// [SkipCountWhen] for implementations.
abstract class Skip<T extends EveryDateValidator> extends EveryDateValidator
    with EquatableMixin
    implements LimitedEvery {
  /// Wrapper for [EveryDateValidator] that skips the [startDate], [next] or
  /// [previous] result in a specific way.
  ///
  /// This is an abstract class, look for [SkipCount], [SkipWhen] and
  /// [SkipCountWhen] for implementations.
  const Skip({required this.every});

  final T every;
}

class SkipCount<T extends EveryDateValidator> extends Skip<T> {
  const SkipCount({
    required super.every,
    required this.count,
  }) : assert(count >= 0, 'Count must be greater than or equal to 0');

  final int count;

  @override
  bool valid(DateTime date) => every.valid(date);

  @override
  DateTime startDate(DateTime date, {DateTime? limit}) =>
      _startDate(every, date, limit: limit);

  @override
  DateTime next(DateTime date, {DateTime? limit}) {
    for (int i = 0; i < count; i++) {
      date = _next(every, date, limit: limit);
    }
    return date;
  }

  @override
  DateTime previous(DateTime date, {DateTime? limit}) {
    for (int i = 0; i < count; i++) {
      date = _previous(every, date, limit: limit);
    }
    return date;
  }

  @override
  String toString() {
    return 'SkipCount<$every, $count>';
  }

  SkipCount operator +(int count) => SkipCount(
        every: every,
        count: this.count + count,
      );

  SkipCount operator -(int count) => SkipCount(
        every: every,
        count: this.count - count,
      );

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is SkipCount) &&
            (every == other.every) &&
            (count == other.count));
  }

  @override
  List<Object?> get props => [every, count];
}

class SkipWhen<T extends EveryDateValidator> extends Skip<T> {
  const SkipWhen({
    required super.every,
    required this.when,
  });

  final bool Function(DateTime date) when;

  @override
  bool valid(DateTime date) {
    if (every.valid(date)) return !when(date);
    return false;
  }

  @override
  DateTime startDate(DateTime date, {DateTime? limit}) {
    date = _startDate(every, date, limit: limit);
    while (when(date)) {
      date = _next(every, date, limit: limit);
    }
    return date;
  }

  @override
  DateTime next(DateTime date, {DateTime? limit}) {
    date = _next(every, date, limit: limit);
    while (when(date)) {
      date = _next(every, date, limit: limit);
    }
    return date;
  }

  @override
  DateTime previous(DateTime date, {DateTime? limit}) {
    date = _previous(every, date, limit: limit);
    while (when(date)) {
      date = _previous(every, date, limit: limit);
    }
    return date;
  }

  @override
  String toString() {
    return 'SkipWhen<$every, $when>';
  }

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is SkipWhen) && (every == other.every) && (when == other.when));
  }

  @override
  List<Object?> get props => [every, when];
}

class SkipCountWhen<T extends EveryDateValidator> extends SkipCount<T>
    implements SkipWhen<T> {
  const SkipCountWhen({
    required super.every,
    required super.count,
    required this.when,
  }) : assert(count >= 0, 'Count must be greater than or equal to 0');

  @override
  final bool Function(DateTime date) when;

  @override
  bool valid(DateTime date) {
    if (every.valid(date)) return !when(date);
    return false;
  }

  @override
  DateTime startDate(DateTime date, {DateTime? limit}) {
    date = _startDate(every, date, limit: limit);
    while (when(date)) {
      date = super.next(date, limit: limit);
    }
    return date;
  }

  @override
  DateTime next(DateTime date, {DateTime? limit}) {
    date = _next(every, date, limit: limit);
    while (when(date)) {
      date = super.next(date, limit: limit);
    }
    return date;
  }

  @override
  DateTime previous(DateTime date, {DateTime? limit}) {
    date = _previous(every, date, limit: limit);
    while (when(date)) {
      date = super.previous(date, limit: limit);
    }
    return date;
  }

  @override
  String toString() {
    return 'SkipCountWhen<$every, $when, $count>';
  }

  @override
  SkipCountWhen operator +(int count) => SkipCountWhen(
        every: every,
        count: this.count + count,
        when: when,
      );

  @override
  SkipCountWhen operator -(int count) => SkipCountWhen(
        every: every,
        count: this.count - count,
        when: when,
      );

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is SkipCountWhen) &&
            (every == other.every) &&
            (when == other.when) &&
            (count == other.count));
  }

  @override
  List<Object?> get props => [every, when, count];
}

mixin EveryDateValidatorListMixin<E extends EveryDateValidator>
    on DateValidatorListMixin<E> {
  /// List for all of the [everies] that will be used to generate the date.
  List<EveryDateValidator> get everies => [...this];
}

/// Class that processes [DateTime] so that the [next] always returns the next
/// day where all of the [EveryDateValidator]s conditions are met.
class EveryDateValidatorIntersection<E extends EveryDateValidator>
    extends DateValidatorIntersection<E>
    with EveryDateValidatorListMixin<E>
    implements EveryDateValidator, LimitedEvery {
  /// Class that processes [DateTime] so that the [next] always returns the next
  /// day where all of the [EveryDateValidator]s conditions are met.
  const EveryDateValidatorIntersection(super.everyDateValidators);

  @override
  DateTime startDate(DateTime date, {DateTime? limit}) {
    if (isEmpty) return date;
    if ((limit != null) && (date.isAfter(limit) || (date == limit))) {
      throw DateTimeLimitReachedException(date: date, limit: limit);
    }
    final startingDates = map((every) => _startDate(every, date, limit: limit));
    final validDates = startingDates.where(valid);
    if (validDates.isNotEmpty) {
      final result = validDates.reduce(_reduceFuture);
      if ((limit != null) && (result.isAfter(limit) || (date == limit))) {
        throw DateTimeLimitReachedException(date: result, limit: limit);
      }
      return result;
    }
    return next(date, limit: limit);
  }

  @override
  DateTime next(DateTime date, {DateTime? limit}) {
    if (isEmpty) return date;
    if ((limit != null) && (date.isAfter(limit) || (date == limit))) {
      throw DateTimeLimitReachedException(date: date, limit: limit);
    }
    final nextDates = map((every) => _next(every, date, limit: limit));
    final validDates = nextDates.where(valid);
    if (validDates.isNotEmpty) {
      final result = validDates.reduce(_reduceFuture);
      if ((limit != null) && (result.isAfter(limit) || (date == limit))) {
        throw DateTimeLimitReachedException(date: result, limit: limit);
      }
      return result;
    }
    return next(nextDates.reduce(_reduceFuture), limit: limit);
  }

  @override
  DateTime previous(DateTime date, {DateTime? limit}) {
    if (isEmpty) return date;
    if ((limit != null) && (date.isBefore(limit) || (date == limit))) {
      throw DateTimeLimitReachedException(date: date, limit: limit);
    }
    final previousDates = map((every) => _previous(every, date, limit: limit));
    final validDates = previousDates.where(valid);
    if (validDates.isNotEmpty) {
      final result = validDates.reduce(_reducePast);
      if ((limit != null) && (result.isBefore(limit) || (date == limit))) {
        throw DateTimeLimitReachedException(date: result, limit: limit);
      }
      return result;
    }
    return previous(previousDates.reduce(_reducePast), limit: limit);
  }

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is EveryDateValidatorIntersection) &&
            (other.validators == validators));
  }
}

/// Class that processes [DateTime] so that the [next] always returns the next
/// day where any of the [EveryDateValidator]s conditions are met.
class EveryDateValidatorUnion<E extends EveryDateValidator>
    extends DateValidatorUnion<E>
    with EveryDateValidatorListMixin<E>
    implements EveryDateValidator, LimitedEvery {
  /// Class that processes [DateTime] so that the [next] always returns the next
  /// day where any of the [EveryDateValidator]s conditions are met.
  const EveryDateValidatorUnion(super.everyDateValidators);

  /// Returns the next [DateTime] that matches the [Every] pattern.
  ///
  /// For every one one of the [everies] that is a [LimitedEvery], the [limit]
  /// will be passed.
  /// If none of the [everies] is a [LimitedEvery], the [limit] will be ignored.
  @override
  DateTime startDate(DateTime date, {DateTime? limit}) {
    if (isEmpty) return date;
    final startingDates = map((every) => _startDate(every, date, limit: limit));
    return startingDates.reduce(_reduceFuture);
  }

  /// Returns the next instance of the given [date] considering this [Every]
  /// base process.
  ///
  /// For every one one of the [everies] that is a [LimitedEvery], the [limit]
  /// will be passed.
  /// If none of the [everies] is a [LimitedEvery], the [limit] will be ignored.
  @override
  DateTime next(DateTime date, {DateTime? limit}) {
    if (isEmpty) return date;
    final nextDates = map((every) => _next(every, date, limit: limit));
    return nextDates.reduce(_reduceFuture);
  }

  /// Returns the previous instance of the given [date] considering this [Every]
  /// base process.
  ///
  /// For every one one of the [everies] that is a [LimitedEvery], the [limit]
  /// will be passed.
  /// If none of the [everies] is a [LimitedEvery], the [limit] will be ignored.
  @override
  DateTime previous(DateTime date, {DateTime? limit}) {
    if (isEmpty) return date;
    final previousDates = map((every) => _previous(every, date, limit: limit));
    return previousDates.reduce(_reducePast);
  }

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is EveryDateValidatorUnion) &&
            (other.validators == validators));
  }
}

/// Class that processes [DateTime] so that the [next] always returns the next
/// day where only one of the [EveryDateValidator]s conditions is met.
class EveryDateValidatorDifference<E extends EveryDateValidator>
    extends DateValidatorDifference<E>
    with EveryDateValidatorListMixin<E>
    implements EveryDateValidator, LimitedEvery {
  /// Class that processes [DateTime] so that the [next] always returns the next
  /// day where only one of the [EveryDateValidator]s conditions is met.
  const EveryDateValidatorDifference(super.everyDateValidators);

  @override
  DateTime startDate(DateTime date, {DateTime? limit}) {
    if (isEmpty) return date;
    if ((limit != null) && (date.isAfter(limit) || (date == limit))) {
      throw DateTimeLimitReachedException(date: date, limit: limit);
    }
    final startingDates = map((every) => _startDate(every, date, limit: limit));
    final validDates = startingDates.where(valid);
    if (validDates.isNotEmpty) {
      final result = validDates.reduce(_reduceFuture);
      if ((limit != null) && (result.isAfter(limit) || (date == limit))) {
        throw DateTimeLimitReachedException(date: result, limit: limit);
      }
      return result;
    }
    return next(date, limit: limit);
  }

  @override
  DateTime next(DateTime date, {DateTime? limit}) {
    if (isEmpty) return date;
    if ((limit != null) && (date.isAfter(limit) || (date == limit))) {
      throw DateTimeLimitReachedException(date: date, limit: limit);
    }
    final nextDates = map((every) => _next(every, date, limit: limit));
    final validDates = nextDates.where(valid);
    if (validDates.isNotEmpty) {
      final result = validDates.reduce(_reduceFuture);
      if ((limit != null) && (result.isAfter(limit) || (date == limit))) {
        throw DateTimeLimitReachedException(date: result, limit: limit);
      }
      return result;
    }
    return next(nextDates.reduce(_reduceFuture), limit: limit);
  }

  @override
  DateTime previous(DateTime date, {DateTime? limit}) {
    if (isEmpty) return date;
    if ((limit != null) && (date.isBefore(limit) || (date == limit))) {
      throw DateTimeLimitReachedException(date: date, limit: limit);
    }
    final previousDates = map((every) => _previous(every, date, limit: limit));
    final validDates = previousDates.where(valid);
    if (validDates.isNotEmpty) {
      final result = validDates.reduce(_reducePast);
      if ((limit != null) && (result.isBefore(limit) || (date == limit))) {
        throw DateTimeLimitReachedException(date: result, limit: limit);
      }
      return result;
    }
    return previous(previousDates.reduce(_reducePast), limit: limit);
  }

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is EveryDateValidatorDifference) &&
            (other.validators == validators));
  }
}

DateTime _startDate<T extends Every>(
  T every,
  DateTime date, {
  required DateTime? limit,
}) {
  if (every is! LimitedEvery) return every.startDate(date);
  return every.startDate(date, limit: limit);
}

DateTime _next<T extends Every>(
  T every,
  DateTime date, {
  required DateTime? limit,
}) {
  if (every is! LimitedEvery) return every.next(date);
  return every.next(date, limit: limit);
}

DateTime _previous<T extends Every>(
  T every,
  DateTime date, {
  required DateTime? limit,
}) {
  if (every is! LimitedEvery) return every.previous(date);
  return every.previous(date, limit: limit);
}

DateTime _reduceFuture(DateTime value, DateTime element) {
  return value.isBefore(element) ? value : element;
}

DateTime _reducePast(DateTime value, DateTime element) {
  return value.isAfter(element) ? value : element;
}

class DateTimeLimitReachedException implements Exception {
  const DateTimeLimitReachedException({
    required this.date,
    required this.limit,
  });

  final DateTime date;
  final DateTime limit;

  @override
  String toString() {
    return 'DateTimeLimitException: $date has passed $limit';
  }
}
