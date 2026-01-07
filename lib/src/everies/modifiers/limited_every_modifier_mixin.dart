import '../../date_validators/date_validator.dart';
import '../../date_validators/date_validator_mixin.dart';
import '../../helpers/limited_or_every_handler.dart';
import '../every.dart';
import '../limited_every.dart';
import 'date_direction.dart';
import 'limited_every_modifier.dart';

/// {@macro everyModifierMixin}
///
/// Also makes the using class a [LimitedEvery].
///
/// Should **always** be used when the [every] is a [LimitedEvery].
mixin LimitedEveryModifierMixin<T extends Every, V extends DateValidator>
    on DateValidatorMixin implements LimitedEveryModifier<T, V> {
  @override
  DateTime startDate(DateTime date, {DateTime? limit}) {
    return processDate(
      LimitedOrEveryHandler.startDate2(every, this, date, limit: limit),
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
      LimitedOrEveryHandler.endDate2(every, this, date, limit: limit),
      DateDirection.end,
      limit: limit,
    );
  }

  @override
  DateTime processDate(
    DateTime date,
    DateDirection direction, {
    DateTime? limit,
  });
}
