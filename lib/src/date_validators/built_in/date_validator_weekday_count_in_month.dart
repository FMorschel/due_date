import 'package:equatable/equatable.dart';
import 'package:time/time.dart';

import '../../enums/week.dart';
import '../../enums/weekday.dart';
import '../date_validator.dart';
import '../date_validator_mixin.dart';

/// A [DateValidator] that validates a [DateTime] if the [DateTime.day] is the
/// [day] of the week and is the [week] of the month.
class DateValidatorWeekdayCountInMonth
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
  factory DateValidatorWeekdayCountInMonth.from(DateTime date) =>
      DateValidatorWeekdayCountInMonth(
        week: Week.from(
          date,
          firstDayOfWeek: Weekday.from(date.firstDayOfMonth),
        ),
        day: Weekday.from(date),
      );

  /// The expected week of the month.
  final Week week;

  /// The expected day of the week.
  final Weekday day;

  @override
  List<Object> get props => [day, week];

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is DateValidatorWeekdayCountInMonth) &&
            (week == other.week) &&
            (day == other.day));
  }

  @override
  int compareTo(DateValidatorWeekdayCountInMonth other) {
    final result = week.compareTo(other.week);
    if (result == 0) return day.compareTo(other.day);
    return result;
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
}
