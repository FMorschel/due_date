import 'package:equatable/equatable.dart';
import 'package:time/time.dart';

import '../periods/month_period.dart';
import 'period_generator_mixin.dart';

/// A class that implements a generator of a period type of a month.
class MonthGenerator with PeriodGeneratorMixin<MonthPeriod>, EquatableMixin {
  /// A class that implements a generator of a period type of a month.
  const MonthGenerator();

  @override
  MonthPeriod of(DateTime date) {
    return MonthPeriod(
      start: date.firstDayOfMonth.date,
      end: date.lastDayOfMonth.endOfDay,
    );
  }

  @override
  // ignore: hash_and_equals, overridden in EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        (other is MonthGenerator) && props == other.props;
  }

  @override
  List<Object?> get props => [];
}
