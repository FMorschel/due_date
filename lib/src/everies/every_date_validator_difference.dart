import '../date_validators/date_validators.dart';
import '../helpers/helpers.dart';
import 'date_time_limit_reached_exception.dart';
import 'every_date_validator.dart';
import 'every_date_validator_list_mixin.dart';
import 'limited_every.dart';

/// Class that processes [DateTime] so that the [next] always returns the next
/// day where only one of the [EveryDateValidator]s conditions is met.
class EveryDateValidatorDifference<E extends EveryDateValidator>
    extends DateValidatorDifference<E>
    with EveryDateValidatorListMixin<E>
    implements EveryDateValidator, LimitedEvery {
  /// Class that processes [DateTime] so that the [next] always returns the next
  /// day where only one of the [EveryDateValidator]s conditions is met.
  const EveryDateValidatorDifference(super.everyDateValidators);

  @override
  DateTime startDate(DateTime date, {DateTime? limit}) {
    if (isEmpty) return date;
    if ((limit != null) && (date.isAfter(limit) || (date == limit))) {
      throw DateTimeLimitReachedException(date: date, limit: limit);
    }
    final startingDates = map(
      (every) => LimitedOrEveryHandler.startDate(every, date, limit: limit),
    );
    final validDates = startingDates.where(valid);
    if (validDates.isNotEmpty) {
      final result = validDates.reduce(DateReducer.reduceFuture);
      if ((limit != null) && (result.isAfter(limit) || (date == limit))) {
        throw DateTimeLimitReachedException(date: result, limit: limit);
      }
      return result;
    }
    return next(date, limit: limit);
  }

  @override
  DateTime next(DateTime date, {DateTime? limit}) {
    if (isEmpty) return date;
    if ((limit != null) && (date.isAfter(limit) || (date == limit))) {
      throw DateTimeLimitReachedException(date: date, limit: limit);
    }
    final nextDates =
        map((every) => LimitedOrEveryHandler.next(every, date, limit: limit));
    final validDates = nextDates.where(valid);
    if (validDates.isNotEmpty) {
      final result = validDates.reduce(DateReducer.reduceFuture);
      if ((limit != null) && (result.isAfter(limit) || (date == limit))) {
        throw DateTimeLimitReachedException(date: result, limit: limit);
      }
      return result;
    }
    return next(nextDates.reduce(DateReducer.reduceFuture), limit: limit);
  }

  @override
  DateTime previous(DateTime date, {DateTime? limit}) {
    if (isEmpty) return date;
    if ((limit != null) && (date.isBefore(limit) || (date == limit))) {
      throw DateTimeLimitReachedException(date: date, limit: limit);
    }
    final previousDates = map(
      (every) => LimitedOrEveryHandler.previous(every, date, limit: limit),
    );
    final validDates = previousDates.where(valid);
    if (validDates.isNotEmpty) {
      final result = validDates.reduce(DateReducer.reducePast);
      if ((limit != null) && (result.isBefore(limit) || (date == limit))) {
        throw DateTimeLimitReachedException(date: result, limit: limit);
      }
      return result;
    }
    return previous(previousDates.reduce(DateReducer.reducePast), limit: limit);
  }

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is EveryDateValidatorDifference) &&
            (other.validators == validators));
  }
}
