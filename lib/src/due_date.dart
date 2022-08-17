import 'every.dart';

class DueDateTime extends DateTime {
  factory DueDateTime({
    required int year,

    /// The expected day of the month.
    Every? every,
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
    bool utc = false,
  }) {
    late final DateTime date;
    if (utc) {
      date = DateTime.utc(
        year,
        month,
        day,
        hour,
        minute,
        second,
        millisecond,
        microsecond,
      );
    } else {
      date = DateTime(
        year,
        month,
        day,
        hour,
        minute,
        second,
        millisecond,
        microsecond,
      );
    }
    return DueDateTime.fromDate(date, every);
  }

  DueDateTime._fromDate({
    required this.every,
    required DateTime date,
  }) : super(
          date.year,
          date.month,
          date.day,
          date.hour,
          date.minute,
          date.second,
          date.millisecond,
          date.microsecond,
        );

  DueDateTime._utcFromDate({
    required this.every,
    required DateTime date,
  }) : super.utc(
          date.year,
          date.month,
          date.day,
          date.hour,
          date.minute,
          date.second,
          date.millisecond,
          date.microsecond,
        );

  factory DueDateTime.utc({
    required int year,

    /// The expected day of the month.
    Every? every,
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  }) =>
      DueDateTime(
        every: every,
        year: year,
        month: month,
        day: day,
        hour: hour,
        minute: minute,
        second: second,
        millisecond: millisecond,
        microsecond: microsecond,
        utc: true,
      );

  factory DueDateTime.now() => DueDateTime.fromDate(DateTime.now());

  factory DueDateTime.fromDate(
    DateTime reference, [

    /// The expected day of the month.
    Every? every,
  ]) {
    if (every == null) {
      return DueDateTime._toConstructor(
        every: EveryDueDayMonth(reference.day),
        date: reference,
      );
    } else {
      return DueDateTime._toConstructor(
        date: every.startDate(reference),
        every: every,
      );
    }
  }

  factory DueDateTime._toConstructor({
    /// The expected day of the month.
    required Every every,
    required DateTime date,
  }) {
    return date.isUtc
        ? DueDateTime._utcFromDate(every: every, date: date)
        : DueDateTime._fromDate(every: every, date: date);
  }

  static const _week = Duration(days: DateTime.daysPerWeek);

  /// The handler for processing the next dates.
  Every every;

  static DueDateTime parse(String formattedString, [Every? every]) {
    return DueDateTime.fromDate(DateTime.parse(formattedString), every);
  }

  static DueDateTime? tryParse(String formattedString, [Every? every]) {
    final nullableDate = DateTime.tryParse(formattedString);
    if (nullableDate == null) return null;
    return DueDateTime.fromDate(nullableDate, every);
  }

  static DueDateTime fromMillisecondsSinceEpoch(
    int millisecondsSinceEpoch, {
    Every? every,
    bool isUtc = false,
  }) {
    final date = DateTime.fromMillisecondsSinceEpoch(
      millisecondsSinceEpoch,
      isUtc: isUtc,
    );
    return DueDateTime.fromDate(date, every);
  }

  static DueDateTime fromMicrosecondsSinceEpoch(
    int microsecondsSinceEpoch, {
    Every? every,
    bool isUtc = false,
  }) {
    final date = DateTime.fromMicrosecondsSinceEpoch(
      microsecondsSinceEpoch,
      isUtc: isUtc,
    );
    return DueDateTime.fromDate(date, every);
  }

  DueDateTime copyWith({
    Every? every,
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DueDateTime(
      every: every ?? this.every,
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      second: second ?? this.second,
      millisecond: millisecond ?? this.millisecond,
      microsecond: microsecond ?? this.microsecond,
    );
  }

  @override
  DueDateTime toUtc() => DueDateTime._utcFromDate(
        every: every,
        date: super.toUtc(),
      );

  @override
  DueDateTime toLocal() => DueDateTime._fromDate(
        every: every,
        date: super.toLocal(),
      );

  /// Returns a new [DateTime] instance with [duration] added to [this].
  ///
  /// If [sameEvery] is true, keeps the current expected day of the month
  /// ([every]). If is false, the [every] will change to the [day] of the
  /// generated date.
  ///
  /// ```dart
  /// final today = DateTime.now();
  /// final fiftyDaysFromNow = today.add(const Duration(days: 50));
  /// ```
  ///
  /// Notice that the duration being added is actually 50 * 24 * 60 * 60
  /// seconds. If the resulting `DateTime` has a different daylight saving offset
  /// than `this`, then the result won't have the same time-of-day as `this`, and
  /// may not even hit the calendar date 50 days later.
  ///
  /// Be careful when working with dates in local time.
  @override
  DueDateTime add(
    Duration duration, {
    bool sameEvery = false,
  }) {
    final date = super.add(duration);
    return DueDateTime.fromDate(date, sameEvery ? every : null);
  }

  /// Returns a new [DateTime] instance with [duration] subtracted from [this].
  ///
  /// If [sameEvery] is true, keeps the current expected day of the month
  /// ([every]). If is false, the [every] will change to the [day] of the
  /// generated date.
  ///
  /// ```dart
  /// final today = DateTime.now();
  /// final fiftyDaysAgo = today.subtract(const Duration(days: 50));
  /// ```
  ///
  /// Notice that the duration being subtracted is actually 50 * 24 * 60 * 60
  /// seconds. If the resulting `DateTime` has a different daylight saving offset
  /// than `this`, then the result won't have the same time-of-day as `this`, and
  /// may not even hit the calendar date 50 days earlier.
  ///
  /// Be careful when working with dates in local time.
  @override
  DueDateTime subtract(
    Duration duration, {
    bool sameEvery = false,
  }) {
    final date = super.subtract(duration);
    return DueDateTime.fromDate(date, sameEvery ? every : null);
  }

  /// Returns a new [DateTime] instance with [weeks] weeks added to [this].
  ///
  /// If [sameEvery] is true, keeps the current expected day of the month
  /// ([every]). If is false, the [every] will change to the [day] of the
  /// generated date.
  ///
  /// Be careful when working with dates in local time.
  DueDateTime addWeeks(int weeks, {bool sameEvery = false}) =>
      add(_week * weeks, sameEvery: sameEvery);

  /// Returns a new [DateTime] instance with [weeks] weeks subtracted from [this].
  ///
  /// If [sameEvery] is true, keeps the current expected day of the month
  /// ([every]). If is false, the [every] will change to the [day] of the
  /// generated date.
  ///
  /// Be careful when working with dates in local time.
  DueDateTime subtractWeeks(int weeks, {bool sameEvery = false}) =>
      subtract(_week * weeks, sameEvery: sameEvery);

  DueDateTime addMonths(
    int months, {
    bool sameEvery = false,
  }) {
    if (every is EveryMonth) {
      return DueDateTime.fromDate(
        (every as EveryMonth).addMonths(this, months),
        sameEvery ? every : null,
      );
    } else {
      return DueDateTime.fromDate(
        EveryDueDayMonth(day).addMonths(this, months),
        sameEvery ? every : null,
      );
    }
  }

  DueDateTime subtractMonths(
    int months, {
    bool sameEvery = false,
  }) =>
      addMonths(-months, sameEvery: sameEvery);

  DueDateTime get nextWeek => addWeeks(1);
  DueDateTime get nextMonth => addMonths(1);
  DueDateTime get nextYear => addMonths(12);

  DueDateTime get previousWeek => subtractWeeks(1);
  DueDateTime get previousMonth => subtractMonths(1);
  DueDateTime get previousYear => subtractMonths(12);
}
