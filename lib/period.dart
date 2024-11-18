/// Support for creating your own custom periods.
///
/// This package is used to create custom periods.
///
/// Implementing your own [Period] or [PeriodGenerator] is easy.
///
/// There are already some [Period] classes implemented in this package. Look
/// for [SecondPeriod], [MinutePeriod], [HourPeriod], [DayPeriod], [WeekPeriod],
/// [FortnightPeriod], [MonthPeriod], [TrimesterPeriod], [SemesterPeriod] and
/// [YearPeriod].
///
/// There are already some [PeriodGenerator] classes implemented in this
/// package. Look for [SecondGenerator], [MinuteGenerator],
/// [HourGenerator], [DayGenerator], [WeekGenerator],
/// [FortnightGenerator], [MonthGenerator], [TrimesterGenerator],
/// [SemesterGenerator] and [YearGenerator].
library period;

import 'src/enums/enums.dart' show PeriodGenerator;
import 'src/period.dart';
import 'src/period_generator.dart';

export 'src/enums/enums.dart' show Month, PeriodGenerator, Week, Weekday;
export 'src/everies/everies.dart';
export 'src/extensions/extensions.dart' show EndOfDay;
export 'src/period.dart';
export 'src/period_generator.dart';
