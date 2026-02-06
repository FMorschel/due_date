import '../every_date_validator.dart';
import '../limited_every_date_validator.dart';
import '../wrappers/limited_every_wrapper.dart';
import 'every_modifier.dart';

/// {@template everyModifier}
/// Abstract class that, when extended, processes [DateTime] with custom logic.
/// {@endtemplate}
abstract class LimitedEveryModifier<T extends EveryDateValidator>
    extends EveryModifier<T>
    implements LimitedEveryWrapper<T>, LimitedEveryDateValidator {
  /// {@macro everyModifier}
  const LimitedEveryModifier({required super.every});
}
