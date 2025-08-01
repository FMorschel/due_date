import '../../helpers/limited_or_every_handler.dart';
import '../limited_every.dart';
import '../limited_every_date_validator.dart';
import 'date_direction.dart';
import 'every_date_validator_modifier.dart';
import 'every_modifier_mixin.dart';

/// {@macro everyModifierMixin}
///
/// Also makes the using class a [LimitedEvery].
///
/// Should **always** be used when the [every] is a [LimitedEvery].
mixin LimitedEveryDateValidatorModifierMixin<
        T extends LimitedEveryDateValidator> on EveryDateValidatorModifier<T>
    implements LimitedEveryDateValidator, EveryModifierMixin<T> {
  @override
  DateTime startDate(DateTime date, {DateTime? limit}) {
    return processDate(
      LimitedOrEveryHandler.startDate(every, date, limit: limit),
      DateDirection.start,
    );
  }

  @override
  DateTime next(DateTime date, {DateTime? limit}) {
    return processDate(
      LimitedOrEveryHandler.next(every, date, limit: null),
      DateDirection.next,
    );
  }

  @override
  DateTime previous(DateTime date, {DateTime? limit}) {
    return processDate(
      LimitedOrEveryHandler.previous(every, date, limit: null),
      DateDirection.previous,
    );
  }

  @override
  DateTime endDate(DateTime date, {DateTime? limit}) {
    return processDate(
      LimitedOrEveryHandler.endDate(every, date, limit: limit),
      DateDirection.end,
    );
  }
}
