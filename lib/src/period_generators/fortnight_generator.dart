import 'package:equatable/equatable.dart';
import 'package:time/time.dart';
import '../periods/periods.dart';
import 'period_generator_mixin.dart';

/// A class that implements a generator of a period type of a fortnight.
class FortnightGenerator
    with PeriodGeneratorMixin<FortnightPeriod>, EquatableMixin {
  /// A class that implements a generator of a period type of a fortnight.
  const FortnightGenerator();

  @override
  FortnightPeriod of(DateTime date) {
    final sixteenth = date.copyWith(day: 16).date;
    if (date.isBefore(sixteenth)) {
      return FortnightPeriod(
        start: date.firstDayOfMonth.date,
        end: sixteenth.subtract(const Duration(microseconds: 1)),
      );
    }
    return FortnightPeriod(
      start: sixteenth,
      end: date.lastDayOfMonth.endOfDay,
    );
  }

  @override
  // ignore: hash_and_equals, overridden in EquatableMixin
  bool operator ==(Object other) {
    return (super == other) || (other is FortnightGenerator);
  }

  @override
  List<Object?> get props => [];
}
