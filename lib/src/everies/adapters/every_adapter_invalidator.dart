import '../../date_validators/date_validator.dart';
import '../../date_validators/date_validator_mixin.dart';
import '../every.dart';
import '../every_date_validator.dart';
import 'every_adapter.dart';
import 'every_adapter_mixin.dart';

/// {@template everyModifierInvalidator}
/// Class that wraps an [every] generator and adds an [validator] that will
/// be used to invalidate the generated dates.
/// {@endtemplate}
abstract class EveryAdapterInvalidator<T extends Every, V extends DateValidator>
    extends EveryAdapter<T, V>
    with EveryAdapterMixin<T, V>, DateValidatorMixin
    implements EveryDateValidator {
  /// {@macro everyModifierInvalidator}
  const EveryAdapterInvalidator({
    required super.every,
    required super.validator,
  });
}
