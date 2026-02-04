import '../../date_validators/date_validator_difference.dart';
import '../../helpers/date_reducer.dart';
import '../../helpers/limited_or_every_handler.dart';
import '../date_direction.dart';
import '../every_date_validator.dart';
import '../limited_every_date_validator_list_mixin.dart';
import '../limited_every_mixin.dart';

/// Class that processes [DateTime] so that the [next] always returns the next
/// day where only one of the [EveryDateValidator]s conditions is met.
class EveryDateValidatorDifference<E extends EveryDateValidator>
    extends DateValidatorDifference<E>
    with LimitedEveryDateValidatorListMixin<E>, LimitedEveryMixin {
  /// Class that processes [DateTime] so that the [next] always returns the next
  /// day where only one of the [EveryDateValidator]s conditions is met.
  const EveryDateValidatorDifference(super.base);

  @override
  DateTime next(DateTime date, {DateTime? limit}) {
    if (isEmpty) return date;
    throwIfLimitReached(date, DateDirection.next, limit: limit);
    final nextDates =
        map((every) => LimitedOrEveryHandler.next(every, date, limit: limit));
    final validDates = nextDates.where(valid);
    if (validDates.isNotEmpty) {
      final result = validDates.reduce(DateReducer.reduceFuture);
      throwIfLimitReached(result, DateDirection.next, limit: limit);
      return result;
    }
    return next(nextDates.reduce(DateReducer.reduceFuture), limit: limit);
  }

  @override
  DateTime previous(DateTime date, {DateTime? limit}) {
    if (isEmpty) return date;
    throwIfLimitReached(date, DateDirection.previous, limit: limit);
    final previousDates = map((every) {
      return LimitedOrEveryHandler.previous(every, date, limit: limit);
    });
    final validDates = previousDates.where(valid);
    if (validDates.isNotEmpty) {
      final result = validDates.reduce(DateReducer.reducePast);
      throwIfLimitReached(result, DateDirection.previous, limit: limit);
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
