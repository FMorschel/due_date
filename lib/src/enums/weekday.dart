import 'package:time/time.dart';
import '../date_validators/date_validators.dart';
import '../everies/everies.dart';
import '../period_generators/period_generators.dart';
import '../periods/periods.dart';

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
    var date = DateTime.utc(year, month);
    var count = 0;
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
