import '../../date_validators/date_validator.dart';
import '../../helpers/limited_or_every_handler.dart';
import '../every.dart';
import '../limited_every.dart';
import 'date_direction.dart';
import 'every_modifier.dart';
import 'limited_every_wrapper_mixin.dart';

/// {@template everyModifierMixin}
/// Mixin that, when used, passes the calls to the specific method on the
/// underlying [every].
/// {@endtemplate}
///
/// If the [every] is a [LimitedEvery], the [LimitedEveryWrapperMixin] should
/// be used instead.
mixin EveryModifierMixin<T extends Every, V extends DateValidator>
    on EveryModifier<T, V> {
  @override
  DateTime startDate(DateTime date) {
    return processDate(
      LimitedOrEveryHandler.startDate2(every, this, date, limit: null),
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
      LimitedOrEveryHandler.endDate2(every, this, date, limit: null),
      DateDirection.end,
    );
  }
}
