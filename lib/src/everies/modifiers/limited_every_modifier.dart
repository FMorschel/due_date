import '../../date_validators/date_validator.dart';
import '../every.dart';
import '../limited_every_date_validator.dart';
import 'every_modifier.dart';
import 'limited_every_wrapper.dart';

/// {@template everyModifier}
/// Abstract class that, when extended, processes [DateTime] with custom logic.
/// {@endtemplate}
abstract class LimitedEveryModifier<T extends Every, V extends DateValidator>
    extends EveryModifier<T, V>
    implements LimitedEveryWrapper<T>, LimitedEveryDateValidator {
  /// {@macro everyModifier}
  const LimitedEveryModifier({required super.every});
}
