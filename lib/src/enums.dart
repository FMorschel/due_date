import 'package:time/time.dart';

import '../due_date.dart';

/// Weekday constants that are returned by [DateTime.weekday] method.
enum Weekday implements Comparable<Weekday> {
  monday(DateTime.monday),
  tuesday(DateTime.tuesday),
  wednesday(DateTime.wednesday),
  thursday(DateTime.thursday),
  friday(DateTime.friday),
  saturday(DateTime.saturday, isWeekend: true),
  sunday(DateTime.sunday, isWeekend: true);

  const Weekday(this.dateTimeValue, {this.isWeekend = false});

  /// Returns the Weekday constant that corresponds to the given [date].
  factory Weekday.from(DateTime date) =>
      Weekday.fromDateTimeValue(date.weekday);

  /// Returns the Weekday constant that corresponds to the given
  /// [dateTimeValue].
  factory Weekday.fromDateTimeValue(int weekday) {
    if (weekday == DateTime.monday) {
      return monday;
    } else if (weekday == DateTime.tuesday) {
      return tuesday;
    } else if (weekday == DateTime.wednesday) {
      return wednesday;
    } else if (weekday == DateTime.thursday) {
      return thursday;
    } else if (weekday == DateTime.friday) {
      return friday;
    } else if (weekday == DateTime.saturday) {
      return saturday;
    } else if (weekday == DateTime.sunday) {
      return sunday;
    }
    throw RangeError.range(weekday, DateTime.monday, DateTime.sunday);
  }

  /// The value of the weekday on the [DateTime] class.
  final int dateTimeValue;

  /// Whether this weekday is a weekend.
  final bool isWeekend;

  /// Whether this weekday is a workday.
  bool get isWorkDay => !isWeekend;

  /// Returns the ammount of weekdays correspondent to this on the given [month]
  /// of [year].
  int occrurencesIn(int year, int month) {
    DateTime date = DateTime.utc(year, month, 1);
    int count = 0;
    do {
      if (date.weekday == dateTimeValue) {
        count++;
      }
      date = date.add(Duration(days: 1));
    } while (date.month == month);
    return count;
  }

  /// Returns the same weekday of the given week that [date] is in.
  DateTime fromThisWeek(DateTime date) {
    final monday = date.firstDayOfWeek;
    final result = monday.add(Duration(days: index));
    return date.isUtc
        ? result.toUtc().date.add(date.timeOfDay)
        : result.date.add(date.timeOfDay);
  }

  @override
  int compareTo(Weekday other) => dateTimeValue.compareTo(other.dateTimeValue);

  bool operator >(Weekday other) => index > other.index;
  bool operator >=(Weekday other) => index >= other.index;
  bool operator <(Weekday other) => index < other.index;
  bool operator <=(Weekday other) => index <= other.index;

  /// Returns the [EveryWeekday] that corresponds to this weekday.
  EveryWeekday get every => EveryWeekday(this);

  /// Returns the [Weekday] previous to this.
  Weekday get previous {
    if (dateTimeValue != monday.dateTimeValue) {
      return Weekday.fromDateTimeValue(dateTimeValue - 1);
    } else {
      return sunday;
    }
  }

  /// Returns the [Weekday] next to this.
  Weekday get next {
    if (dateTimeValue != sunday.dateTimeValue) {
      return Weekday.fromDateTimeValue(dateTimeValue + 1);
    } else {
      return monday;
    }
  }

  /// Returns the [Weekday]s that [isWeekend] is true for.
  static Set<Weekday> get weekend {
    return values.where((weekday) => weekday.isWeekend).toSet();
  }
}

/// Month constants that are returned by [DateTime.month] method.
enum Month implements Comparable<Month> {
  january(DateTime.january),
  february(DateTime.february),
  march(DateTime.march),
  april(DateTime.april),
  may(DateTime.may),
  june(DateTime.june),
  july(DateTime.july),
  august(DateTime.august),
  september(DateTime.september),
  october(DateTime.october),
  november(DateTime.november),
  december(DateTime.december);

  const Month(this.dateTimeValue);

  /// Returns the [Month] constant that corresponds to the given [date].
  factory Month.from(DateTime date) => Month.fromDateTimeValue(date.month);

  /// Returns the [Month] constant that corresponds to the given [month] on
  /// [dateTimeValue].
  factory Month.fromDateTimeValue(int month) {
    if (month == DateTime.january) {
      return january;
    } else if (month == DateTime.february) {
      return february;
    } else if (month == DateTime.march) {
      return march;
    } else if (month == DateTime.april) {
      return april;
    } else if (month == DateTime.may) {
      return may;
    } else if (month == DateTime.june) {
      return june;
    } else if (month == DateTime.july) {
      return july;
    } else if (month == DateTime.august) {
      return august;
    } else if (month == DateTime.september) {
      return september;
    } else if (month == DateTime.october) {
      return october;
    } else if (month == DateTime.november) {
      return november;
    } else if (month == DateTime.december) {
      return december;
    }
    throw RangeError.range(month, DateTime.monday, DateTime.december);
  }

  /// The value of the month in [DateTime] class.
  final int dateTimeValue;

