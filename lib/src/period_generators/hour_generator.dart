import 'package:equatable/equatable.dart';
import 'package:time/time.dart';
import '../periods/periods.dart';
import 'period_generator_mixin.dart';

/// A class that implements a generator of a period type of an hour.
class HourGenerator with PeriodGeneratorMixin<HourPeriod>, EquatableMixin {
  /// A class that implements a generator of a period type of an hour.
  const HourGenerator();

  @override
  HourPeriod of(DateTime date) {
    return HourPeriod(
      start: date.copyWith(
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      ),
      end: date.copyWith(
        minute: 59,
        second: 59,
        millisecond: 999,
        microsecond: 999,
      ),
    );
  }

  @override
  // ignore: hash_and_equals, overridden in EquatableMixin
  bool operator ==(Object other) {
    return (super == other) || (other is HourGenerator) && props == other.props;
  }

  @override
  List<Object?> get props => [];
}
