import 'package:time/time.dart';

import '../period_generators/trimester_generator.dart';
import 'trimester_period.dart';
import 'trimester_period_bundle.dart';

/// A class that implements a period type of a semester.
class SemesterPeriod extends TrimesterPeriodBundle {
  /// A class that implements a period type of a semester.
  SemesterPeriod({required super.start, required super.end})
      : assert(
          end.difference(start) <=
              const Duration(
                days: 183,
                hours: 23,
                minutes: 59,
                seconds: 59,
                milliseconds: 999,
                microseconds: 999,
              ),
          'The difference between start and end must be 183 days, 23 hours, '
          '59 minutes, 59 seconds, 999 milliseconds and 999 microseconds',
        ) {
    if ((start.timeOfDay != Duration.zero) ||
        (end.timeOfDay != end.endOfDay.timeOfDay) ||
        start.isAtSameMonthAs(end) ||
        (start.firstDayOfMonth != start) ||
        (end.lastDayOfMonth.endOfDay != end) ||
        ((end.month - start.month) != 5)) {
      throw ArgumentError.value(
        end,
        'end',
        'End must be at the same semester as start and must be the last '
            'microsecond of the semester',
      );
    }
  }

  @override
  List<TrimesterPeriod> get trimesters {
    const generator = TrimesterGenerator();
    final trimesters = <TrimesterPeriod>[];
    var last = generator.of(start);
    while (last.start.isBefore(end)) {
      trimesters.add(last);
      last = generator.after(last);
    }
    return trimesters;
  }
}
