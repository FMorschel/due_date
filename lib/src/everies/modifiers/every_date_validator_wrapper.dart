import '../every_date_validator.dart';
import 'date_direction.dart';
import 'limited_every_modifier.dart';

/// {@template everyModifier}
/// Abstract class that, when extended, processes [DateTime] with custom logic.
/// {@endtemplate}
abstract class EveryDateValidatorWrapper<T extends EveryDateValidator>
    extends EveryDateValidator implements LimitedEveryModifier<T, T> {
  /// {@macro everyModifier}
  const EveryDateValidatorWrapper({required this.every});

  /// The base generator for this [EveryDateValidatorWrapper].
  @override
  final T every;

  /// A method that processes [date] with custom logic.
  @override
  DateTime processDate(DateTime date, DateDirection direction);
}
