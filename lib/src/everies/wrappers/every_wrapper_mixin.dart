import '../../helpers/limited_or_every_handler.dart';
import '../date_direction.dart';
import '../every.dart';
import '../limited_every.dart';
import 'every_wrapper.dart';
import 'limited_every_wrapper_mixin.dart';

/// {@template everyModifierMixin}
/// Mixin that, when used, passes the calls to the specific method on the
/// underlying [every].
/// {@endtemplate}
///
/// If the [every] is a [LimitedEvery], the [LimitedEveryWrapperMixin] should
/// be used instead.
mixin EveryWrapperMixin<T extends Every> implements EveryWrapper<T> {
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
