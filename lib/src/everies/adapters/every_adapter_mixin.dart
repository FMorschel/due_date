import '../../date_validators/date_validator.dart';
import '../../helpers/limited_or_every_handler.dart';
import '../date_direction.dart';
import '../every.dart';
import '../limited_every.dart';
import '../wrappers/limited_every_wrapper_mixin.dart';
import 'every_adapter.dart';

/// {@template everyModifierMixin}
/// Mixin that, when used, passes the calls to the specific method on the
/// underlying [every].
/// {@endtemplate}
///
/// If the [every] is a [LimitedEvery], the [LimitedEveryWrapperMixin] should
/// be used instead.
mixin EveryAdapterMixin<T extends Every, V extends DateValidator>
    on EveryAdapter<T, V> {
  @override
  DateTime startDate(DateTime date) {
    return processDate(
      LimitedOrEveryHandler.startDateAdapter(every, this, date, limit: null),
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
      LimitedOrEveryHandler.endDateAdapter(every, this, date, limit: null),
      DateDirection.end,
    );
  }
}
