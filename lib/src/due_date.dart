import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:time/time.dart';

import 'everies/every.dart';
import 'everies/every_date_validator.dart';
import 'everies/every_due_day_month.dart';
import 'everies/every_month.dart';
import 'everies/every_week.dart';
import 'everies/every_year.dart';
import 'everies/limited_every.dart';
import 'everies/limited_every_date_validator.dart';

/// Wrapper for [Every] and [DateTime] to represent a due date.
@immutable
class DueDateTime<T extends Every> extends DateTime with EquatableMixin {
  /// Constructs a [DueDateTime] instance.
  ///
  /// For example, to create a `DueDateTime` object representing the 7th of
  /// September 2017, 5:30pm.
  ///
  /// The [limit] will be passed to the [Every] instance if it is a
  /// [LimitedEvery].
  ///
  /// ```dart
  /// final dentistAppointment = DueDateTime(
  ///   year: 2017,
  ///   month: 9,
  ///   day: 7,
  ///   hour: 17,
  ///   minute: 30,
  /// );
  /// ```
  ///
  /// The [every] parameter is optional. If it is provided, the [DueDateTime]
  /// will be adjusted to the next due date. If it is not provided, the
  /// values will be used as-is. And the [DueDateTime.every] property will
  /// be:
  ///
  /// ```dart
  /// EveryDueDayMonth(day);
  /// ```
  factory DueDateTime({
    required int year,

    /// The handler for the operations.
    T? every,
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
    bool utc = false,

    /// The limit for the operations.
    DateTime? limit,
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
    return DueDateTime.fromDate(date, every: every, limit: limit);
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

  /// Constructs a [DueDateTime] instance specified in the UTC time zone.
  ///
  /// ```dart
  /// final moonLanding = DueDateTime.utc(
  ///   year: 1969,
  ///   month: 7,
  ///   day: 20,
  ///   hour: 20,
  ///   minute: 18,
  ///   second: 04,
  /// );
  /// ```
  ///
  /// The [limit] will be passed to the [Every] instance if it is a
  /// [LimitedEvery].
  ///
  /// When dealing with dates or historic events, preferably use UTC DateTimes,
  /// since they are unaffected by daylight-saving changes and are unaffected
  /// by the local timezone.
  ///
  /// The [every] parameter is optional. If it is provided, the [DueDateTime]
  /// will be adjusted to the next due date. If it is not provided, the
  /// values will be used as-is. And the [DueDateTime.every] property will
  /// be:
  ///
  /// ```dart
  /// EveryDueDayMonth(day);
  /// ```
  factory DueDateTime.utc({
    required int year,

    /// The handler for the operations.
    T? every,
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,

    /// The limit for the operations.
    DateTime? limit,
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
        limit: limit,
      );

  /// Constructs a [DueDateTime] instance with current date and time in the
  /// local time zone. The [DueDateTime.every] property will be:
  ///
  /// ```dart
  /// EveryDueDayMonth(day);
  /// ```
  ///
  /// The [limit] will be passed to the [Every] instance if it is a
  /// [LimitedEvery].
  factory DueDateTime.now({
    /// The limit for the operations.
    DateTime? limit,
  }) {
    final now = clock.now();
    return DueDateTime.fromDate(
      now,
      every: EveryDueDayMonth(now.day) as T,
      limit: limit,
    );
  }

  /// Creates a [DueDateTime] from the [reference].
  ///
  /// The [every] parameter is optional. If it is provided, the [DueDateTime]
  /// will be adjusted to the next due date. If it is not provided, the
  /// [reference] will be used as-is. And the [DueDateTime.every] property will
  /// be:
  ///
  /// ```dart
  /// EveryDueDayMonth(reference.day).
  /// ```
  factory DueDateTime.fromDate(
    DateTime reference, {
    /// The handler for the operations.
    T? every,

    /// The limit for the operations.
    DateTime? limit,
  }) {
    if (every == null) {
      return DueDateTime._toConstructor(
        every: EveryDueDayMonth(reference.day) as T,
        date: reference,
      );
    }
    return DueDateTime<T>._toConstructor(
      date: every is EveryDateValidator
          ? (every is LimitedEveryDateValidator
              ? every.startDate(reference, limit: limit)
              : every.startDate(reference))
          : reference,
      every: every,
    );
  }

  factory DueDateTime._toConstructor({
    /// The handler for the operations.
    required T every,
    required DateTime date,
  }) {
    return date.isUtc
        ? DueDateTime<T>._utcFromDate(every: every, date: date)
        : DueDateTime<T>._fromDate(every: every, date: date);
  }

  static const _week = Duration(days: DateTime.daysPerWeek);

  /// The handler for processing the next dates.
  final T every;

  // ignore: format-comment, false positive
  /// Constructs a new [DueDateTime] instance based on [formattedString].
  ///
  /// Throws a [FormatException] if the input string cannot be parsed.
  ///
  /// The function parses a subset of ISO 8601,
  /// which includes the subset accepted by RFC 3339.
  ///
  /// The accepted inputs are currently:
  ///
  /// * A date: A signed four-to-six digit year, two digit month and
  ///   two digit day, optionally separated by `-` characters.
  ///   Examples: "19700101", "-0004-12-24", "81030-04-01".
  /// * An optional time part, separated from the date by either `T` or a space.
  ///   The time part is a two digit hour,
  ///   then optionally a two digit minutes value,
  ///   then optionally a two digit seconds value, and
  ///   then optionally a '.' or ',' followed by at least a one digit
  ///   second fraction.
  ///   The minutes and seconds may be separated from the previous parts by a
  ///   ':'.
  ///   Examples: "12", "12:30:24.124", "12:30:24,124", "123010.50".
  /// * An optional time-zone offset part,
  ///   possibly separated from the previous by a space.
  ///   The time zone is either 'z' or 'Z', or it is a signed two digit hour
  ///   part and an optional two digit minute part. The sign must be either
  ///   "+" or "-", and cannot be omitted.
  ///   The minutes may be separated from the hours by a ':'.
  ///   Examples: "Z", "-10", "+01:30", "+1130".
  ///
  /// This includes the output of both [toString] and [toIso8601String], which
  /// will be parsed back into a `DueDateTime` object with the same time as the
  /// original.
  ///
  /// The result is always in either local time or UTC.
  /// If a time zone offset other than UTC is specified,
  /// the time is converted to the equivalent UTC time.
  ///
  /// Examples of accepted strings:
  ///
  /// * `"2012-02-27"`
  /// * `"2012-02-27 13:27:00"`
  /// * `"2012-02-27 13:27:00.123456789z"`
  /// * `"2012-02-27 13:27:00,123456789z"`
  /// * `"20120227 13:27:00"`
  /// * `"20120227T132700"`
  /// * `"20120227"`
  /// * `"+20120227"`
  /// * `"2012-02-27T14Z"`
  /// * `"2012-02-27T14+00:00"`
  /// * `"-123450101 00:00:00 Z"`: in the year -12345.
  /// * `"2002-02-27T14:00:00-0500"`: Same as `"2002-02-27T19:00:00Z"`
  ///
  /// This method accepts out-of-range component values and interprets
  /// them as overflows into the next larger component.
  /// For example, "2020-01-42" will be parsed as 2020-02-11, because
  /// the last valid date in that month is 2020-01-31, so 42 days is
  /// interpreted as 31 days of that month plus 11 days into the next month.
  ///
  /// To detect and reject invalid component values, use
  /// [DateFormat.parseStrict](https://pub.dev/documentation/intl/latest/intl/DateFormat/parseStrict.html)
  /// from the [intl](https://pub.dev/packages/intl) package.
  ///
  /// The [every] parameter is optional. If [every] is provided, the
  /// [DueDateTime] will be adjusted to the next due date. If it is not
  /// provided, the [formattedString] will be used as-is. And the
  /// [DueDateTime.every] property will be:
  ///
  /// ```dart
  /// EveryDueDayMonth(day);
  /// ```
  ///
  /// The [limit] will be passed to the [Every] instance if it is a
  /// [LimitedEvery] instance.
  static DueDateTime parse(
    String formattedString, {
    /// The handler for the operations.
    Every? every,

    /// The limit for the operations.
    DateTime? limit,
  }) {
    return DueDateTime.fromDate(
      DateTime.parse(formattedString),
      every: every,
      limit: limit,
    );
  }

  /// Constructs a new [DueDateTime] instance based on [formattedString].
  ///
  /// Works like [parse] except that this function returns `null`
  /// where [parse] would throw a [FormatException].
  ///
  /// The [every] parameter is optional. If it is provided, the [DueDateTime]
  /// will be adjusted to the next due date. If it is not provided, the
  /// [formattedString] will be used as-is. And the
  /// [DueDateTime.every] property will be:
  ///
  /// ```dart
  /// EveryDueDayMonth(day);
  /// ```
  ///
  /// The [limit] will be passed to the [Every] instance if it is a
  /// [LimitedEvery] instance.
  static DueDateTime? tryParse(
    String formattedString, {
    /// The handler for the operations.
    Every? every,

    /// The limit for the operations.
    DateTime? limit,
  }) {
    final nullableDate = DateTime.tryParse(formattedString);
    if (nullableDate == null) return null;
    return DueDateTime.fromDate(nullableDate, every: every, limit: limit);
  }

  /// Constructs a new [DueDateTime] instance
  /// with the given [millisecondsSinceEpoch].
  ///
  /// If [isUtc] is false then the date is in the local time zone.
  ///
  /// The constructed [DueDateTime] represents 1970-01-01T00:00:00Z +
  /// [millisecondsSinceEpoch] ms in the given time zone (local or UTC).
  ///
  /// ```dart
  /// final newYearsDay =
  ///     DueDateTime.fromMillisecondsSinceEpoch(1640979000000, isUtc:true);
  /// print(newYearsDay); // 2022-01-01 10:00:00.000Z
  /// ```
  ///
  /// The [every] parameter is optional. If it is provided, the [DueDateTime]
  /// will be adjusted to the next due date. If it is not provided, the
  /// [millisecondsSinceEpoch] will be used as-is. And the [DueDateTime.every]
  /// property will be:
  ///
  /// ```dart
  /// EveryDueDayMonth(day);
  /// ```
  ///
  /// The [limit] will be passed to the [Every] instance if it is a
  /// [LimitedEvery] instance.
  static DueDateTime fromMillisecondsSinceEpoch(
    int millisecondsSinceEpoch, {
    bool isUtc = false,

    /// The handler for the operations.
    Every? every,

    /// The limit for the operations.
    DateTime? limit,
  }) {
    final date = DateTime.fromMillisecondsSinceEpoch(
      millisecondsSinceEpoch,
      isUtc: isUtc,
    );
    return DueDateTime.fromDate(date, every: every, limit: limit);
  }

  /// Constructs a new [DueDateTime] instance
  /// with the given [microsecondsSinceEpoch].
  ///
  /// If [isUtc] is false, then the date is in the local time zone.
  ///
  /// The constructed [DueDateTime] represents 1970-01-01T00:00:00Z +
  /// [microsecondsSinceEpoch] us in the given time zone (local or UTC).
  ///
  /// ```dart
  /// final newYearsEve =
  ///     DueDateTime.fromMicrosecondsSinceEpoch(1640901600000000, isUtc:true);
  /// print(newYearsEve); // 2021-12-31 19:30:00.000Z
  /// ```
  ///
  /// The [every] parameter is optional. If it is provided, the [DueDateTime]
  /// will be adjusted to the next due date. If it is not provided, the
  /// [microsecondsSinceEpoch] will be used as-is. And the [DueDateTime.every]
  /// property will be:
  ///
  /// ```dart
  /// EveryDueDayMonth(day);
  /// ```
  ///
  /// The [limit] will be passed to the [Every] instance if it is a
  /// [LimitedEvery] instance.
  static DueDateTime fromMicrosecondsSinceEpoch(
    int microsecondsSinceEpoch, {
    bool isUtc = false,

    /// The handler for the operations.
    Every? every,

    /// The limit for the operations.
    DateTime? limit,
  }) {
    final date = DateTime.fromMicrosecondsSinceEpoch(
      microsecondsSinceEpoch,
      isUtc: isUtc,
    );
    return DueDateTime.fromDate(date, every: every, limit: limit);
  }

  /// Creates a copy of this [DueDateTime] but with the given fields replaced
  /// with the new values.
  ///
  /// The [limit] will be passed to the [Every] instance if it is a
  /// [LimitedEvery] instance.
  ///
  /// Toggling [utc] (compared with [isUtc]) will _**NOT**_ convert the date,
  /// it will simply create a new [DateTime] with the same values in that
  /// timezone.
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
    bool? utc,

    /// The limit for the operations.
    DateTime? limit,
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
      utc: utc ?? isUtc,
      limit: limit,
    );
  }

  /// Returns this DueDateTime value in the UTC time zone.
  ///
  /// Returns `this` if it is already in UTC.
  /// Otherwise this method is equivalent to:
  ///
  /// ```dart template:expression
  /// DueDateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch,
  ///                                     isUtc: true)
  /// ```
  @override
  DueDateTime toUtc() => DueDateTime._utcFromDate(
        every: every,
        date: super.toUtc(),
      );

  /// Returns this DueDateTime value in the local time zone.
  ///
  /// Returns `this` if it is already in the local time zone.
  /// Otherwise this method is equivalent to:
  ///
  /// ```dart template:expression
  /// DueDateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch,
  ///                                     isUtc: false)
  /// ```
  @override
  DueDateTime toLocal() => DueDateTime._fromDate(
        every: every,
        date: super.toLocal(),
      );

  /// Returns a new [DueDateTime] instance with [duration] added to `this`.
  ///
  /// If [sameEvery] is true, keeps the current one. If is false, the [every]
  /// will change to the [day] of the generated date.
  ///
  /// ```dart
  /// EveryDueDayMonth(day);
  /// ```
  ///
  /// ```dart
  /// final today = DueDateTime.now();
  /// final fiftyDaysFromNow = today.add(const Duration(days: 50));
  /// ```
  ///
  /// Notice that the duration being added is actually 50 * 24 * 60 * 60
  /// seconds. If the resulting `DueDateTime` has a different daylight saving
  /// offset than `this`, then the result won't have the same time-of-day as
  /// `this`, and may not even hit the calendar date 50 days later.
  ///
  /// Be careful when working with dates in local time.
  @override
  DueDateTime add(
    Duration duration, {
    bool sameEvery = true,
  }) {
    final date = super.add(duration);
    return DueDateTime.fromDate(date, every: sameEvery ? every : null);
  }

  /// Returns a new [DueDateTime] instance with [duration] subtracted from
  /// `this`.
  ///
  /// If [sameEvery] is true, keeps the current one. If is false, the [every]
  /// will change to the [day] of the generated date.
  ///
  /// ```dart
  /// EveryDueDayMonth(day);
  /// ```
  ///
  /// ```dart
  /// final today = DueDateTime.now();
  /// final fiftyDaysAgo = today.subtract(const Duration(days: 50));
  /// ```
  ///
  /// Notice that the duration being subtracted is actually 50 * 24 * 60 * 60
  /// seconds. If the resulting `DueDateTime` has a different daylight saving
  /// offset than `this`, then the result won't have the same time-of-day as
  /// `this`, and may not even hit the calendar date 50 days earlier.
  ///
  /// Be careful when working with dates in local time.
  @override
  DueDateTime subtract(
    Duration duration, {
    bool sameEvery = true,
  }) {
    final date = super.subtract(duration);
    return DueDateTime.fromDate(date, every: sameEvery ? every : null);
  }

  /// Returns a new [DueDateTime] instance with [weeks] weeks added to this.
  ///
  /// If [sameEvery] is true, keeps the current one. If is false, the [every]
  /// will change to the [day] of the generated date.
  ///
  /// ```dart
  /// EveryDueDayMonth(day);
  /// ```
  ///
  /// Be careful when working with dates in local time.
  DueDateTime addWeeks(int weeks, {bool sameEvery = true}) {
    if (every is EveryWeek) {
      final date = (every as EveryWeek).addWeeks(this, weeks);
      return DueDateTime.fromDate(date, every: sameEvery ? every : null);
    }
    return add(_week * weeks, sameEvery: sameEvery);
  }

  /// Returns a new [DueDateTime] instance with [weeks] weeks subtracted from
  /// this.
  ///
  /// If [sameEvery] is true, keeps the current one. If is false, the [every]
  /// will change to the [day] of the generated date.
  ///
  /// ```dart
  /// EveryDueDayMonth(day);
  /// ```
  ///
  /// Be careful when working with dates in local time.
  DueDateTime subtractWeeks(int weeks, {bool sameEvery = true}) => addWeeks(
        -weeks,
        sameEvery: sameEvery,
      );

  /// Returns a new [DueDateTime] instance with [months] months added to this.
  ///
  /// If [sameEvery] is true, keeps the current one. If is false, the [every]
  /// will change to the [day] of the generated date.
  ///
  /// ```dart
  /// EveryDueDayMonth(day);
  /// ```
  ///
  /// Be careful when working with dates in local time.
  DueDateTime addMonths(
    int months, {
    bool sameEvery = true,
  }) {
    if (every is EveryMonth) {
      return DueDateTime.fromDate(
        (every as EveryMonth).addMonths(this, months),
        every: sameEvery ? every : null,
      );
    }
    return DueDateTime.fromDate(
      EveryDueDayMonth(day).addMonths(this, months),
      every: sameEvery ? every : null,
    );
  }

  /// Returns a new [DueDateTime] instance with [months] months subtracted from
  /// this.
  ///
  /// If [sameEvery] is true, keeps the current one. If is false, the [every]
  /// will change to the [day] of the generated date.
  ///
  /// ```dart
  /// EveryDueDayMonth(day);
  /// ```
  ///
  /// Be careful when working with dates in local time.
  DueDateTime subtractMonths(
    int months, {
    bool sameEvery = true,
  }) =>
      addMonths(-months, sameEvery: sameEvery);

  /// Returns a new [DueDateTime] instance with [years] years added to this.
  ///
  /// If the current [every] is! [EveryYear], the [every] used to create the
  /// new [DueDateTime] will be:
  ///
  /// ```dart
  /// EveryDueDayMonth(day);
  /// ```
  ///
  /// If [sameEvery] is true, keeps the current one. If is false, the [every]
  /// will change to the [day] of the generated date. And if the generated date
  /// is a leap year, and the [month] is February, the [day] will be set to 29
  /// only if the current date is 29, else it will stay with the same day only
  /// changing the year.
  ///
  /// ```dart
  /// EveryDueDayMonth(day);
  /// ```
  ///
  /// Be careful when working with dates in local time.
  DueDateTime addYears(
    int years, {
    bool sameEvery = true,
  }) {
    if (every is EveryYear) {
      return DueDateTime.fromDate(
        (every as EveryYear).addYears(this, years),
        every: sameEvery ? every : null,
      );
    }
    return DueDateTime.fromDate(
      EveryDueDayMonth(day).addYears(this, years),
      every: sameEvery ? every : null,
    );
  }

  /// Returns a new [DueDateTime] instance with [years] years subtracted from
  /// this.
  ///
  /// If [sameEvery] is true, keeps the current one. If is false, the [every]
  /// will change to the [day] of the generated date.
  ///
  /// ```dart
  /// EveryDueDayMonth(day);
  /// ```
  ///
  /// Be careful when working with dates in local time.
  DueDateTime subtractYears(
    int years, {
    bool sameEvery = true,
  }) =>
      addYears(-years, sameEvery: sameEvery);

  @override
  String toString() {
    final date = this.date.add(timeOfDay);
    return '$date - $every';
  }

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return super == other ||
        ((other is DueDateTime) &&
            const DeepCollectionEquality().equals(props, other.props));
  }

