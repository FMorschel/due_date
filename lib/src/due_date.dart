import 'package:time/time.dart';

class DueDateTime extends DateTime {
  factory DueDateTime({
    /// The expected day of the month.
    required int dueDay,
    required int year,
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
    return DueDateTime.fromDate(date, dueDay);
  }

  DueDateTime._fromDate({
    required this.dueDay,
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
    required this.dueDay,
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
    /// The expected day of the month.
    required int dueDay,
    required int year,
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  }) =>
      DueDateTime(
        dueDay: dueDay,
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
    int? dueDay,
  ]) {
    assert(
      (dueDay == null) || ((dueDay >= 1) && (dueDay <= 31)),
      'Due day must be between 1 and 31',
    );
    if ((dueDay == null) || (reference.day == dueDay)) {
      return DueDateTime._toConstructor(
        dueDay: dueDay ?? reference.day,
        date: reference,
      );
    } else if (reference.day < dueDay) {
      return DueDateTime._thisMonthsDay(date: reference, dueDay: dueDay);
    } else {
      return DueDateTime._nextMonthsDay(date: reference, dueDay: dueDay);
    }
  }

  factory DueDateTime._nextMonthsDay({
    required DateTime date,

    /// The expected day of the month.
    required int dueDay,
  }) {
    final dueNextMonth = _nextMonthDueDay(date, dueDay);
    final endNextMonth = _endNextMonth(date, dueDay);
    final dueDate = dueNextMonth.clamp(max: endNextMonth);
    return DueDateTime._toConstructor(dueDay: dueDay, date: dueDate);
  }

  factory DueDateTime._thisMonthsDay({
    required DateTime date,

    /// The expected day of the month.
    required int dueDay,
  }) {
    final dueDate = date.copyWith(day: dueDay).clamp(max: date.lastDayOfMonth);
    return DueDateTime._toConstructor(dueDay: dueDay, date: dueDate);
  }

  factory DueDateTime._toConstructor({
    /// The expected day of the month.
    required int dueDay,
    required DateTime date,
  }) {
    return date.isUtc
        ? DueDateTime._utcFromDate(dueDay: dueDay, date: date)
        : DueDateTime._fromDate(dueDay: dueDay, date: date);
  }

  static const _week = Duration(days: DateTime.daysPerWeek);

  /// The expected day of the month.
  int dueDay;

  static DateTime _nextMonthDueDay(
    DateTime date,

    /// The expected day of the month.
    int dueDay,
  ) {
    return date.copyWith(month: date.month + 1, day: dueDay);
  }

  static DateTime _endNextMonth(
    DateTime date,

    /// The expected day of the month.
    int dueDay,
  ) {
    return date.copyWith(month: date.month + 1, day: 1).lastDayOfMonth;
  }

  static DueDateTime parse(String formattedString, [int? dueDay]) {
    return DueDateTime.fromDate(DateTime.parse(formattedString), dueDay);
  }

  static DueDateTime? tryParse(String formattedString, [int? dueDay]) {
    final nullableDate = DateTime.tryParse(formattedString);
    if (nullableDate == null) return null;
    return DueDateTime.fromDate(nullableDate, dueDay);
  }

  static DueDateTime fromMillisecondsSinceEpoch(
    int millisecondsSinceEpoch, {
    int? dueDay,
    bool isUtc = false,
  }) {
    final date = DateTime.fromMillisecondsSinceEpoch(
      millisecondsSinceEpoch,
      isUtc: isUtc,
    );
    return DueDateTime.fromDate(date, dueDay);
  }

  static DueDateTime fromMicrosecondsSinceEpoch(
    int microsecondsSinceEpoch, {
    int? dueDay,
    bool isUtc = false,
  }) {
    final date = DateTime.fromMicrosecondsSinceEpoch(
      microsecondsSinceEpoch,
      isUtc: isUtc,
    );
    return DueDateTime.fromDate(date, dueDay);
  }

  DueDateTime copyWith({
    int? dueDay,
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
      dueDay: dueDay ?? this.dueDay,
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

  DueDateTime addMonths(int months) {
    final firstDay = copyWith(month: month + months, day: 1);
    return DueDateTime._toConstructor(
      dueDay: dueDay,
      date: firstDay.copyWith(day: dueDay).clamp(
            min: firstDay,
            max: firstDay.lastDayOfMonth,
          ),
    );
  }

  DueDateTime subtractMonths(int months) => addMonths(-months);

  @override
  DueDateTime toUtc() => DueDateTime._utcFromDate(
        dueDay: dueDay,
        date: super.toUtc(),
      );

  @override
  DueDateTime toLocal() => DueDateTime._fromDate(
        dueDay: dueDay,
        date: super.toLocal(),
      );

  /// Returns a new [DateTime] instance with [duration] added to [this].
  ///
  /// If [sameDay] is true, keeps the current expected day of the month 
  /// ([dueDay]). If is false, the [dueDay] will change to the [day] of the 
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
    bool sameDay = false,
  }) {
    final date = super.add(duration);
    return DueDateTime.fromDate(date, sameDay ? dueDay : null);
  }
  
  /// Returns a new [DateTime] instance with [duration] subtracted from [this].
  ///
  /// If [sameDay] is true, keeps the current expected day of the month 
  /// ([dueDay]). If is false, the [dueDay] will change to the [day] of the 
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
    bool sameDay = false,
  }) {
    final date = super.subtract(duration);
    return DueDateTime.fromDate(date, sameDay ? dueDay : null);
  }

  /// Returns a new [DateTime] instance with [weeks] weeks added to [this].
  ///
  /// If [sameDay] is true, keeps the current expected day of the month 
  /// ([dueDay]). If is false, the [dueDay] will change to the [day] of the 
  /// generated date.
  /// 
  /// Be careful when working with dates in local time.
  DueDateTime addWeeks(int weeks, {bool sameDay = false}) =>
      add(_week * weeks, sameDay: sameDay);

  /// Returns a new [DateTime] instance with [weeks] weeks subtracted from [this].
  ///
  /// If [sameDay] is true, keeps the current expected day of the month 
  /// ([dueDay]). If is false, the [dueDay] will change to the [day] of the 
  /// generated date.
  ///
  /// Be careful when working with dates in local time.
  DueDateTime subtractWeeks(int weeks, {bool sameDay = false}) =>
      subtract(_week * weeks, sameDay: sameDay);

  DueDateTime get nextWeek => addWeeks(1);
  DueDateTime get nextMonth => addMonths(1);
  DueDateTime get nextYear => addMonths(12);

  DueDateTime get previousWeek => subtractWeeks(1);
  DueDateTime get previousMonth => subtractMonths(1);
  DueDateTime get previousYear => subtractMonths(12);
}
