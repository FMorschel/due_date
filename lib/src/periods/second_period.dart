import 'package:time/time.dart';

import 'period.dart';

/// A class that implements a period type of a second.
class SecondPeriod extends Period {
  /// A class that implements a period type of a second.
  SecondPeriod({required super.start, required super.end})
      : assert(
          end.difference(start).abs() ==
              const Duration(
                milliseconds: 999,
                microseconds: 999,
              ),
          'The difference between start and end must be 999 milliseconds and '
          '999 microseconds',
        ) {
    const microsecond = Duration(microseconds: 1);
    if ((duration != const Duration(seconds: 1)) ||
        !start.isAtSameSecondAs(end) ||
        end.add(microsecond).isAtSameSecondAs(start)) {
      throw ArgumentError.value(
        end,
        'end',
        'End must be at the same second as start and must be the last '
            'microsecond of the second',
      );
    }
  }
}
