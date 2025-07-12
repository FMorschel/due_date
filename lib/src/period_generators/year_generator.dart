import 'package:equatable/equatable.dart';
import 'package:time/time.dart';
import '../periods/periods.dart';
import 'period_generator_mixin.dart';

/// A class that implements a generator of a period type of a year.
class YearGenerator with PeriodGeneratorMixin<YearPeriod>, EquatableMixin {
  /// A class that implements a generator of a period type of a year.
  const YearGenerator();

  @override
  YearPeriod of(DateTime date) {
    return YearPeriod(
      start: date.firstDayOfYear.date,
      end: date.lastDayOfYear.endOfDay,
    );
  }

  @override
  // ignore: hash_and_equals, overridden in EquatableMixin
  bool operator ==(Object other) {
    return (super == other) || (other is YearGenerator) && props == other.props;
  }

  @override
  List<Object?> get props => [];
}
