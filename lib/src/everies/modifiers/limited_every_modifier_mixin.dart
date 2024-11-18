import '../../helpers/helpers.dart';
import '../every.dart';
import '../limited_every.dart';
import 'date_direction.dart';
import 'every_modifier.dart';

/// {@macro everyModifierMixin}
///
/// Also makes the using class a [LimitedEvery].
///
/// Should **always** be used when the [every] is a [LimitedEvery].
mixin LimitedEveryModifierMixin<T extends Every> on EveryModifier<T>
    implements LimitedEvery {
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
  DateTime processDate(
    DateTime date,
    DateDirection direction, {
    DateTime? limit,
  });
}
