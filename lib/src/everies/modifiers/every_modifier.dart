import '../../date_validators/date_validator_mixin.dart';
import '../date_direction.dart';
import '../every_date_validator.dart';
import '../wrappers/every_wrapper.dart';

/// {@template everyModifier}
/// Abstract class that, when extended, processes [DateTime] with custom logic.
/// {@endtemplate}
abstract class EveryModifier<T extends EveryDateValidator>
    extends EveryDateValidator
    with DateValidatorMixin
    implements EveryWrapper<T> {
  /// {@macro everyModifier}
  const EveryModifier({required this.every});

  /// The base generator for this [EveryModifier].
  @override
  final T every;

  /// A method that processes [date] with custom logic.
  @override
  DateTime processDate(DateTime date, DateDirection direction);
}
