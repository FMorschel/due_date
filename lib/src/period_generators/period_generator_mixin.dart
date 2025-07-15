import 'package:meta/meta.dart';

import '../enums/enums.dart';
import '../periods/periods.dart';
import 'day_generator.dart';
import 'fortnight_generator.dart';
import 'hour_generator.dart';
import 'minute_generator.dart';
import 'month_generator.dart';
import 'second_generator.dart';
import 'semester_generator.dart';
import 'trimester_generator.dart';
import 'week_generator.dart';
import 'year_generator.dart';

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
