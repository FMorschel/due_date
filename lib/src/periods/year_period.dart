import 'package:time/time.dart';

import '../period_generators/semester_generator.dart';
import 'semester_period.dart';
import 'semester_period_bundle.dart';

/// A class that implements a period type of a year.
class YearPeriod extends SemesterPeriodBundle {
  /// A class that implements a period type of a year.
  YearPeriod({required super.start, required super.end})
      : assert(
          end.difference(start) <=
              const Duration(
                days: 365,
                hours: 23,
                minutes: 59,
                seconds: 59,
                milliseconds: 999,
                microseconds: 999,
              ),
          'The difference between start and end must be 365 days, 23 hours, '
          '59 minutes, 59 seconds, 999 milliseconds and 999 microseconds',
        ) {
    const microsecond = Duration(microseconds: 1);
    if (!start.isAtSameYearAs(end) ||
        end.add(microsecond).isAtSameYearAs(start) ||
        (start.timeOfDay != Duration.zero) ||
        (end.timeOfDay != end.endOfDay.timeOfDay) ||
        start.isAtSameMonthAs(end) ||
        (start.firstDayOfMonth != start) ||
        (end.lastDayOfMonth.endOfDay != end) ||
        ((end.month - start.month) != 11)) {
      throw ArgumentError.value(
        [start.toIso8601String(), end.toIso8601String()],
        'start, end',
        'End must be at the same year as start and must be the last '
            'microsecond of the year',
      );
    }
  }

  @override
  List<SemesterPeriod> get semesters {
    const generator = SemesterGenerator();
    final trimesters = <SemesterPeriod>[];
    var last = generator.of(start);
    while (last.start.isBefore(end)) {
      trimesters.add(last);
      last = generator.after(last);
    }
    return trimesters;
  }
}
