import '../date_validators/date_validators.dart';
import '../helpers/helpers.dart';
import 'every.dart';
import 'every_date_validator.dart';
import 'every_date_validator_list_mixin.dart';
import 'limited_every.dart';

/// Class that processes [DateTime] so that the [next] always returns the next
/// day where any of the [EveryDateValidator]s conditions are met.
class EveryDateValidatorUnion<E extends EveryDateValidator>
    extends DateValidatorUnion<E>
    with EveryDateValidatorListMixin<E>
    implements EveryDateValidator, LimitedEvery {
  /// Class that processes [DateTime] so that the [next] always returns the next
  /// day where any of the [EveryDateValidator]s conditions are met.
  const EveryDateValidatorUnion(super.everyDateValidators);

  /// Returns the next [DateTime] that matches the [Every] pattern.
  ///
  /// For every one one of the [everies] that is a [LimitedEvery], the [limit]
  /// will be passed.
  /// If none of the [everies] is a [LimitedEvery], the [limit] will be ignored.
  @override
  DateTime startDate(DateTime date, {DateTime? limit}) {
    if (isEmpty) return date;
    final startingDates = map(
      (every) => LimitedOrEveryHandler.startDate(every, date, limit: limit),
    );
    return startingDates.reduce(DateReducer.reduceFuture);
  }

  /// Returns the next instance of the given [date] considering this [Every]
  /// base process.
  ///
  /// For every one one of the [everies] that is a [LimitedEvery], the [limit]
  /// will be passed.
  /// If none of the [everies] is a [LimitedEvery], the [limit] will be ignored.
  @override
  DateTime next(DateTime date, {DateTime? limit}) {
    if (isEmpty) return date;
    final nextDates =
        map((every) => LimitedOrEveryHandler.next(every, date, limit: limit));
    return nextDates.reduce(DateReducer.reduceFuture);
  }

  /// Returns the previous instance of the given [date] considering this [Every]
  /// base process.
  ///
  /// For every one one of the [everies] that is a [LimitedEvery], the [limit]
  /// will be passed.
  /// If none of the [everies] is a [LimitedEvery], the [limit] will be ignored.
  @override
  DateTime previous(DateTime date, {DateTime? limit}) {
    if (isEmpty) return date;
    final previousDates = map(
      (every) => LimitedOrEveryHandler.previous(every, date, limit: limit),
    );
    return previousDates.reduce(DateReducer.reducePast);
  }

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is EveryDateValidatorUnion) &&
            (other.validators == validators));
  }
}
