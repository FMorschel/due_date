import '../../date_validators/date_validator.dart';
import '../../date_validators/date_validator_mixin.dart';
import '../date_direction.dart';
import '../every.dart';
import '../every_date_validator.dart';
import '../wrappers/every_wrapper.dart';

/// {@template everyAdapter}
/// Abstract class that, when extended, processes [DateTime] with custom logic.
/// {@endtemplate}
abstract class EveryAdapter<T extends Every, V extends DateValidator>
    extends EveryDateValidator
    with DateValidatorMixin
    implements EveryWrapper<T> {
  /// {@macro everyAdapter}
  const EveryAdapter({required this.every, required this.validator});

  /// The base generator for this [EveryAdapter].
  @override
  final T every;

  /// The validator used by this [EveryAdapter].
  final V validator;

  /// A method that processes [date] with custom logic.
  @override
  DateTime processDate(DateTime date, DateDirection direction);
}
