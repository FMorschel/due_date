import 'date_direction.dart';
import 'date_time_limit_reached_exception.dart';
import 'limited_every.dart';

/// Mixin that adds limit checking functionality to [LimitedEvery]
/// implementations.
mixin LimitedEveryMixin on LimitedEvery {
  @override
  void throwIfLimitReached(
    DateTime date,
    DateDirection direction, {
    required DateTime? limit,
  }) {
    if ((limit != null) &&
        (direction.isBackward ? date.isBefore(limit) : date.isAfter(limit))) {
      throw DateTimeLimitReachedException(date: date, limit: limit);
    }
  }
}
