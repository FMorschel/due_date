import '../../helpers/helpers.dart';
import '../every.dart';
import '../limited_every.dart';
import 'modifiers.dart';

/// {@template everyModifierMixin}
/// Mixin that, when used, passes the calls to the specific method on the
/// underlying [every].
/// {@endtemplate}
///
/// If the [every] is a [LimitedEvery], the [LimitedEveryModifierMixin] should
/// be used instead.
mixin EveryModifierMixin<T extends Every> on EveryModifier<T> {
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
