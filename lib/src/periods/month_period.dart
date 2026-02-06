import 'package:time/time.dart';

import '../period_generators/day_generator.dart';
import 'day_period.dart';
import 'day_period_bundle.dart';

/// A class that implements a period type of a month.
class MonthPeriod extends DayPeriodBundle {
  /// A class that implements a period type of a month.
  MonthPeriod({required super.start, required super.end})
      : assert(
          end.difference(start) <=
              const Duration(
                days: 30,
                hours: 23,
                minutes: 59,
                seconds: 59,
                milliseconds: 999,
                microseconds: 999,
              ),
          'The difference between start and end must be 30 days, 23 hours, '
          '59 minutes, 59 seconds, 999 milliseconds and 999 microseconds',
        ) {
    const microsecond = Duration(microseconds: 1);
    if (!start.isAtSameMonthAs(end) ||
        end.add(microsecond).isAtSameMonthAs(start) ||
        (start.timeOfDay != Duration.zero) ||
        (end.timeOfDay != end.endOfDay.timeOfDay) ||
        (start.day != 1) ||
        (end.day != end.lastDayOfMonth.day)) {
      throw ArgumentError.value(
        end,
        'end',
        'End must be at the same month as start and must be the last '
            'microsecond of the month',
      );
    }
  }

  @override
  List<DayPeriod> get days {
    const generator = DayGenerator();
    final days = <DayPeriod>[];
    var last = generator.of(start);
    while (last.start.isBefore(end)) {
      days.add(last);
      last = generator.after(last);
    }
    return days;
  }
}
