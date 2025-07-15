import 'package:time/time.dart';

import '../extensions/extensions.dart';
import '../period_generators/month_generator.dart';
import '../period_generators/period_generators.dart';
import 'month_period.dart';
import 'month_period_bundle.dart';

/// A class that implements a period type of a trimester.
class TrimesterPeriod extends MonthPeriodBundle {
  /// A class that implements a period type of a trimester.
  TrimesterPeriod({required super.start, required super.end})
      : assert(
          end.difference(start) <=
              const Duration(
                days: 91,
                hours: 23,
                minutes: 59,
                seconds: 59,
                milliseconds: 999,
                microseconds: 999,
              ),
          'The difference between start and end must be 91 days, 23 hours, '
          '59 minutes, 59 seconds, 999 milliseconds and 999 microseconds',
        ) {
    if ((start.exactTimeOfDay != Duration.zero) ||
        (end.exactTimeOfDay != end.endOfDay.exactTimeOfDay) ||
        start.isAtSameMonthAs(end) ||
        (start.firstDayOfMonth != start) ||
        (end.lastDayOfMonth.endOfDay != end) ||
        ((end.month - start.month) != 2)) {
      throw ArgumentError.value(
        end,
        'end',
        'End must be at the same trimester as start and must be the last '
            'microsecond of the trimester',
      );
    }
  }

  @override
  List<MonthPeriod> get months {
    const generator = MonthGenerator();
    final months = <MonthPeriod>[];
    var last = generator.of(start);
    while (last.start.isBefore(end)) {
      months.add(last);
      last = generator.after(last);
    }
    return months;
  }
}
