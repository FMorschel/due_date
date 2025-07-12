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
import 'src/period_generators/period_generators.dart';
import 'src/period_generators/semester_generator.dart';
import 'src/period_generators/year_generator.dart';
import 'src/periods/periods.dart';

export 'src/enums/enums.dart' show Month, PeriodGenerator, Week, Weekday;
export 'src/everies/everies.dart';
export 'src/extensions/extensions.dart' show ExactTimeOfDay;
export 'src/period_generators/period_generators.dart';
export 'src/periods/periods.dart';
