import 'package:time/time.dart';

import '../period_generators/minute_generator.dart';
import 'minute_period.dart';
import 'period.dart';

/// A class that implements a period type of an hour.
class HourPeriod extends Period {
  /// A class that implements a period type of an hour.
  HourPeriod({required super.start, required super.end})
      : assert(
          end.difference(start) ==
              const Duration(
                minutes: 59,
                seconds: 59,
                milliseconds: 999,
                microseconds: 999,
              ),
          'The difference between start and end must be 59 minutes, 59 '
          'seconds, 999 milliseconds and 999 microseconds',
        ) {
    const microsecond = Duration(microseconds: 1);
    if (duration != const Duration(hours: 1) ||
        !start.isAtSameHourAs(end) ||
        end.add(microsecond).isAtSameHourAs(start)) {
      throw ArgumentError.value(
        end,
        'end',
        'End must be at the same hour as start and must be the last '
            'microsecond of the hour',
      );
    }
  }

  /// Returns the list of minutes that are contained in this hour.
  List<MinutePeriod> get minutes {
    const generator = MinuteGenerator();
    final minutes = <MinutePeriod>[];
    var last = generator.of(start);
    while (last.start.isBefore(end)) {
      minutes.add(last);
      last = generator.after(last);
    }
    return minutes;
  }
}
