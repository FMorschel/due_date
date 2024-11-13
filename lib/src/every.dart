import 'package:meta/meta.dart';
import 'package:time/time.dart';

import 'constants.dart';
import 'date_validator.dart';
import 'enums.dart';
import 'extensions.dart';

/// Abstract class that, when extended, processes [DateTime] with custom logic.
///
/// See [EveryWeekday], [EveryDueDayMonth], [EveryWeekdayCountInMonth] (also
/// [WeekdayOccurrence]) and [EveryDayInYear] for complete base implementations.
///
/// See [EveryWeek], [EveryMonth], [EveryYear] for your base implementations.
@immutable
abstract class Every {
  /// Abstract class that, when extended, processes [DateTime] with custom
  /// logic.
  ///
  /// See [EveryWeekday], [EveryDueDayMonth], [EveryWeekdayCountInMonth] (also
  /// [WeekdayOccurrence]) and [EveryDayInYear] for complete base
  /// implementations.
  ///
  /// See [EveryWeek], [EveryMonth], [EveryYear] for your base implementations.
  const Every();

  /// {@template startDate}
  /// Returns the next [DateTime] that matches the [Every] pattern.
  ///
  /// If the [date] is a [DateTime] that matches the [Every] pattern, the
  /// [DateTime] will be returned.
  /// {@endtemplate}
  DateTime startDate(DateTime date);

  /// {@template next}
  /// Returns the next instance of the given [date] considering this [Every]
  /// base process.
  ///
  /// If the [date] is a [DateTime] that matches the [Every] pattern, a new
  /// [DateTime] will be generated.
  /// {@endtemplate}
  DateTime next(DateTime date);

  /// {@template previous}
  /// Returns the previous instance of the given [date] considering this [Every]
  /// base process.
  ///
  /// If the [date] is a [DateTime] that matches the [Every] pattern, a new
  /// [DateTime] will be generated.
  /// {@endtemplate}
  DateTime previous(DateTime date);
}

/// Abstract class that forces the implementation of [Every] to have a
/// limit parameter for the [startDate], [next] and [previous] methods.
abstract class LimitedEvery extends Every {
  /// Abstract class that, when extended, processes [DateTime] with custom
  /// logic.
  ///
  /// Abstract class that forces the implementation of [Every] to have a
  /// limit parameter for the [startDate], [next] and [previous] methods.
  ///
  /// See [EveryDateValidatorDifference], [EveryDateValidatorIntersection] and
  /// [EveryDateValidatorUnion] for complete base implementations.
  ///
  /// See [EveryWeek], [EveryMonth], [EveryYear] for your base implementations.
  const LimitedEvery();

  /// {@macro startDate}
  ///
  /// {@template limit}
  /// If the generated [DateTime] is still not able to return the first call to
  /// this function and it has passed the [limit], it will throw a
  /// [DateTimeLimitReachedException].
  /// {@endtemplate}
  @override
  DateTime startDate(DateTime date, {DateTime? limit});

  /// {@macro next}
  ///
  /// {@macro limit}
  @override
  DateTime next(DateTime date, {DateTime? limit});

