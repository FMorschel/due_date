import '../enums/weekday.dart';

/// Extension methods related to adding or subtracting one from an [Iterable] of
/// [Weekday].
extension PreviousNext on Iterable<Weekday> {
  /// Returns the previous [Weekday]s in the [Iterable].
  Set<Weekday> get previousWeekdays {
    final set = <Weekday>{};
    for (final weekday in this) {
      set.add(weekday.previous);
    }
    return set;
  }

  /// Returns the next [Weekday]s in the [Iterable].
  Set<Weekday> get nextWeekdays {
    final set = <Weekday>{};
    for (final weekday in this) {
      set.add(weekday.next);
    }
    return set;
  }
}
