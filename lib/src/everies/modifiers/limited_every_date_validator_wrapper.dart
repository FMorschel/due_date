import '../every.dart';
import '../limited_every_date_validator.dart';
import 'every_wrapper.dart';

/// {@template limitedEveryModifier}
/// Abstract class that, when extended, wraps an [Every] generator.
/// {@endtemplate}
abstract class LimitedEveryDateValidatorWrapper<T extends Every>
    extends EveryWrapper<T> implements LimitedEveryDateValidator {
  /// {@macro limitedEveryModifier}
  const LimitedEveryDateValidatorWrapper({required super.every});
}
