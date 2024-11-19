/// Extension on [DateTime] to get the exact time of the day.
extension ExactTimeOfDay on DateTime {
  /// Returns the exact time of the day.
  Duration get exactTimeOfDay => Duration(
        hours: hour,
        minutes: minute,
        seconds: second,
        milliseconds: millisecond,
        microseconds: microsecond,
      );
}
