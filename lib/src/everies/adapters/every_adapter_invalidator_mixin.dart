import '../../date_validators/date_validator.dart';
import '../every.dart';
import '../every_date_validator.dart';
import 'every_adapter_invalidator.dart';

/// {@template everyModifierInvalidator}
/// Class that wraps an [every] generator and adds an [validator] that will
/// be used to invalidate the generated dates.
/// {@endtemplate}
mixin EveryAdapterInvalidatorMixin<T extends Every, V extends DateValidator>
    implements EveryAdapterInvalidator<T, V> {
  /// Returns `true` if the [date] is valid for the [every] (if it is a
  /// [DateValidator], like an [EveryDateValidator], for example) and not valid
  /// for the [validator].
  @override
  bool valid(DateTime date) {
    if (every is DateValidator) {
      final invalid = (every as DateValidator).invalid(date);
      if (invalid) return false;
    }
    return validator.invalid(date);
  }
}
