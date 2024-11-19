import 'package:time/time.dart';

/// Extension methods to get the day of the year of a [DateTime].
extension DayInYear on DateTime {
  /// Returns the number of this [DateTime] in the year.
  /// The first day of the year is 1.
  int get dayInYear => difference(firstDayOfYear).inDays + 1;
}
