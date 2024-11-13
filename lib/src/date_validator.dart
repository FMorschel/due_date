import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:time/time.dart';

import '../due_date.dart';
import 'shared_private.dart';

/// A class to save a specific validation for a [DateTime].
///
/// See also [ExactDateValidator].
@immutable
abstract class DateValidator {
  /// A class to save a specific validation for a [DateTime].
  const DateValidator();

  /// Returns true if the [date] is valid for this [DateValidator].
  ///
  /// This is the opposite of [valid].
  /// Implementations that return true for invalid should also return false for
  /// valid.
  bool valid(DateTime date);

  /// Returns true if the [date] is invalid for this [DateValidator].
  ///
  /// This is the opposite of [valid].
  /// Implementations that return true for invalid should also return false for
  /// valid.
  ///
  /// Usually, this will be implemented as `!valid(date)` by
  /// [DateValidatorMixin]. However, if there is a simpler way to check
  /// for invalid dates, it can be implemented here.
  bool invalid(DateTime date);

  /// Returns the valid dates for this [DateValidator] in [dates].
  @Deprecated("Use 'DateValidator.filterValidDates' instead.")
  Iterable<DateTime> validsIn(Iterable<DateTime> dates);

  /// Returns the valid dates for this [DateValidator] in [dates].
  Iterable<DateTime> filterValidDates(Iterable<DateTime> dates);
}

/// {@template exactDateValidator}
/// A class to save a specific validation for a [DateTime].
///
/// This version of [DateValidator] is used to validate a [DateTime] if it is
/// exactly the same as the [DateTime] passed to [valid] or [invalid].
///
/// {@template inexactDates}
/// There can be cases where an inexact date is valid. For example, if the
/// validator is testing for a day in a period with an specific property, there
/// can be an exception for the last day(s) of the period with this property.
/// {@endtemplate}
/// {@endtemplate}
@immutable
abstract class ExactDateValidator extends DateValidator {
  /// {@macro exactDateValidator}
  const ExactDateValidator({this.exact = true});

  /// Returns whether the [DateTime] passed to [valid] or [invalid] can be
  /// inexact.
  ///
  /// If [exact] is true, this will return false.
  ///
  /// {@macro inexactDates}
  bool get inexact => !exact;

  /// Returns whether the [DateTime] passed to [valid] or [invalid] needs to fit
  /// exactly a specific date.
  ///
  /// {@macro inexactDates}
  final bool exact;
}

/// Mixin to easily implement the [DateValidator.invalid],
/// [DateValidator.filterValidDates] and [DateValidator.filterValidDates]
/// methods.
mixin DateValidatorMixin implements DateValidator {
  @override
  bool invalid(DateTime date) => !valid(date);

  @override
  @Deprecated("Use 'DateValidator.filterValidDates' instead.")
  Iterable<DateTime> validsIn(Iterable<DateTime> dates) =>
      filterValidDates(dates);

  @override
  Iterable<DateTime> filterValidDates(Iterable<DateTime> dates) sync* {
    for (final date in dates) {
      if (valid(date)) yield date;
    }
  }
}

/// A [DateValidator] that validates a [DateTime] if it is on the given
/// [weekday].
class DateValidatorWeekday
    with EquatableMixin, DateValidatorMixin
    implements Comparable<DateValidatorWeekday> {
  /// A [DateValidator] that validates a [DateTime] if it is on the given
  /// [weekday].
  const DateValidatorWeekday(this.weekday);

  /// A [DateValidator] that validates a [DateTime] if it is on the given
  /// [weekday].
  factory DateValidatorWeekday.from(DateTime date) {
    return DateValidatorWeekday(Weekday.from(date));
  }

  /// A [DateValidator] that validates a [DateTime] if it is a workday.
  static const workdays = DateValidatorUnion([
    EveryWeekday(Weekday.monday),
    EveryWeekday(Weekday.tuesday),
    EveryWeekday(Weekday.wednesday),
    EveryWeekday(Weekday.thursday),
    EveryWeekday(Weekday.friday),
  ]);

  /// A [DateValidator] that validates a [DateTime] if it is a weekend.
  static const weekend = DateValidatorUnion([
    EveryWeekday(Weekday.saturday),
    EveryWeekday(Weekday.sunday),
  ]);

  /// The expected weekday.
  final Weekday weekday;

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is DateValidatorWeekday) && (weekday == other.weekday));
  }

  @override
  bool valid(DateTime date) => date.weekday == weekday.dateTimeValue;

  @override
  int compareTo(DateValidatorWeekday other) => weekday.compareTo(other.weekday);

  @override
  List<Object> get props => [weekday];
}

