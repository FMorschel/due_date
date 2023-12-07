import 'package:time/time.dart';

import '../due_date.dart';
import '../period.dart';

/// Weekday constants that are returned by [DateTime.weekday] method.
enum Weekday implements Comparable<Weekday> {
  /// Monday.
  monday(DateTime.monday, generator: WeekGenerator()),
  /// Tuesday.
  tuesday(
    DateTime.tuesday,
    generator: WeekGenerator(weekStart: DateTime.tuesday),
  ),
  /// Wednesday.
  wednesday(
    DateTime.wednesday,
    generator: WeekGenerator(weekStart: DateTime.wednesday),
  ),
  /// Thursday.
  thursday(
    DateTime.thursday,
    generator: WeekGenerator(weekStart: DateTime.thursday),
  ),
  /// Friday.
  friday(
    DateTime.friday,
    generator: WeekGenerator(weekStart: DateTime.friday),
  ),
  /// Saturday.
  saturday(
    DateTime.saturday,
    isWeekend: true,
    generator: WeekGenerator(weekStart: DateTime.saturday),
  ),
  /// Sunday.
  sunday(
    DateTime.sunday,
    isWeekend: true,
    generator: WeekGenerator(weekStart: DateTime.sunday),
  );

  /// Weekday constants that are returned by [DateTime.weekday] method.
  const Weekday(
    this.dateTimeValue, {
    required WeekGenerator generator,
    this.isWeekend = false,
  }) : weekGenerator = generator;

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

  /// Generator that returns a [WeekPeriod] that starts on this weekday.
  final WeekGenerator weekGenerator;

  /// The value of the weekday on the [DateTime] class.
  final int dateTimeValue;

  /// Whether this weekday is a weekend.
  final bool isWeekend;

  /// Whether this weekday is a workday.
  bool get isWorkday => !isWeekend;

  /// Returns the amount of weekdays correspondent to this on the given [month]
  /// of [year].
  @Deprecated("Use 'Weekday.occurrencesIn' instead")
  int occrurencesIn(int year, int month) => occurrencesIn(year, month);

  /// Returns the amount of weekdays correspondent to this on the given [month]
  /// of [year].
  int occurrencesIn(int year, int month) {
    DateTime date = DateTime.utc(year, month);
    int count = 0;
    do {
      if (date.weekday == dateTimeValue) {
        count++;
      }
      date = date.add(const Duration(days: 1));
    } while (date.month == month);
    return count;
  }

  /// Returns the same weekday of the given week that [date] is in.
  DateTime fromWeekOf(DateTime date) {
    final monday = date.firstDayOfWeek;
    final result = monday.add(Duration(days: index));
    return date.isUtc
        ? result.toUtc().date.add(date.timeOfDay)
        : result.date.add(date.timeOfDay);
  }

  @override
  int compareTo(Weekday other) => dateTimeValue.compareTo(other.dateTimeValue);

  /// Returns true if this weekday is after other.
  bool operator >(Weekday other) => index > other.index;

  /// Returns true if this weekday is after or equal to other.
  bool operator >=(Weekday other) => index >= other.index;

  /// Returns true if this weekday is before than other.
  bool operator <(Weekday other) => index < other.index;

  /// Returns true if this weekday is before or equal to other.
  bool operator <=(Weekday other) => index <= other.index;

  /// Returns the [Weekday] that corresponds to this added [days].
  /// Eg.:
  ///  - [monday] + `1` returns [tuesday].
  ///  - [friday] + `3` returns [monday].
  Weekday operator +(int days) =>
      Weekday.fromDateTimeValue(dateTimeValue + days % values.length);

  /// Returns the [Weekday] that corresponds to this subtracted [days].
  /// Eg.:
  ///  - [tuesday] - `1` returns [monday].
  ///  - [monday] - `3` returns [friday].
  Weekday operator -(int days) =>
      Weekday.fromDateTimeValue(dateTimeValue - days % values.length);

  /// Returns the [EveryWeekday] that corresponds to this weekday.
  EveryWeekday get every {
    switch (this) {
      case monday:
        return const EveryWeekday(monday);
      case tuesday:
        return const EveryWeekday(tuesday);
      case wednesday:
        return const EveryWeekday(wednesday);
      case thursday:
        return const EveryWeekday(thursday);
      case friday:
        return const EveryWeekday(friday);
      case saturday:
        return const EveryWeekday(saturday);
      case sunday:
        return const EveryWeekday(sunday);
    }
  }

