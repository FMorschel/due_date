import '../../date_validator.dart';
import '../../every.dart';
import 'every_modifier.dart';
import 'every_modifier_mixin.dart';

/// {@template everyModifierInvalidator}
/// Class that wraps an [every] generator and adds an [invalidator] that will
/// be used to invalidate the generated dates.
/// {@endtemplate}
abstract class EveryModifierInvalidator<T extends Every>
    extends EveryModifier<T> with EveryModifierMixin<T> {
  /// {@macro everyModifierInvalidator}
  const EveryModifierInvalidator({
    required super.every,
    required this.invalidator,
  });

  /// The [DateValidator] that will be used to invalidate the generated dates.
  final DateValidator invalidator;
}
