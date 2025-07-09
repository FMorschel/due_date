import 'package:time/time.dart';
import '../extensions/extensions.dart';
import '../period_generators/period_generators.dart';
import 'day_period.dart';
import 'day_period_bundle.dart';

/// A class that implements a period type of a fortnight.
class FortnightPeriod extends DayPeriodBundle {
  /// A class that implements a period type of a fortnight.
  FortnightPeriod({required super.start, required super.end})
      : assert(
          end.difference(start) <=
              const Duration(
                days: 16,
                hours: 23,
                minutes: 59,
                seconds: 59,
                milliseconds: 999,
                microseconds: 999,
              ),
          'The difference between start and end must be 16 days, 23 hours, '
          '59 minutes, 59 seconds, 999 milliseconds and 999 microseconds',
        ) {
    if ((duration > const Duration(days: 16, hours: 1)) ||
        (duration <
            const Duration(
              days: 12,
              hours: 22,
              minutes: 59,
              seconds: 59,
              milliseconds: 999,
              microseconds: 999,
            )) ||
        (start.exactTimeOfDay != Duration.zero) ||
        (end.exactTimeOfDay != end.endOfDay.exactTimeOfDay) ||
        !start.isAtSameMonthAs(end) ||
        ((start.firstDayOfMonth != start) &&
            (start != start.copyWith(day: 16))) ||
        ((end.lastDayOfMonth.endOfDay != end) &&
            (end != end.copyWith(day: 15).endOfDay))) {
      throw ArgumentError.value(
        end,
        'end',
        'End must be at the same fortnight as start and must be the last '
            'microsecond of the fortnight',
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