/// A [DateValidator] that validates a [DateTime] if the [DateTime.day] is the
/// same value as [dueDay].
/// If [exact] is false, and the [dueDay] is greater than the days in month,
/// the [DateTime] will be valid if the [DateTime.day] is the last day of the
/// month.
class DateValidatorDueDayMonth extends ExactDateValidator
    with EquatableMixin, DateValidatorMixin
    implements Comparable<DateValidatorDueDayMonth> {
  /// A [DateValidator] that validates a [DateTime] if the [DateTime.day] is the
  /// same value as [dueDay].
  /// If [exact] is false, and the [dueDay] is greater than the days in month,
  /// the [DateTime] will be valid if the [DateTime.day] is the last day of the
  /// month.
  const DateValidatorDueDayMonth(
    this.dueDay, {
    super.exact = false,
  }) : assert(
          (dueDay >= 1) && (dueDay <= 31),
          'Due day must be between 1 and 31',
        );

  /// A [DateValidator] that validates a [DateTime] if the [DateTime.day] is the
  /// same value as [dueDay].
  /// If [exact] is false, and the [dueDay] is greater than the days in month,
  /// the [DateTime] will be valid if the [DateTime.day] is the last day of the
  /// month.
  factory DateValidatorDueDayMonth.from(
    DateTime date, {
    bool exact = false,
  }) {
    return DateValidatorDueDayMonth(date.day, exact: exact);
  }

  /// The expected day of the month.
  final int dueDay;

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is DateValidatorDueDayMonth) &&
            (dueDay == other.dueDay) &&
            (exact == other.exact));
  }

  @override
  bool valid(DateTime date) {
    if (exact) return date.day == dueDay;
    final actualDay = dueDay.clamp(
      date.firstDayOfMonth.day,
      date.lastDayOfMonth.day,
    );
    return date.day == actualDay;
  }

  @override
  int compareTo(DateValidatorDueDayMonth other) =>
      dueDay.compareTo(other.dueDay);

  /// If true, the day of the month must be exactly this [dueDay].
  ///
  /// If false, and the [dueDay] is greater than the days in month, the
  /// [DateTime] will be valid if the [DateTime.day] is the last day of the
  /// month.
  @override
  bool get exact => super.exact;

  /// Returns whether the [DateTime] passed to [valid] or [invalid] can be
  /// inexact.
  ///
  /// If [exact] is true, this will return false.
  ///
  /// If this is false, and the month has less than [dueDay] days, the last day
  /// will be considered valid.
  @override
  bool get inexact => super.inexact;

  @override
  List<Object> get props => [dueDay, exact];
}

