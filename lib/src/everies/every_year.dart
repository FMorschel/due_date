import 'every.dart';
import 'every_month.dart';
import 'every_week.dart';

/// Processes [DateTime] with custom logic.
///
/// ### WARNING:
/// Only mix in your class this if your are not mixing [EveryWeek] or
/// [EveryMonth] in your class.
///
/// Mixin all three will result in strange behavior. The last one mixed will
/// override the [next] and [previous] methods.
///
/// Try to only implement the two that are not the main focus of your [Every]
/// class.
mixin EveryYear implements Every {
  /// This mixin's implementation of [Every.next] and [Every.previous].
  DateTime addYears(DateTime date, int years);

  /// Returns the next year of the given [date] considering this [EveryYear]
  /// implementation.
  ///
  /// Returns the next instance of the given [date] considering this [Every]
  /// base process.
  @override
  DateTime next(DateTime date) => addYears(date, 1);

  /// Returns the previous year of the given [date] considering this [EveryYear]
  /// implementation.
  ///
  /// Returns the previous instance of the given [date] considering this [Every]
  /// base process.
  @override
  DateTime previous(DateTime date) => addYears(date, -1);
}
