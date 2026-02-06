import 'package:equatable/equatable.dart';
import 'package:time/time.dart';

import '../periods/semester_period.dart';
import 'period_generator_mixin.dart';

/// A class that implements a generator of a period type of a semester.
class SemesterGenerator
    with PeriodGeneratorMixin<SemesterPeriod>, EquatableMixin {
  /// A class that implements a generator of a period type of a semester.
  const SemesterGenerator();

  @override
  SemesterPeriod of(DateTime date) {
    final julyFirst = date.copyWith(month: DateTime.july, day: 1).date;
    if (date.isBefore(julyFirst)) {
      return SemesterPeriod(
        start: date.firstDayOfYear.date,
        end: julyFirst.subtract(const Duration(microseconds: 1)),
      );
    }
    return SemesterPeriod(
      start: julyFirst,
      end: date.lastDayOfYear.endOfDay,
    );
  }

  @override
  // ignore: hash_and_equals, overridden in EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        (other is SemesterGenerator) && props == other.props;
  }

  @override
  List<Object?> get props => [];
}
