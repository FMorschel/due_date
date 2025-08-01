import 'date_validator.dart';
import 'date_validator_mixin.dart';

/// {@template dateValidatorOpposite}
/// A class that represents the opposite of a [DateValidator].
///
/// This simply inverts the logic of the original validator.
/// {@endtemplate}
class DateValidatorOpposite<T extends DateValidator> extends DateValidator
    with DateValidatorMixin {
  /// {@macro dateValidatorOpposite}
  const DateValidatorOpposite(this._validator);

  final T _validator;

  /// The original validator.
  @override
  T operator -() => _validator;

  @override
  bool valid(DateTime date) => _validator.invalid(date);
}
