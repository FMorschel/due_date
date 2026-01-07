import '../../date_validators/date_validator.dart';
import '../every.dart';
import '../every_date_validator.dart';
import 'every_wrapper_invalidator.dart';

/// {@template everyModifierInvalidator}
/// Class that wraps an [every] generator and adds an [invalidator] that will
/// be used to invalidate the generated dates.
/// {@endtemplate}
mixin EveryModifierInvalidatorMixin<T extends Every, V extends DateValidator>
    implements EveryModifierInvalidator<T, V> {
  /// Returns `true` if the [date] is valid for the [every] (if it is a
  /// [DateValidator], like an [EveryDateValidator], for example) and not valid
  /// for the [invalidator].
  @override
  bool valid(DateTime date) {
    if (every is DateValidator) {
      final invalid = (every as DateValidator).invalid(date);
      if (invalid) return false;
    }
    return invalidator.invalid(date);
  }
}
