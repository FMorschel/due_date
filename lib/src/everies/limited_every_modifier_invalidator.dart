import '../date_validators/date_validator.dart';
import 'every.dart';
import 'limited_every.dart';
import 'limited_every_date_validator.dart';
import 'modifiers/every_wrapper_invalidator.dart';
import 'modifiers/limited_every_modifier_mixin.dart';

/// {@template limitedEveryModifierInvalidator}
/// Class that wraps a [LimitedEvery] generator and adds an [invalidator]
/// that will be used to invalidate the generated dates.
/// {@endtemplate}
abstract class LimitedEveryModifierInvalidator<T extends Every,
        V extends DateValidator> extends EveryModifierInvalidator<T, V>
    with LimitedEveryModifierMixin<T, V>
    implements LimitedEveryDateValidator {
  /// {@macro limitedEveryModifierInvalidator}
  const LimitedEveryModifierInvalidator({
    required super.every,
    required super.invalidator,
  });
}
