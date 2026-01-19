import '../../helpers/limited_or_every_handler.dart';
import '../date_direction.dart';
import '../date_time_limit_reached_exception.dart';
import '../every.dart';
import '../limited_every.dart';
import 'limited_every_wrapper.dart';

/// {@macro limitedEveryWrapper}
///
/// Also makes the using class a [LimitedEvery].
///
/// Should **always** be used when the [every] is a [LimitedEvery].
mixin LimitedEveryWrapperMixin<T extends Every>
    implements LimitedEvery, LimitedEveryWrapper<T> {
  @override
  DateTime next(DateTime date, {DateTime? limit}) {
    return processDate(
      LimitedOrEveryHandler.next(every, date, limit: limit),
      DateDirection.next,
      limit: limit,
    );
  }

  @override
  DateTime previous(DateTime date, {DateTime? limit}) {
    return processDate(
      LimitedOrEveryHandler.previous(every, date, limit: limit),
      DateDirection.previous,
      limit: limit,
    );
  }

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

  @override
  DateTime processDate(
    DateTime date,
    DateDirection direction, {
    DateTime? limit,
  });
}
