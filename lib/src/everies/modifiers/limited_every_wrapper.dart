import '../every.dart';
import '../limited_every.dart';
import 'every_wrapper.dart';

/// {@template limitedEveryModifier}
/// Abstract class that, when extended, wraps an [Every] generator.
/// {@endtemplate}
abstract class LimitedEveryWrapper<T extends Every> extends EveryWrapper<T>
    implements LimitedEvery {
  /// {@macro limitedEveryModifier}
  const LimitedEveryWrapper({required super.every});
}
