import 'every.dart';
import 'every_month.dart';
import 'every_year.dart';

/// Processes [DateTime] with custom logic.
///
/// ### WARNING:
/// Only mix in your class this if your are not mixing [EveryMonth] or
/// [EveryYear] in your class.
///
/// Mixin all three will result in strange behavior. The last one mixed will
/// override the [next] and [previous] methods.
///
/// Try to only implement the two that are not the main focus of your [Every]
/// class.
mixin EveryWeek implements Every {
  /// This mixin's implementation of [Every.next] and [Every.previous].
  DateTime addWeeks(DateTime date, int weeks);

  /// Returns the next week of the given [date] considering this [EveryWeek]
  /// implementation.
  ///
  /// Returns the next instance of the given [date] considering this [Every]
  /// base process.
  @override
  DateTime next(DateTime date) => addWeeks(date, 1);

  /// Returns the previous week of the given [date] considering this [EveryWeek]
  /// implementation.
  ///
  /// Returns the previous instance of the given [date] considering this [Every]
  /// base process.
  @override
  DateTime previous(DateTime date) => addWeeks(date, -1);
}
