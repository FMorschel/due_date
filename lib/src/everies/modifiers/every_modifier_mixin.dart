import '../../helpers/limited_or_every_handler.dart';
import '../date_direction.dart';
import '../every_date_validator.dart';
import '../limited_every.dart';
import '../wrappers/limited_every_wrapper_mixin.dart';
import 'every_modifier.dart';

/// {@template everyModifierMixin}
/// Mixin that, when used, passes the calls to the specific method on the
/// underlying [every].
/// {@endtemplate}
///
/// If the [every] is a [LimitedEvery], the [LimitedEveryWrapperMixin] should
/// be used instead.
mixin EveryModifierMixin<T extends EveryDateValidator> on EveryModifier<T> {
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

  @override
  DateTime endDate(DateTime date) {
    return processDate(
      LimitedOrEveryHandler.endDate(every, date, limit: null),
      DateDirection.end,
    );
  }
}
