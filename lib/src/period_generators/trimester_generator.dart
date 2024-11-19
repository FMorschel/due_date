import 'package:equatable/equatable.dart';
import 'package:time/time.dart';
import '../periods/periods.dart';
import 'period_generator_mixin.dart';

/// A class that implements a generator of a period type of a trimester.
class TrimesterGenerator
    with PeriodGeneratorMixin<TrimesterPeriod>, EquatableMixin {
  /// A class that implements a generator of a period type of a trimester.
  const TrimesterGenerator();

  @override
  TrimesterPeriod of(DateTime date) {
    final octoberFirst = date.copyWith(month: DateTime.october, day: 1).date;
    if (date.isBefore(octoberFirst)) {
      final julyFirst = date.copyWith(month: DateTime.july, day: 1).date;
      if (date.isBefore(julyFirst)) {
        final aprilFirst = date.copyWith(month: DateTime.april, day: 1).date;
        if (date.isBefore(aprilFirst)) {
          return TrimesterPeriod(
            start: date.firstDayOfYear.date,
            end: aprilFirst.subtract(const Duration(microseconds: 1)),
          );
        }
        return TrimesterPeriod(
          start: aprilFirst,
          end: julyFirst.subtract(const Duration(microseconds: 1)),
        );
      }
      return TrimesterPeriod(
        start: julyFirst,
        end: octoberFirst.subtract(const Duration(microseconds: 1)),
      );
    }
    return TrimesterPeriod(
      start: octoberFirst,
      end: date.lastDayOfYear.endOfDay,
    );
  }

  @override
  // ignore: hash_and_equals, overridden in EquatableMixin
  bool operator ==(Object other) {
    return (super == other) || (other is TrimesterGenerator);
  }

  @override
  List<Object?> get props => [];
}
