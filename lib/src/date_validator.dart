import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:time/time.dart';

import '../due_date.dart';

/// A class to save a specific validation for a [DateTime].
abstract class DateValidator {
  const DateValidator();

  /// Returns true if the [date] is valid for this [DateValidator].
  bool valid(DateTime date);

  /// Returns the valid dates for this [DateValidator] in [dates].
  Iterable<DateTime> validsIn(List<DateTime> dates);
}

/// Mixin to easily implement the [DateValidator.validsIn] method.
mixin DateValidatorMixin implements DateValidator {
  @override
  Iterable<DateTime> validsIn(List<DateTime> dates) sync* {
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
class DateValidatorDueDayMonth extends DateValidator
    with EquatableMixin, DateValidatorMixin
    implements Comparable<DateValidatorDueDayMonth> {
  /// A [DateValidator] that validates a [DateTime] if the [DateTime.day] is the
  /// same value as [dueDay].
  /// If [exact] is false, and the [dueDay] is greater than the days in month,
  /// the [DateTime] will be valid if the [DateTime.day] is the last day of the
  /// month.
  const DateValidatorDueDayMonth(
    this.dueDay, {
    this.exact = false,
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

  /// If true, the day of the month must be exactly this [dueDay].
  /// If false, and the [dueDay] is greater than the days in month, the
  /// [DateTime] will be valid if the [DateTime.day] is the last day of the
  /// month.
  final bool exact;

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

  @override
  List<Object> get props => [dueDay, exact];
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
  const DateValidatorDifference(super.validators);

  @override
  bool valid(DateTime date) {
    int valids = 0;
    for (final validator in validators) {
      if (validator.valid(date)) valids++;
      if (valids > 1) return false;
    }
    return true;
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
