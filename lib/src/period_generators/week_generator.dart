import 'package:equatable/equatable.dart';
import 'package:time/time.dart';
import '../periods/periods.dart';
import 'period_generator_mixin.dart';

/// A class that implements a generator of a period type of a week.
class WeekGenerator with PeriodGeneratorMixin<WeekPeriod>, EquatableMixin {
  /// A class that implements a generator of a period type of a week.
  const WeekGenerator({this.weekStart = DateTime.monday});

  /// The first day of the week.
  final int weekStart;

  @override
  WeekPeriod of(DateTime date) {
    var difference = weekStart - date.weekday;
    if (difference > 0) difference -= DateTime.daysPerWeek;
    final day = date.day + difference;
    final start = date.copyWith(day: day).date;
    final end =
        start.add(const Duration(days: DateTime.daysPerWeek - 1)).endOfDay;
    return WeekPeriod(start: start, end: end);
  }

  @override
  // ignore: hash_and_equals, overridden in EquatableMixin
  bool operator ==(Object other) {
    return (super == other) || (other is WeekGenerator);
  }

  @override
  List<Object?> get props => [weekStart];
}