  /// Returns the [DateValidator] that corresponds to this weekday.
  DateValidator get validator {
    switch (this) {
      case monday:
        return const DateValidatorWeekday(monday);
      case tuesday:
        return const DateValidatorWeekday(tuesday);
      case wednesday:
        return const DateValidatorWeekday(wednesday);
      case thursday:
        return const DateValidatorWeekday(thursday);
      case friday:
        return const DateValidatorWeekday(friday);
      case saturday:
        return const DateValidatorWeekday(saturday);
      case sunday:
        return const DateValidatorWeekday(sunday);
    }
  }

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

  /// Returns the [Weekday]s that [isWorkday] is true for.
  static Set<Weekday> get workdays {
    return values.where((weekday) => weekday.isWorkday).toSet();
  }
}

/// Month constants that are returned by [DateTime.month] method.
enum Month implements Comparable<Month> {
  /// January month constant.
  january(DateTime.january),
  /// February month constant.
  february(DateTime.february),
  /// March month constant.
  march(DateTime.march),
  /// April month constant.
  april(DateTime.april),
  /// May month constant.
  may(DateTime.may),
  /// June month constant.
  june(DateTime.june),
  /// July month constant.
  july(DateTime.july),
  /// August month constant.
  august(DateTime.august),
  /// September month constant.
  september(DateTime.september),
  /// October month constant.
  october(DateTime.october),
  /// November month constant.
  november(DateTime.november),
  /// December month constant.
  december(DateTime.december);

  /// Month constants that are returned by [DateTime.month] method.
  const Month(this.dateTimeValue);

  /// Returns the [Month] constant that corresponds to the given [date].
  factory Month.of(DateTime date) => Month.fromDateTimeValue(date.month);

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

  /// Returns a constant [MonthGenerator].
  static const generator = MonthGenerator();

  /// The value of the month in [DateTime] class.
  final int dateTimeValue;

  /// Returns the period of the month on the given [year].
  MonthPeriod of(int year, {bool utc = true}) => generator.of(
        utc ? DateTime.utc(year, dateTimeValue) : DateTime(year, dateTimeValue),
      );

  @override
  int compareTo(Month other) => dateTimeValue.compareTo(other.dateTimeValue);

  /// Returns true if this month is after other.
  bool operator >(Month other) => index > other.index;

  /// Returns true if this month is after or equal to other.
  bool operator >=(Month other) => index >= other.index;

  /// Returns true if this month is before than other.
  bool operator <(Month other) => index < other.index;

  /// Returns true if this month is before or equal to other.
  bool operator <=(Month other) => index <= other.index;

  /// Returns the [Month] that corresponds to this added [months].
  /// Eg.:
  ///  - [january] + `1` returns [february].
  ///  - [december] + `3` returns [march].
  Month operator +(int months) =>
      Month.fromDateTimeValue(((dateTimeValue + months) % values.length).abs());

