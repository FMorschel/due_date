import 'package:time/time.dart';

import '../period_generators/period_generators.dart';
import 'hour_period.dart';
import 'period.dart';

/// A class that implements a period type of a day.
class DayPeriod extends Period {
  /// A class that implements a period type of a day.
  DayPeriod({required super.start, required super.end})
      : assert(
          end.difference(start) < const Duration(days: 1, hours: 1),
          'The difference between start and end must be 24 hours (daylight '
          'savings), 59 minutes, 59 seconds, 999 milliseconds and 999 '
          'microseconds',
        ) {
    const microsecond = Duration(microseconds: 1);
    if (!start.isAtSameDayAs(end) ||
        end.add(microsecond).isAtSameDayAs(start)) {
      throw ArgumentError.value(
        end,
        'end',
        'End must be at the same day as start and must be the last microsecond '
            'of the day',
      );
    }
  }

  /// Returns the list of hours in this day.
  List<HourPeriod> get hours {
    const generator = HourGenerator();
    final hours = <HourPeriod>[];
    var last = generator.of(start);
    while (last.start.isBefore(end)) {
      hours.add(last);
      last = generator.after(last);
    }
    return hours;
  }
}
