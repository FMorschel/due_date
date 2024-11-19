import '../../helpers/helpers.dart';
import '../every.dart';
import '../limited_every.dart';
import 'modifiers.dart';

/// {@template everyModifierMixin}
/// Mixin that, when used, passes the calls the specific method on the
/// underlying [every].
///
/// If the [every] is a [LimitedEvery], the [LimitedEveryModifierMixin] should
/// be used instead.
/// {@endtemplate}
mixin EveryModifierMixin<T extends Every> on EveryModifier<T> {
  @override
  DateTime startDate(DateTime date) {
    return processDate(
      LimitedOrEveryHandler.startDate(every, date, limit: null),
      DateDirection.start,
    );
  }

  @override
  DateTime next(DateTime date) {
    return processDate(
      LimitedOrEveryHandler.next(every, date, limit: null),
      DateDirection.next,
    );
  }

  @override
  DateTime previous(DateTime date) {
    return processDate(
      LimitedOrEveryHandler.previous(every, date, limit: null),
      DateDirection.previous,
    );
  }
}
