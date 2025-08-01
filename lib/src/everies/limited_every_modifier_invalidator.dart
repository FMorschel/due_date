import '../date_validators/date_validator.dart';
import 'every.dart';
import 'limited_every.dart';
import 'modifiers/every_modifier_invalidator.dart';
import 'modifiers/limited_every_modifier.dart';
import 'modifiers/limited_every_modifier_mixin.dart';

/// {@template limitedEveryModifierInvalidator}
/// Class that wraps a [LimitedEvery] generator and adds an [invalidator]
/// that will be used to invalidate the generated dates.
/// {@endtemplate}
abstract class LimitedEveryModifierInvalidator<T extends Every,
        V extends DateValidator> extends LimitedEveryModifier<T>
    with LimitedEveryModifierMixin<T>
    implements EveryModifierInvalidator<T, V> {
  /// {@macro limitedEveryModifierInvalidator}
  const LimitedEveryModifierInvalidator({
    required super.every,
    required this.invalidator,
  });

  /// The [DateValidator] that will be used to invalidate the generated dates.
  @override
  final V invalidator;
}
