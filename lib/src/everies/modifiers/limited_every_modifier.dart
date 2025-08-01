import '../every.dart';
import '../limited_every.dart';
import 'every_modifier.dart';

/// {@template limitedEveryModifier}
/// Abstract class that, when extended, processes [DateTime] with custom logic
/// that can be applied to a [LimitedEvery].
/// {@endtemplate}
abstract class LimitedEveryModifier<T extends Every> extends EveryModifier<T>
    implements LimitedEvery {
  /// {@macro limitedEveryModifier}
  const LimitedEveryModifier({required super.every});
}
