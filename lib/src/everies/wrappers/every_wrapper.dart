import '../date_direction.dart';
import '../every.dart';

/// {@template everyWrapper}
/// Abstract class that, when extended, processes [DateTime] with custom logic.
/// {@endtemplate}
abstract class EveryWrapper<T extends Every> extends Every {
  /// {@macro everyWrapper}
  const EveryWrapper({required this.every});

  /// The base generator for this [EveryWrapper].
  final T every;

  /// A method that processes [date] with custom logic.
  DateTime processDate(DateTime date, DateDirection direction);
}
