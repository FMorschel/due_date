import '../../helpers/limited_or_every_handler.dart';
import '../every_date_validator.dart';
import '../limited_every_date_validator.dart';
import 'date_direction.dart';
import 'every_date_validator_modifier.dart';
import 'every_modifier_mixin.dart';
import 'limited_every_date_validator_modifier_mixin.dart';

/// {@template everyModifierMixin}
/// Mixin that, when used, passes the calls to the specific method on the
/// underlying [every].
///
/// If the [every] is a [LimitedEveryDateValidator], the
/// [LimitedEveryDateValidatorModifierMixin] should be used instead.
/// {@endtemplate}
mixin EveryDateValidatorModifierMixin<T extends EveryDateValidator>
    on EveryDateValidatorModifier<T>
    implements EveryDateValidator, EveryModifierMixin<T> {
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
