import '../../helpers/limited_or_every_handler.dart';
import '../every_date_validator.dart';
import 'date_direction.dart';
import 'every_date_validator_wrapper.dart';
import 'limited_every_modifier_mixin.dart';

/// Mixin that, when used, passes the calls to the specific method on the
/// underlying [every].
mixin EveryDateValidatorModifierMixin<T extends EveryDateValidator>
    on LimitedEveryModifierMixin<T, T> implements EveryDateValidatorWrapper<T> {
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
      LimitedOrEveryHandler.next(every, date, limit: limit),
      DateDirection.next,
    );
  }

  @override
  DateTime previous(DateTime date, {DateTime? limit}) {
    return processDate(
      LimitedOrEveryHandler.previous(every, date, limit: limit),
      DateDirection.previous,
    );
  }

  @override
  DateTime endDate(DateTime date, {DateTime? limit}) {
    return processDate(
      LimitedOrEveryHandler.endDate(every, date, limit: limit),
      DateDirection.start,
    );
  }
}
