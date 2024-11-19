import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:time/time.dart';

import '../enums/enums.dart';
import '../periods/periods.dart';
import 'day_generator.dart';
import 'fortnight_generator.dart';
import 'hour_generator.dart';
import 'minute_generator.dart';
import 'month_generator.dart';
import 'second_generator.dart';
import 'trimester_generator.dart';
import 'week_generator.dart';

/// A mixin for generating period types.
///
/// If you are looking for implementations, see [PeriodGenerator] and its
/// values:
/// [SecondGenerator], [MinuteGenerator], [HourGenerator], [DayGenerator],
/// [WeekGenerator], [FortnightGenerator], [MonthGenerator],
/// [TrimesterGenerator], [SemesterGenerator] and [YearGenerator].
@immutable
mixin PeriodGeneratorMixin<T extends Period> {
  /// Returns the period of the given [date] considering the generator type.
  T of(DateTime date);

  /// Returns the period after the given [period] by the rule:
  /// The [Period.end] is given to this [of]. The given [duration] is added to
  /// the end of the resulting period and this is given to [of].
  T after(
    Period period, {
    Duration duration = const Duration(microseconds: 1),
  }) =>
      of(of(period.end).end.add(duration));

  /// Returns the period before the given [period] by the rule:
  /// The [Period.start] is given to this [of]. The given [duration] is
  /// subtracted from the start of the resulting period and this is given to
  /// [of].
  T before(
    Period period, {
    Duration duration = const Duration(microseconds: 1),
  }) =>
      of(of(period.start).start.subtract(duration));

  /// Returns true if the given [period] fits the generator.
  bool fitsGenerator(Period period) {
    final newPeriod = of(period.start);
    return newPeriod == period;
  }
}

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
    return (super == other) || (other is SemesterGenerator);
  }

  @override
  List<Object?> get props => [];
}

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
    return (super == other) || (other is YearGenerator);
  }

  @override
  List<Object?> get props => [];
}
