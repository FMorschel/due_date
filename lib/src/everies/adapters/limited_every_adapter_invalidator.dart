import '../../date_validators/date_validator.dart';
import '../every.dart';
import '../limited_every.dart';
import '../limited_every_date_validator.dart';
import 'every_adapter_invalidator.dart';
import 'limited_every_adapter_mixin.dart';

/// {@template limitedEveryModifierInvalidator}
/// Class that wraps a [LimitedEvery] generator and adds an [validator]
/// that will be used to invalidate the generated dates.
/// {@endtemplate}
abstract class LimitedEveryAdapterInvalidator<T extends Every,
        V extends DateValidator> extends EveryAdapterInvalidator<T, V>
    with LimitedEveryAdapterMixin<T, V>
    implements LimitedEveryDateValidator {
  /// {@macro limitedEveryModifierInvalidator}
  const LimitedEveryAdapterInvalidator({
    required super.every,
    required super.validator,
  });
}
