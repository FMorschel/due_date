import '../../helpers/limited_or_every_handler.dart';
import '../date_time_limit_reached_exception.dart';
import '../every_date_validator.dart';
import 'date_direction.dart';
import 'every_date_validator_wrapper.dart';
import 'every_wrapper_mixin.dart';

/// {@template everyModifierMixin}
/// Mixin that, when used, passes the calls to the specific method on the
/// underlying [every].
/// {@endtemplate}
mixin EveryDateValidatorWrapperMixin<T extends EveryDateValidator>
    on EveryDateValidatorWrapper<T>
    implements EveryDateValidator, EveryWrapperMixin<T> {
  @override
  DateTime startDate(DateTime date, {DateTime? limit}) {
    return processDate(
      LimitedOrEveryHandler.startDate(every, date, limit: limit),
      DateDirection.start,
      limit: limit,
    );
  }

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
  DateTime endDate(DateTime date, {DateTime? limit}) {
    return processDate(
      LimitedOrEveryHandler.endDate(every, date, limit: limit),
      DateDirection.end,
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
}
