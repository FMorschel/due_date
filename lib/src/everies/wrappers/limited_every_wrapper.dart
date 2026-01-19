import '../date_direction.dart';
import '../every.dart';
import '../limited_every.dart';
import 'every_wrapper.dart';

/// {@template limitedEveryWrapper}
/// Abstract class that, when extended, wraps an [Every] generator.
/// {@endtemplate}
abstract class LimitedEveryWrapper<T extends Every> extends EveryWrapper<T>
    implements LimitedEvery {
  /// {@macro limitedEveryWrapper}
  const LimitedEveryWrapper({required super.every});

  /// A method that processes [date] with custom logic.
  @override
  DateTime processDate(
    DateTime date,
    DateDirection direction, {
    DateTime? limit,
  });
}
