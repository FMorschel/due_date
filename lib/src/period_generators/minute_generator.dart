import 'package:equatable/equatable.dart';
import 'package:time/time.dart';

import '../periods/periods.dart';
import 'period_generator_mixin.dart';

/// A class that implements a generator of a period type of a minute.
class MinuteGenerator with PeriodGeneratorMixin<MinutePeriod>, EquatableMixin {
  /// A class that implements a generator of a period type of a minute.
  const MinuteGenerator();

  @override
  MinutePeriod of(DateTime date) {
    return MinutePeriod(
      start: date.copyWith(
        second: 0,
        millisecond: 0,
        microsecond: 0,
      ),
      end: date.copyWith(
        second: 59,
        millisecond: 999,
        microsecond: 999,
      ),
    );
  }

  @override
  // ignore: hash_and_equals, overridden in EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        (other is MinuteGenerator) && props == other.props;
  }

  @override
  List<Object?> get props => [];
}
