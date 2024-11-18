import 'package:time/time.dart';

import 'add_days.dart';

/// Extension methods to calculate the end of a day for DateTime.
extension EndOfDay on DateTime {
  /// Returns a new [DateTime] with the same day, month and year, with the time
  /// set to the end of the day.
  DateTime get endOfDay {
    final nextDay = date.addDays(1);
    return nextDay.subtract(const Duration(microseconds: 1));
  }
}