  /// Returns the first day of the month on the given [year] (utc).
  DateTime of(int year) => DateTime.utc(year, dateTimeValue);

  /// Returns the last day of the month on the given [year] (utc).
  DateTime lastDayOfAt(int year) =>
      DateTime.utc(year, dateTimeValue).lastDayOfMonth;

  @override
  int compareTo(Month other) => dateTimeValue.compareTo(other.dateTimeValue);

  bool operator >(Month other) => index > other.index;
  bool operator >=(Month other) => index >= other.index;
  bool operator <(Month other) => index < other.index;
  bool operator <=(Month other) => index <= other.index;

  /// Returns the [Month] previous to this.
  Month get previous {
    if (dateTimeValue != january.dateTimeValue) {
      return Month.fromDateTimeValue(dateTimeValue - 1);
    } else {
      return december;
    }
  }

  /// Returns the [Month] next to this.
  Month get next {
    if (dateTimeValue != december.dateTimeValue) {
      return Month.fromDateTimeValue(dateTimeValue + 1);
    } else {
      return january;
    }
  }
}

/// Week occurences inside a month. 
/// 
/// The first week of the month is the one that contains the first day of the 
/// month.
/// Sometimes the last week can be the same as the fourth.
enum Week implements Comparable<Week> {
  first,
  second,
  third,
  fourth,
  last;

  /// Returns the [Week] constant that corresponds to the given [date].
  factory Week.from(DateTime date) {
    const week = Duration(days: 7);
    final seventhDayOfMonth = date.toUtc().firstDayOfMonth.add(
          const Duration(days: 6),
        );
    final monday = date.toUtc().firstDayOfWeek;
    if (monday.compareTo(seventhDayOfMonth) <= 0) {
      return first;
    } else if (monday.compareTo(seventhDayOfMonth.add(week)) <= 0) {
      return second;
    } else if (monday.compareTo(seventhDayOfMonth.add(week * 2)) <= 0) {
      return third;
    } else if (monday.compareTo(seventhDayOfMonth.add(week * 3)) <= 0) {
      return fourth;
    } else if (monday.compareTo(seventhDayOfMonth.add(week * 4)) <= 0) {
      return last;
    }
    throw Exception('Unsupported week');
  }

