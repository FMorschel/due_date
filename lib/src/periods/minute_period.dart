import 'package:time/time.dart';

import '../period_generator.dart';
import 'period.dart';
import 'second_period.dart';

/// A class that implements a period type of a minute.
class MinutePeriod extends Period {
  /// A class that implements a period type of a minute.
  MinutePeriod({required super.start, required super.end})
      : assert(
          end.difference(start) ==
              const Duration(
                seconds: 59,
                milliseconds: 999,
                microseconds: 999,
              ),
          'The difference between start and end must be 59 seconds, 999 '
          'milliseconds and 999 microseconds',
        ) {
    const microsecond = Duration(microseconds: 1);
    if (duration != const Duration(minutes: 1) ||
        !start.isAtSameMinuteAs(end) ||
        end.add(microsecond).isAtSameMinuteAs(start)) {
      throw ArgumentError.value(
        end,
        'end',
        'End must be at the same minute as start and must be the last '
            'microsecond of the minute',
      );
    }
  }

  /// Returns the list of seconds that are contained in this minute.
  List<SecondPeriod> get seconds {
    const generator = SecondGenerator();
    final seconds = <SecondPeriod>[];
    var last = generator.of(start);
    while (last.start.isBefore(end)) {
      seconds.add(last);
      last = generator.after(last);
    }
    return seconds;
  }
}