/// A [DateValidator] that validates a [DateTime] if the [DateTime.day] is the
/// same value as [dueWorkday].
/// If [exact] is false, and the [dueWorkday] is greater than the days in month,
/// the [DateTime] will be valid if the [DateTime.day] is the last day of the
/// month.
class DateValidatorDueWorkdayMonth extends ExactDateValidator
    with EquatableMixin, DateValidatorMixin
    implements Comparable<DateValidatorDueWorkdayMonth> {
  /// A [DateValidator] that validates a [DateTime] if the [DateTime.day] is the
  /// same value as [dueWorkday].
  /// If [exact] is false, and the [dueWorkday] is greater than the days in
  /// month, the [DateTime] will be valid if the [DateTime.day] is the last day
  /// of the month.
  const DateValidatorDueWorkdayMonth(
    this.dueWorkday, {
    super.exact = false,
  }) : assert(
          (dueWorkday >= 1) && (dueWorkday <= 23),
          'Due workday must be between 1 and 23',
        );

  /// A [DateValidator] that validates a [DateTime] if the [DateTime.day] is the
  /// same value as [dueWorkday].
  /// If [exact] is false, and the [dueWorkday] is greater than the days in
  /// month, the [DateTime] will be valid if the [DateTime.day] is the last day
  /// of the month.
  factory DateValidatorDueWorkdayMonth.from(
    DateTime date, {
    WorkdayDirection direction = WorkdayDirection.forward,
    bool exact = false,
  }) {
    var local = date.copyWith();
    if (!direction.isNone) {
      local = WeekdayHelper.adjustToWorkday(date, isNext: direction.isForward);
    }
    return DateValidatorDueWorkdayMonth(
      WeekdayHelper.getWorkdayNumberInMonth(
        local,
        shouldThrow: direction.isNone,
      ),
      exact: exact,
    );
  }

  static const _workdays = WeekdayHelper.every;

  /// The expected workday of the month.
  final int dueWorkday;

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is DateValidatorDueWorkdayMonth) &&
            (dueWorkday == other.dueWorkday) &&
            (exact == other.exact));
  }

  @override
  bool valid(DateTime date) {
    if (_workdays.invalid(date)) return false;
    final count = WeekdayHelper.getWorkdayNumberInMonth(date);
    if (count == dueWorkday) return true;
    if (exact) return false;
    var local = date.copyWith();
    local = _workdays.next(date);
    if (!local.isAtSameMonthAs(date) && count < dueWorkday) return true;
    return false;
  }

  @override
  int compareTo(DateValidatorDueWorkdayMonth other) =>
      dueWorkday.compareTo(other.dueWorkday);

  /// Returns whether the [DateTime] passed to [valid] or [invalid] can be
  /// inexact.
  ///
  /// If [exact] is true, this will return false.
  ///
  /// If this is false, and the month has less than [dueWorkday] workdays, the
  /// last workday will be considered valid.
  @override
  bool get inexact => super.inexact;

  /// If true, the workday of the month must be exactly this [dueWorkday].
  /// If false, and the [dueWorkday] is greater than the workdays in month, the
  /// [DateTime] will be valid if the [DateTime.day] is the last workday of the
  /// month.
  @override
  bool get exact => super.exact;

  @override
  List<Object> get props => [dueWorkday, exact];
}

/// A [DateValidator] that validates a [DateTime] if the [DateTime.day] is the
/// [day] of the week and is the [week] of the month.
class DateValidatorWeekdayCountInMonth extends DateValidator
    with EquatableMixin, DateValidatorMixin
    implements Comparable<DateValidatorWeekdayCountInMonth> {
  /// A [DateValidator] that validates a [DateTime] if the [DateTime.day] is the
  /// [day] of the week and is the [week] of the month.
  const DateValidatorWeekdayCountInMonth({
    required this.week,
    required this.day,
  });

  /// A [DateValidator] that validates a [DateTime] if the [DateTime.day] is the
  /// [day] of the week and is the [week] of the month.
  factory DateValidatorWeekdayCountInMonth.from(DateTime date) {
    return DateValidatorWeekdayCountInMonth(
      week: Week.from(date),
      day: Weekday.from(date),
    );
  }

  /// The expected week of the month.
  final Week week;

  /// The expected day of the week.
  final Weekday day;

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is DateValidatorWeekdayCountInMonth) &&
            (week == other.week) &&
            (day == other.day));
  }

  @override
  bool valid(DateTime date) {
    final valid = week.weekdayOf(
      year: date.year,
      month: date.month,
      day: day,
      utc: date.isUtc,
    );
    return valid.add(date.timeOfDay) == date;
  }

  @override
  int compareTo(DateValidatorWeekdayCountInMonth other) {
    final result = week.compareTo(other.week);
    if (result == 0) return day.compareTo(other.day);
    return result;
  }

  @override
  List<Object> get props => [day, week];
}

