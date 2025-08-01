import '../every.dart';
import 'date_direction.dart';

/// {@template everyModifier}
/// Abstract class that, when extended, processes [DateTime] with custom logic.
/// {@endtemplate}
abstract class EveryModifier<T extends Every> extends Every {
  /// {@macro everyModifier}
  const EveryModifier({required this.every});

  /// The base generator for this [EveryModifier].
  final T every;

  /// A method that processes [date] with custom logic.
  DateTime processDate(DateTime date, DateDirection direction);
}