  /// {@macro previous}
  ///
  /// {@macro limit}
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

/// A base class that represents an [Every] with a [DateValidator].
abstract class EveryDateValidator extends Every with DateValidatorMixin {
  /// A base class that represents an [Every] with a [DateValidator].
  const EveryDateValidator();
}

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
    if (valid(date)) return date;
    return next(date);
  }

  /// Returns the previous date that fits the [weekday].
  ///
  /// Always returns the first [DateTime] that fits the [weekday], ignoring
  /// the given [date] as an option.
  @override
  DateTime next(DateTime date) {
    if (date.weekday < weekday.dateTimeValue) {
      return weekday.fromWeekOf(date);
    } else {
      return weekday
          .fromWeekOf(date.lastDayOfWeek.add(const Duration(days: 1)));
    }
  }

  /// Returns the previous date that fits the [weekday].
  ///
  /// Always returns the last [DateTime] that fits the [weekday], ignoring
  /// the given [date] as an option.
  @override
  DateTime previous(DateTime date) {
    if (date.weekday > weekday.dateTimeValue) {
      return weekday.fromWeekOf(date);
    } else {
      return weekday
          .fromWeekOf(date.firstDayOfWeek.subtract(const Duration(days: 1)));
    }
  }

  /// Returns a new [DateTime] where the week is [weeks] from this week and the
  /// [DateTime.weekday] is equal to [weekday].
  @override
  DateTime addWeeks(DateTime date, int weeks) {
    if (weeks == 0) return date;
    var localWeeks = weeks;
    var localDate = date.copyWith();
    if (!valid(localDate)) {
      if (localWeeks.isNegative) {
        if (localDate.weekday < weekday.dateTimeValue) {
          localDate =
              localDate.firstDayOfWeek.subtract(const Duration(days: 1));
        }
        localDate = weekday.fromWeekOf(localDate);
        localWeeks++;
      } else {
        if (localDate.weekday > weekday.dateTimeValue) {
          localDate = localDate.lastDayOfWeek.add(const Duration(days: 1));
        }
        localDate = weekday.fromWeekOf(localDate);
        localWeeks--;
      }
    }
    final day = localDate.toUtc().add(Duration(days: localWeeks * 7));
    return _solveFor(localDate, day);
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
    if (date.isUtc) return weekday.fromWeekOf(day.date).add(date.timeOfDay);
    return weekday.fromWeekOf(day.toLocal().date).add(date.timeOfDay);
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
    var localMonths = months;
    var localDate = date.copyWith();
    if (!valid(localDate)) {
      if (localMonths.isNegative) {
        if (localDate.day < dueDay) {
          localDate =
              localDate.firstDayOfMonth.subtract(const Duration(days: 1));
        }
        localDate = _thisMonthsDay(localDate);
        localMonths++;
      } else {
        if (localDate.day > dueDay) {
          localDate = localDate.lastDayOfMonth.add(const Duration(days: 1));
        }
        localDate = _thisMonthsDay(localDate);
        localMonths--;
      }
    }
    final day =
        localDate.copyWith(month: localDate.month + localMonths, day: 1);
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
/// next month's with the [week] occurrence of the [day] ([DateTime.weekday]
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
  /// - If the current [date] - [DateTime.day] is greater than the
  /// [DateTime.month], [week], it's returned the next month with the
  /// [DateTime.day] being the [day] of the [week].
  @override
  DateTime startDate(DateTime date) {
    if (valid(date)) return date;
    final thisMonthDay = week.weekdayOf(
      year: date.year,
      month: date.month,
      day: day,
      utc: date.isUtc,
    );
    if (date.day < thisMonthDay.day) return thisMonthDay;
    return next(date);
  }

  /// Returns the next date that fits the [day] and the [week].
  /// - If the current [date] - [DateTime.day] is less than the [DateTime.month]
  /// [week], it's returned the same month with the [DateTime.day] being the
  /// [day] of the [week].
  /// - If the current [date] - [DateTime.day] is greater than the
  /// [DateTime.month], [week], it's returned the next month with the
  /// [DateTime.day] being the [day] of the [week].
  @override
  DateTime next(DateTime date) {
    final thisMonthDay = week.weekdayOf(
      year: date.year,
      month: date.month,
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

  /// Returns the previous date that fits the [day] and the [week].
  /// - If the current [date] - [DateTime.day] is less than the [DateTime.month]
  /// [week], it's returned the same month with the [DateTime.day] being the
  /// [day] of the [week].
  /// - If the current [date] - [DateTime.day] is greater than the
  /// [DateTime.month], [week], it's returned the previous month with the
  /// [DateTime.day] being the [day] of the [week].
  @override
  DateTime previous(DateTime date) {
    final thisMonthDay = week.weekdayOf(
      year: date.year,
      month: date.month,
      day: day,
      utc: date.isUtc,
    );
    if (date.day > thisMonthDay.day) return thisMonthDay;
    return week.weekdayOf(
      year: date.year,
      month: date.month - 1,
      day: day,
      utc: date.isUtc,
    );
  }

  /// Returns the [date] - [DateTime.month] + [months] with the [week]
  /// occurrence of the [day].
  @override
  DateTime addMonths(DateTime date, int months) {
    if (months == 0) return startDate(date);
    var localMonths = months;
    var localDate = startDate(date);
    if (localMonths.isNegative) {
      while (localMonths < 0) {
        localDate = previous(localDate);
        localMonths++;
      }
    } else {
      while (localMonths > 0) {
        localDate = next(localDate);
        localMonths--;
      }
    }
    return localDate;
  }

  /// Returns the [date] - [DateTime.year] + [years] with the [week] occurrence
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
  /// - If the current [date] - [DayInYear.dayInYear] is equal to `zero`,
  /// [date] is returned.
  /// - If the current [date] - [DayInYear.dayInYear] is less than the
  /// [dayInYear], it's returned the same year with the [DayInYear.dayInYear]
  /// being the [dayInYear].
  /// - If the current [date] - [DayInYear.dayInYear] is greater than the
  /// [dayInYear], it's returned the next year with the [DayInYear.dayInYear]
  /// being the [dayInYear].
  @override
  DateTime startDate(DateTime date) {
    if (valid(date)) return date;
    final thisYearDay = date.firstDayOfYear
        .add(Duration(days: dayInYear - 1))
        .clamp(max: date.lastDayOfYear);
    if (date.dayInYear <= dayInYear) return thisYearDay;
    return next(date);
  }

  /// Returns the next date that fits the [dayInYear].
  /// - If the current [date] - [DayInYear.dayInYear] is less than the
  /// [dayInYear], it's returned the same year with the [DayInYear.dayInYear]
  /// being the [dayInYear].
  /// - If the current [date] - [DayInYear.dayInYear] is greater than the
  /// [dayInYear], it's returned the next year with the [DayInYear.dayInYear]
  /// being the [dayInYear].
  @override
  DateTime next(DateTime date) {
    if (!date.isLeapYear && dayInYear == 366) {
      return date.copyWith(year: date.year + 1).lastDayOfYear;
    }
    final thisYearDay = date.firstDayOfYear
        .add(Duration(days: dayInYear - 1))
        .clamp(max: date.lastDayOfYear);
    if (date.dayInYear < dayInYear) return thisYearDay;
    return date
        .copyWith(year: date.year + 1)
        .firstDayOfYear
        .add(Duration(days: dayInYear - 1))
        .clamp(max: date.copyWith(year: date.year + 1).lastDayOfYear);
  }

  /// Returns the previous date that fits the [dayInYear].
  /// - If the current [date] - [DayInYear.dayInYear] is greater than the
  /// [dayInYear], it's returned the same year with the [DayInYear.dayInYear]
  /// being the [dayInYear].
  /// - If the current [date] - [DayInYear.dayInYear] is less than the
  /// [dayInYear], it's returned the previous year with the
  /// [DayInYear.dayInYear] being the [dayInYear].
  @override
  DateTime previous(DateTime date) {
    final thisYearDay = date.firstDayOfYear
        .add(Duration(days: dayInYear - 1))
        .clamp(max: date.lastDayOfYear);
    if (date.dayInYear > dayInYear) return thisYearDay;
    return date
        .copyWith(year: date.year - 1)
        .firstDayOfYear
        .add(Duration(days: dayInYear - 1))
        .clamp(max: date.copyWith(year: date.year - 1).lastDayOfYear);
  }

  /// Returns a new [DateTime] where the year is [years] from this year and the
  /// [DateTime.day] is equal to [dayInYear]-1 added to January 1st.
  @override
  DateTime addYears(DateTime date, int years) {
    if (years == 0) return startDate(date);
    var localYears = years;
    var localDate = startDate(date);
    if (localYears.isNegative) {
      while (localYears < 0) {
        localDate = previous(localDate);
        localYears++;
      }
    } else {
      while (localYears > 0) {
        localDate = next(localDate);
        localYears--;
      }
    }
    return localDate;
  }

  @override
  String toString() {
    return 'EveryDayInYear<$dayInYear>';
  }
}

/// Mixin that represents a list of [EveryDateValidator].
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
    final startingDates = map(
      (every) => LimitedOrEveryHandler.startDate(every, date, limit: limit),
    );
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
    final nextDates =
        map((every) => LimitedOrEveryHandler.next(every, date, limit: limit));
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
    final previousDates = map(
      (every) => LimitedOrEveryHandler.previous(every, date, limit: limit),
    );
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
    final startingDates = map(
      (every) => LimitedOrEveryHandler.startDate(every, date, limit: limit),
    );
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
    final nextDates =
        map((every) => LimitedOrEveryHandler.next(every, date, limit: limit));
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
    final previousDates = map(
      (every) => LimitedOrEveryHandler.previous(every, date, limit: limit),
    );
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
    final startingDates = map(
      (every) => LimitedOrEveryHandler.startDate(every, date, limit: limit),
    );
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
    final nextDates =
        map((every) => LimitedOrEveryHandler.next(every, date, limit: limit));
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
    final previousDates = map(
      (every) => LimitedOrEveryHandler.previous(every, date, limit: limit),
    );
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

/// Exception thrown when a date limit is reached.
///
/// Thrown when a [LimitedEvery] method would return a date that is after (or
/// before in [LimitedEvery.previous] case) the [limit] date.
///
/// Should **_not_** be thrown when the resulting [date] is equal to the [limit]
/// date.
class DateTimeLimitReachedException implements Exception {
  /// Exception thrown when a date limit is reached.
  const DateTimeLimitReachedException({
    required this.date,
    required this.limit,
  }) : assert(date != limit, 'Invalid exception');

  /// Date that reached the limit.
  final DateTime date;

  /// Limit date.
  final DateTime limit;

  @override
  String toString() {
    return 'DateTimeLimitException: $date has passed $limit';
  }
}

DateTime _reduceFuture(DateTime value, DateTime element) {
  return value.isBefore(element) ? value : element;
}

DateTime _reducePast(DateTime value, DateTime element) {
  return value.isAfter(element) ? value : element;
}
