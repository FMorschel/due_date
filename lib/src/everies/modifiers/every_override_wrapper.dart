import 'package:equatable/equatable.dart';

import '../../date_validators/date_validator.dart';
import '../../date_validators/date_validator_mixin.dart';
import '../../helpers/limited_or_every_handler.dart';
import '../every.dart';
import '../limited_every_mixin.dart';
import '../limited_every_modifier_invalidator.dart';
import 'date_direction.dart';
import 'every_wrapper_invalidator_mixin.dart';
import 'limited_every_modifier_mixin.dart';

/// {@template everyOverrideWrapper}
/// Class that wraps an [Every] generator and adds a [DateValidator] that will
/// be used to invalidate the generated dates and an [overrider] that will be
/// used instead.
///
/// When the [invalidator] invalidates the generated dates, the [overrider]
/// will be used instead.
/// {@endtemplate}
class EveryOverrideModifier<T extends Every, V extends DateValidator>
    extends LimitedEveryModifierInvalidator<T, V>
    with
        EquatableMixin,
        LimitedEveryModifierMixin<T, V>,
        LimitedEveryMixin,
        DateValidatorMixin,
        EveryModifierInvalidatorMixin<T, V> {
  /// {@macro everyOverrideWrapper}
  const EveryOverrideModifier({
    required super.every,
    required super.invalidator,
    required this.overrider,
  });

  /// The every used instead of the original when the generated date is valid
  /// for the [invalidator].
  final T overrider;

  /// When the [date] is valid for the [invalidator], the [overrider] will be
  /// used instead of [every].
  ///
  /// If the [date] is invalid for the [invalidator], [date] will be returned.
  @override
  DateTime processDate(
    DateTime date,
    DateDirection direction, {
    DateTime? limit,
  }) {
    throwIfLimitReached(date, direction, limit: limit);
    if (valid(date)) return date;
    DateTime result;
    if (direction.isForward) {
      result = LimitedOrEveryHandler.next(overrider, date, limit: limit);
    } else {
      result = LimitedOrEveryHandler.previous(overrider, date, limit: limit);
    }
    throwIfLimitReached(result, direction, limit: limit);
    return result;
  }

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is EveryOverrideModifier) &&
            (other.every == every) &&
            (other.invalidator == invalidator) &&
            (other.overrider == overrider));
  }

  @override
  List<Object?> get props => [every, invalidator, overrider];
}