/// A [DateValidator] that validates a [DateTime] if the [DateTime.day] is the
/// [dayInYear] of the year.
class DateValidatorDayInYear extends DateValidator
    with EquatableMixin, DateValidatorMixin
    implements Comparable<DateValidatorDayInYear> {
  /// A [DateValidator] that validates a [DateTime] if the [DateTime.day] is the
  /// [dayInYear] of the year.
  const DateValidatorDayInYear(
    this.dayInYear, {
    this.exact = false,
  }) : assert(
          dayInYear >= 1 && dayInYear <= 366,
          'Day In Year must be between 1 and 366',
        );

  /// A [DateValidator] that validates a [DateTime] if the [DateTime.day] is the
  /// [dayInYear] of the year.
  factory DateValidatorDayInYear.from(
    DateTime date, {
    bool exact = false,
  }) {
    return DateValidatorDayInYear(date.dayInYear, exact: exact);
  }

  /// The expected day in the year.
  ///
  /// - The first day of the year is 1.
  /// - The last day of the year is 365/366.
  final int dayInYear;

  /// If true, the day of the year must be exactly this [dayInYear].
  /// If false, if the [dayInYear] is greater than the days in year, the
  /// [DateTime] will be valid if the [DateTime.day] is the last day of the
  /// year.
  final bool exact;

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is DateValidatorDayInYear) &&
            (dayInYear == other.dayInYear) &&
            (exact == other.exact));
  }

  @override
  bool valid(DateTime date) {
    if (exact) return date.dayInYear == dayInYear;
    final actualDay = dayInYear.clamp(
      date.firstDayOfYear.dayInYear,
      date.lastDayOfYear.dayInYear,
    );
    return date.dayInYear == actualDay;
  }

  @override
  int compareTo(DateValidatorDayInYear other) =>
      dayInYear.compareTo(other.dayInYear);

  @override
  List<Object> get props => [dayInYear];
}

/// Mixin that represents a list of [DateValidator]s.
mixin DateValidatorListMixin<E extends DateValidator> on List<E>
    implements DateValidator {
  /// List for all of the [validators] that will be used to validate the date.
  List<DateValidator> get validators => [...this];
}

/// A [DateValidator] that validates a [DateTime] if the date is valid for all
/// of the [validators].
class DateValidatorIntersection<E extends DateValidator>
    extends DelegatingList<E>
    with EquatableMixin, DateValidatorMixin, DateValidatorListMixin {
  /// A [DateValidator] that validates a [DateTime] if the date is valid for all
  /// of the [validators].
  const DateValidatorIntersection(super.validators);

  @override
  bool valid(DateTime date) {
    return validators.every((validator) => validator.valid(date));
  }

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is DateValidatorIntersection) &&
            (other.validators == validators));
  }

  @override
  List<Object> get props => [...this];
}

/// A [DateValidator] that validates a [DateTime] if the date is valid for any
/// of the [validators].
class DateValidatorUnion<E extends DateValidator> extends DelegatingList<E>
    with EquatableMixin, DateValidatorMixin, DateValidatorListMixin {
  /// A [DateValidator] that validates a [DateTime] if the date is valid for any
  /// of the [validators].
  const DateValidatorUnion(super.validators);

  @override
  bool valid(DateTime date) {
    return validators.any((validator) => validator.valid(date));
  }

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is DateValidatorUnion) && (other.validators == validators));
  }

  @override
  List<Object> get props => [...this];
}

/// A [DateValidator] that validates a [DateTime] if the date is valid for only
/// one of the [validators].
class DateValidatorDifference<E extends DateValidator> extends DelegatingList<E>
    with EquatableMixin, DateValidatorMixin, DateValidatorListMixin {
  /// A [DateValidator] that validates a [DateTime] if the date is valid for
  /// only one of the [validators].
  const DateValidatorDifference(super.validators);

  @override
  bool valid(DateTime date) {
    var validCount = 0;
    for (final validator in validators) {
      if (validator.valid(date)) validCount++;
      if (validCount > 1) return false;
    }
    if (validCount == 0) return false;
    return true;
  }

  @override
  bool invalid(DateTime date) {
    var validCount = 0;
    for (final validator in validators) {
      if (validator.valid(date)) validCount++;
      if (validCount > 1) return true;
    }
    if (validCount == 0) return true;
    return false;
  }

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is DateValidatorDifference) &&
            (other.validators == validators));
  }

  @override
  List<Object> get props => [...this];
}