  /// Returns the [Month] that corresponds to this subtracted [months].
  /// Eg.:
  ///  - [february] - `1` returns [january].
  ///  - [march] - `3` returns [december].
  Month operator -(int months) =>
      Month.fromDateTimeValue(((dateTimeValue - months) % values.length).abs());

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

/// An enum wrapper in EveryWeekdayCountInMonth class.
///
/// Shows all possible values for the [EveryWeekdayCountInMonth] with better
/// naming.
enum WeekdayOccurrence
    with DateValidatorMixin
    implements EveryWeekdayCountInMonth {
  /// The first Monday of the month.
  firstMonday(
    EveryWeekdayCountInMonth(
      day: Weekday.monday,
      week: Week.first,
    ),
  ),
  /// The first Tuesday of the month.
  firstTuesday(
    EveryWeekdayCountInMonth(
      day: Weekday.tuesday,
      week: Week.first,
    ),
  ),
  /// The first Wednesday of the month.
  firstWednesday(
    EveryWeekdayCountInMonth(
      day: Weekday.wednesday,
      week: Week.first,
    ),
  ),
  /// The first Thursday of the month.
  firstThursday(
    EveryWeekdayCountInMonth(
      day: Weekday.thursday,
      week: Week.first,
    ),
  ),
  /// The first Friday of the month.
  firstFriday(
    EveryWeekdayCountInMonth(
      day: Weekday.friday,
      week: Week.first,
    ),
  ),
  /// The first Saturday of the month.
  firstSaturday(
    EveryWeekdayCountInMonth(
      day: Weekday.saturday,
      week: Week.first,
    ),
  ),
  /// The first Sunday of the month.
  firstSunday(
    EveryWeekdayCountInMonth(
      day: Weekday.sunday,
      week: Week.first,
    ),
  ),
  /// The second Monday of the month.
  secondMonday(
    EveryWeekdayCountInMonth(
      day: Weekday.monday,
      week: Week.second,
    ),
  ),
  /// The second Tuesday of the month.
  secondTuesday(
    EveryWeekdayCountInMonth(
      day: Weekday.tuesday,
      week: Week.second,
    ),
  ),
  /// The second Wednesday of the month.
  secondWednesday(
    EveryWeekdayCountInMonth(
      day: Weekday.wednesday,
      week: Week.second,
    ),
  ),
  /// The second Thursday of the month.
  secondThursday(
    EveryWeekdayCountInMonth(
      day: Weekday.thursday,
      week: Week.second,
    ),
  ),
  /// The second Friday of the month.
  secondFriday(
    EveryWeekdayCountInMonth(
      day: Weekday.friday,
      week: Week.second,
    ),
  ),
  /// The second Saturday of the month.
  secondSaturday(
    EveryWeekdayCountInMonth(
      day: Weekday.saturday,
      week: Week.second,
    ),
  ),
  /// The second Sunday of the month.
  secondSunday(
    EveryWeekdayCountInMonth(
      day: Weekday.sunday,
      week: Week.second,
    ),
  ),
  /// The third Monday of the month.
  thirdMonday(
    EveryWeekdayCountInMonth(
      day: Weekday.monday,
      week: Week.third,
    ),
  ),
  /// The third Tuesday of the month.
  thirdTuesday(
    EveryWeekdayCountInMonth(
      day: Weekday.tuesday,
      week: Week.third,
    ),
  ),
  /// The third Wednesday of the month.
  thirdWednesday(
    EveryWeekdayCountInMonth(
      day: Weekday.wednesday,
      week: Week.third,
    ),
  ),
  /// The third Thursday of the month.
  thirdThursday(
    EveryWeekdayCountInMonth(
      day: Weekday.thursday,
      week: Week.third,
    ),
  ),
  /// The third Friday of the month.
  thirdFriday(
    EveryWeekdayCountInMonth(
      day: Weekday.friday,
      week: Week.third,
    ),
  ),
  /// The third Saturday of the month.
  thirdSaturday(
    EveryWeekdayCountInMonth(
      day: Weekday.saturday,
      week: Week.third,
    ),
  ),
  /// The third Sunday of the month.
  thirdSunday(
    EveryWeekdayCountInMonth(
      day: Weekday.sunday,
      week: Week.third,
    ),
  ),
  /// The fourth Monday of the month.
  fourthMonday(
    EveryWeekdayCountInMonth(
      day: Weekday.monday,
      week: Week.fourth,
    ),
  ),
  /// The fourth Tuesday of the month.
  fourthTuesday(
    EveryWeekdayCountInMonth(
      day: Weekday.tuesday,
      week: Week.fourth,
    ),
  ),
  /// The fourth Wednesday of the month.
  fourthWednesday(
    EveryWeekdayCountInMonth(
      day: Weekday.wednesday,
      week: Week.fourth,
    ),
  ),
  /// The fourth Thursday of the month.
  fourthThursday(
    EveryWeekdayCountInMonth(
      day: Weekday.thursday,
      week: Week.fourth,
    ),
  ),
  /// The fourth Friday of the month.
  fourthFriday(
    EveryWeekdayCountInMonth(
      day: Weekday.friday,
      week: Week.fourth,
    ),
  ),
  /// The fourth Saturday of the month.
  fourthSaturday(
    EveryWeekdayCountInMonth(
      day: Weekday.saturday,
      week: Week.fourth,
    ),
  ),
  /// The fourth Sunday of the month.
  fourthSunday(
    EveryWeekdayCountInMonth(
      day: Weekday.sunday,
      week: Week.fourth,
    ),
  ),
  /// The last Monday of the month.
  lastMonday(
    EveryWeekdayCountInMonth(
      day: Weekday.monday,
      week: Week.last,
    ),
  ),
  /// The last Tuesday of the month.
  lastTuesday(
    EveryWeekdayCountInMonth(
      day: Weekday.tuesday,
      week: Week.last,
    ),
  ),
  /// The last Wednesday of the month.
  lastWednesday(
    EveryWeekdayCountInMonth(
      day: Weekday.wednesday,
      week: Week.last,
    ),
  ),
  /// The last Thursday of the month.
  lastThursday(
    EveryWeekdayCountInMonth(
      day: Weekday.thursday,
      week: Week.last,
    ),
  ),
  /// The last Friday of the month.
  lastFriday(
    EveryWeekdayCountInMonth(
      day: Weekday.friday,
      week: Week.last,
    ),
  ),
  /// The last Saturday of the month.
  lastSaturday(
    EveryWeekdayCountInMonth(
      day: Weekday.saturday,
      week: Week.last,
    ),
  ),
  /// The last Sunday of the month.
  lastSunday(
    EveryWeekdayCountInMonth(
      day: Weekday.sunday,
      week: Week.last,
    ),
  );

  /// An enum wrapper in EveryWeekdayCountInMonth class.
  ///
  /// Shows all possible values for the [EveryWeekdayCountInMonth] with better
  /// naming.
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
  bool valid(DateTime date) => _handler.valid(date);

  @override
  int compareTo(DateValidatorWeekdayCountInMonth other) =>
      _handler.compareTo(other);

  /// Returns true if this [week] is after [other]s [WeekdayOccurrence.week], or
  /// if they are the same and this [day] is after [other]s
  /// [WeekdayOccurrence.day].
  bool operator >(WeekdayOccurrence other) => index > other.index;

  /// Returns true if this [week] is after or equal to [other]s
  /// [WeekdayOccurrence.week], or if they are the same and this [day] is
  /// after or equal to [other]s [WeekdayOccurrence.day].
  bool operator >=(WeekdayOccurrence other) => index >= other.index;

  /// Returns true if this [week] is before [other]s [WeekdayOccurrence.week],
  /// or if they are the same and this [day] is before [other]s
  /// [WeekdayOccurrence.day].
  bool operator <(WeekdayOccurrence other) => index < other.index;

  /// Returns true if this [week] is before or equal to [other]s
  /// [WeekdayOccurrence.week], or if they are the same and this [day] is
  /// before or equal to [other]s [WeekdayOccurrence.day].
  bool operator <=(WeekdayOccurrence other) => index <= other.index;

  @override
  bool? get stringify => _handler.stringify;

  @override
  List<Object> get props => _handler.props;
}

/// An enumeration of the different period generators implemented in this
/// package.
enum PeriodGenerator<T extends Period> with PeriodGeneratorMixin<T> {
  /// Creates periods of a second.
  second(SecondGenerator()),

  /// Creates periods of a minute.
  minute(MinuteGenerator()),

  /// Creates periods of an hour.
  hour(HourGenerator()),

  /// Creates periods of a day.
  day(DayGenerator()),

  /// Creates periods of a week.
  week(WeekGenerator()),

  /// Creates periods of a fortnight.
  fortnight(FortnightGenerator()),

  /// Creates periods of a month.
  month(MonthGenerator()),

  /// Creates periods of a trimester.
  trimester(TrimesterGenerator()),

  /// Creates periods of a semester.
  semester(SemesterGenerator()),

  /// Creates periods of a year.
  year(YearGenerator());

  /// An enumeration of the different period generators implemented in this
  /// package.
  const PeriodGenerator(PeriodGeneratorMixin<T> handler) : _handler = handler;

  final PeriodGeneratorMixin<T> _handler;

  @override
  T of(DateTime date) => _handler.of(date);

  @override
  bool fitsGenerator(Period period) => _handler.fitsGenerator(period);
}
