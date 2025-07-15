import 'package:equatable/equatable.dart';
import 'package:time/time.dart';

import '../periods/periods.dart';
import 'period_generator_mixin.dart';

/// A class that implements a generator of a period type of a second.
class SecondGenerator with PeriodGeneratorMixin<SecondPeriod>, EquatableMixin {
  /// A class that implements a generator of a period type of a second.
  const SecondGenerator();

  @override
  SecondPeriod of(DateTime date) {
    return SecondPeriod(
      start: date.copyWith(
        millisecond: 0,
        microsecond: 0,
      ),
      end: date.copyWith(
        millisecond: 999,
        microsecond: 999,
      ),
    );
  }

  @override
  // ignore: hash_and_equals, overridden in EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        (other is SecondGenerator) && props == other.props;
  }

  @override
  List<Object?> get props => [];
}
