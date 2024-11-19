import 'package:equatable/equatable.dart';
import 'package:time/time.dart';
import '../periods/periods.dart';
import 'period_generator_mixin.dart';

/// A class that implements a generator of a period type of a day.
class DayGenerator with PeriodGeneratorMixin<DayPeriod>, EquatableMixin {
  /// A class that implements a generator of a period type of a day.
  const DayGenerator();

  @override
  DayPeriod of(DateTime date) {
    final start = date.date;
    final end = date.endOfDay;
    return DayPeriod(start: start, end: end);
  }

  @override
  // ignore: hash_and_equals, overridden in EquatableMixin
  bool operator ==(Object other) {
    return (super == other) || (other is DayGenerator);
  }

  @override
  List<Object?> get props => [];
}
