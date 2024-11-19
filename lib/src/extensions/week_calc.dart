import '../enums/enums.dart';
import 'add_days.dart';

/// Extension methods related to weeks on a [DateTime].
extension WeekCalc on DateTime {
  /// Returns the next [weekday] after this.
  ///
  /// If this [DateTime.weekday] is [weekday] returns this.
  DateTime nextWeekday(Weekday weekday) {
    if (this.weekday == weekday.dateTimeValue) {
      return this;
    } else {
      return addDays(1).nextWeekday(weekday);
    }
  }

  /// Returns the previous [weekday] before this.
  ///
  /// If this [DateTime.weekday] is [weekday] returns this.
  DateTime previousWeekday(Weekday weekday) {
    if (this.weekday == weekday.dateTimeValue) {
      return this;
    } else {
      return subtractDays(1).previousWeekday(weekday);
    }
  }
}
