import 'limited_every.dart';

/// Exception thrown when a date limit is reached.
///
/// Thrown when a [LimitedEvery] method would return a date that is after (or
/// before in [LimitedEvery.previous] case) the [limit] date.
///
/// Should **_not_** be thrown when the resulting [date] is equal to the [limit]
/// date.
class DateTimeLimitReachedException implements Exception {
  /// Exception thrown when a date limit is reached.
  const DateTimeLimitReachedException({
    required this.date,
    required this.limit,
  }) : assert(
          date != limit,
          'Invalid exception. Date cannot be equal to limit.',
        );

  /// Date that reached the limit.
  final DateTime date;

  /// Limit date.
  final DateTime limit;

  @override
  String toString() {
    return 'DateTimeLimitException: $date has passed $limit';
  }
}
