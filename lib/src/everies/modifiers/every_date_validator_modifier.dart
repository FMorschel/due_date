import '../../date_validators/date_validators.dart';
import '../every_date_validator.dart';
import 'every_modifier.dart';

/// {@template everyDateValidatorModifier}
/// Abstract class that, when extended, processes [DateTime] with custom logic.
/// {@endtemplate}
abstract class EveryDateValidatorModifier<T extends EveryDateValidator>
    extends EveryModifier<T> implements DateValidatorMixin {
  /// {@macro everyDateValidatorModifier}
  const EveryDateValidatorModifier({required super.every});
}
