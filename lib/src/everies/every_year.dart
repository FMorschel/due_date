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
}
