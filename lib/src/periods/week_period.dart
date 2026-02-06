import 'package:time/time.dart';

import '../enums/weekday.dart';
import '../period_generators/day_generator.dart';
import 'day_period.dart';
import 'day_period_bundle.dart';

/// A class that implements a period type of a week.
class WeekPeriod extends DayPeriodBundle {
  /// A class that implements a period type of a week.
  WeekPeriod({required super.start, required super.end})
      : assert(
          end.difference(start) <=
              const Duration(
                days: 7,
                minutes: 59,
                seconds: 59,
                milliseconds: 999,
                microseconds: 999,
              ),
          'The difference between start and end must be 7 days, 0 hours, '
          '59 minutes, 59 seconds, 999 milliseconds and 999 microseconds',
        ) {
    if ((duration > const Duration(days: 7, hours: 1)) ||
        (duration <
            const Duration(
              days: 6,
              hours: 22,
              minutes: 59,
              seconds: 59,
              milliseconds: 999,
              microseconds: 999,
            )) ||
        (start.timeOfDay != Duration.zero) ||
        (end.timeOfDay != end.endOfDay.timeOfDay) ||
        (end.weekday != Weekday.from(start).previous.dateTimeValue)) {
      throw ArgumentError.value(
        end,
        'end',
        'End must be at the same week as start and must be the last '
            'microsecond of the week',
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