  /// Returns the first day (just as [DateTime], is Monday) of the week of the
  /// selected week for the given [year] and [month].
  DateTime weekOf(int year, int month) {
    final firstDayOfMonth = DateTime.utc(year, month);
    switch (this) {
      case first:
        return firstDayOfMonth.firstDayOfWeek;
      case second:
        return DateTime.utc(year, month, 8).firstDayOfWeek;
      case third:
        return DateTime.utc(year, month, 15).firstDayOfWeek;
      case fourth:
        return DateTime.utc(year, month, 22).firstDayOfWeek;
      case last:
        final fourthWeek = fourth.weekOf(year, month);
        if (fourthWeek.lastDayOfWeek.isBefore(firstDayOfMonth.lastDayOfMonth)) {
          return DateTime.utc(year, month).lastDayOfMonth.firstDayOfWeek;
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
    DateTime weekDay = firstDayOfMonth.nextWeekday(day);
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

  bool operator >(Week other) => index > other.index;
  bool operator >=(Week other) => index >= other.index;
  bool operator <(Week other) => index < other.index;
  bool operator <=(Week other) => index <= other.index;

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

/// An enum wrapper in EveryWeekdayCountInMonth class.
///
/// Shows all possible values for the [EveryWeekdayCountInMonth] with better
/// naming.
enum WeekdayOccurrence implements EveryWeekdayCountInMonth {
  firstMonday(
    EveryWeekdayCountInMonth(
      day: Weekday.monday,
      week: Week.first,
    ),
  ),
  firstTuesday(
    EveryWeekdayCountInMonth(
      day: Weekday.tuesday,
      week: Week.first,
    ),
  ),
  firstWednesday(
    EveryWeekdayCountInMonth(
      day: Weekday.wednesday,
      week: Week.first,
    ),
  ),
  firstThursday(
    EveryWeekdayCountInMonth(
      day: Weekday.thursday,
      week: Week.first,
    ),
  ),
  firstFriday(
    EveryWeekdayCountInMonth(
      day: Weekday.friday,
      week: Week.first,
    ),
  ),
  firstSaturday(
    EveryWeekdayCountInMonth(
      day: Weekday.saturday,
      week: Week.first,
    ),
  ),
  firstSunday(
    EveryWeekdayCountInMonth(
      day: Weekday.sunday,
      week: Week.first,
    ),
  ),
  secondMonday(
    EveryWeekdayCountInMonth(
      day: Weekday.monday,
      week: Week.second,
    ),
  ),
  secondTuesday(
    EveryWeekdayCountInMonth(
      day: Weekday.tuesday,
      week: Week.second,
    ),
  ),
  secondWednesday(
    EveryWeekdayCountInMonth(
      day: Weekday.wednesday,
      week: Week.second,
    ),
  ),
  secondThursday(
    EveryWeekdayCountInMonth(
      day: Weekday.thursday,
      week: Week.second,
    ),
  ),
  secondFriday(
    EveryWeekdayCountInMonth(
      day: Weekday.friday,
      week: Week.second,
    ),
  ),
  secondSaturday(
    EveryWeekdayCountInMonth(
      day: Weekday.saturday,
      week: Week.second,
    ),
  ),
  secondSunday(
    EveryWeekdayCountInMonth(
      day: Weekday.sunday,
      week: Week.second,
    ),
  ),
  thirdMonday(
    EveryWeekdayCountInMonth(
      day: Weekday.monday,
      week: Week.third,
    ),
  ),
  thirdTuesday(
    EveryWeekdayCountInMonth(
      day: Weekday.tuesday,
      week: Week.third,
    ),
  ),
  thirdWednesday(
    EveryWeekdayCountInMonth(
      day: Weekday.wednesday,
      week: Week.third,
    ),
  ),
  thirdThursday(
    EveryWeekdayCountInMonth(
      day: Weekday.thursday,
      week: Week.third,
    ),
  ),
  thirdFriday(
    EveryWeekdayCountInMonth(
      day: Weekday.friday,
      week: Week.third,
    ),
  ),
  thirdSaturday(
    EveryWeekdayCountInMonth(
      day: Weekday.saturday,
      week: Week.third,
    ),
  ),
  thirdSunday(
    EveryWeekdayCountInMonth(
      day: Weekday.sunday,
      week: Week.third,
    ),
  ),
  fourthMonday(
    EveryWeekdayCountInMonth(
      day: Weekday.monday,
      week: Week.fourth,
    ),
  ),
  fourthTuesday(
    EveryWeekdayCountInMonth(
      day: Weekday.tuesday,
      week: Week.fourth,
    ),
  ),
  fourthWednesday(
    EveryWeekdayCountInMonth(
      day: Weekday.wednesday,
      week: Week.fourth,
    ),
  ),
  fourthThursday(
    EveryWeekdayCountInMonth(
      day: Weekday.thursday,
      week: Week.fourth,
    ),
  ),
  fourthFriday(
    EveryWeekdayCountInMonth(
      day: Weekday.friday,
      week: Week.fourth,
    ),
  ),
  fourthSaturday(
    EveryWeekdayCountInMonth(
      day: Weekday.saturday,
      week: Week.fourth,
    ),
  ),
  fourthSunday(
    EveryWeekdayCountInMonth(
      day: Weekday.sunday,
      week: Week.fourth,
    ),
  ),
  lastMonday(
    EveryWeekdayCountInMonth(
      day: Weekday.monday,
      week: Week.last,
    ),
  ),
  lastTuesday(
    EveryWeekdayCountInMonth(
      day: Weekday.tuesday,
      week: Week.last,
    ),
  ),
  lastWednesday(
    EveryWeekdayCountInMonth(
      day: Weekday.wednesday,
      week: Week.last,
    ),
  ),
  lastThursday(
    EveryWeekdayCountInMonth(
      day: Weekday.thursday,
      week: Week.last,
    ),
  ),
  lastFriday(
    EveryWeekdayCountInMonth(
      day: Weekday.friday,
      week: Week.last,
    ),
  ),
  lastSaturday(
    EveryWeekdayCountInMonth(
      day: Weekday.saturday,
      week: Week.last,
    ),
  ),
  lastSunday(
    EveryWeekdayCountInMonth(
      day: Weekday.sunday,
      week: Week.last,
    ),
  );

  const WeekdayOccurrence(this._handler);

  /// Returns the [WeekdayOccurrence] for the given [date].
  factory WeekdayOccurrence.from(DateTime date) {
    final every = EveryWeekdayCountInMonth.from(date);
    return WeekdayOccurrence.fromEvery(every);
  }

  /// Returns the [WeekdayOccurrence] for the given [every].
  factory WeekdayOccurrence.fromEvery(EveryWeekdayCountInMonth every) {
    return WeekdayOccurrence.values.singleWhere((element) {
      return (element.day == every.day) && (element.week == every.week);
    });
  }

  final EveryWeekdayCountInMonth _handler;

  @override
  Weekday get day => _handler.day;

  @override
  Week get week => _handler.week;

  @override
  DateTime startDate(DateTime date) => _handler.startDate(date);

  @override
  DateTime addMonths(DateTime date, int months) {
    return _handler.addMonths(date, months);
  }

  @override
  DateTime next(DateTime date) => _handler.next(date);

  @override
  DateTime previous(DateTime date) => _handler.previous(date);

  @override
  DateTime addYears(DateTime date, int years) => _handler.addYears(date, years);

  @override
  int compareTo(EveryWeekdayCountInMonth other) => _handler.compareTo(other);

  bool operator >(WeekdayOccurrence other) => index > other.index;
  bool operator >=(WeekdayOccurrence other) => index >= other.index;
  bool operator <(WeekdayOccurrence other) => index < other.index;
  bool operator <=(WeekdayOccurrence other) => index <= other.index;

  @override
  bool? get stringify => _handler.stringify;

  @override
  List<Object?> get props => _handler.props;
}
