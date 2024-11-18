import 'every.dart';
import 'every_week.dart';
import 'every_year.dart';

/// Processes [DateTime] with custom logic.
///
/// ### WARNING:
/// Only mix in your class this if your are not mixing [EveryWeek] or
/// [EveryYear] in your class.
///
/// Mixin all three will result in strange behavior. The last one mixed will
/// override the [next] and [previous] methods.
///
/// Try to only implement the two that are not the main focus of your [Every]
/// class.
mixin EveryMonth implements EveryYear {
  /// This mixin's implementation of [Every.next] and [Every.previous].
  DateTime addMonths(DateTime date, int months);

  @override
  DateTime addYears(DateTime date, int years) => addMonths(date, years * 12);

  /// Returns the next month of the given [date] considering this [EveryMonth]
  /// implementation.
  ///
  /// Returns the next instance of the given [date] considering this [Every]
  /// base process.
  @override
  DateTime next(DateTime date) => addMonths(date, 1);

  /// Returns the previous month of the given [date] considering this
  /// [EveryMonth] implementation.
  ///
  /// Returns the previous instance of the given [date] considering this [Every]
  /// base process.
  @override
  DateTime previous(DateTime date) => addMonths(date, -1);
}