  /// Returns a new [DueDateTime] instance with the next date that matches the
  /// [every] main pattern.
  ///
  /// The [limit] parameter is used to limit the search for the next date when
  /// [every] is [LimitedEvery]. If [every] is not [LimitedEvery], the [limit]
  /// is ignored.
  ///
  /// The [limit] parameter is used to limit the search for the next date when
  /// [every] is [LimitedEvery]. If [every] is not [LimitedEvery], the [limit]
  /// is ignored.
  DueDateTime<T> next({
    /// The limit to search for the next date.
    DateTime? limit,
  }) =>
      DueDateTime.fromDate(
        every is LimitedEvery
            ? (every as LimitedEvery).next(this, limit: limit)
            : every.next(this),
        every: every,
      );

  /// Returns a new [DueDateTime] instance with the previous date that matches
  /// the [every] main pattern.
  ///
  /// The [limit] parameter is used to limit the search for the previous date
  /// when [every] is [LimitedEvery]. If [every] is not [LimitedEvery], the
  /// [limit] is ignored.
  DueDateTime<T> previous({
    /// The limit to search for the previous date.
    DateTime? limit,
  }) =>
      DueDateTime.fromDate(
        every is LimitedEvery
            ? (every as LimitedEvery).previous(this, limit: limit)
            : every.previous(this),
        every: every,
      );

  @override
  List<Object> get props => [
        every,
        year,
        month,
        day,
        hour,
        minute,
        second,
        millisecond,
        microsecond,
        isUtc,
      ];
}
