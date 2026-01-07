import '../../date_validators/date_validator_mixin.dart';
import '../every_date_validator.dart';
import 'every_wrapper.dart';

/// {@template everyDateValidatorModifier}
/// Abstract class that, when extended, processes [DateTime] with custom logic.
/// {@endtemplate}
abstract class EveryDateValidatorModifier<T extends EveryDateValidator>
    extends EveryWrapper<T> with DateValidatorMixin {
  /// {@macro everyDateValidatorModifier}
  const EveryDateValidatorModifier({required super.every});
}
