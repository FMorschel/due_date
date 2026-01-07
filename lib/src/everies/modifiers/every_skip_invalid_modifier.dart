import 'package:equatable/equatable.dart';

import '../../date_validators/date_validator.dart';
import '../../date_validators/date_validator_mixin.dart';
import '../every.dart';
import '../limited_every_mixin.dart';
import 'date_direction.dart';
import 'every_modifier.dart';
import 'every_wrapper_invalidator_mixin.dart';
import 'limited_every_modifier_mixin.dart';

/// {@template everySkipInvalidModifier}
/// Class that wraps an [Every] generator and adds a [DateValidator] that will
/// be used to invalidate the generated dates.
///
/// It will return the next [DateTime] that matches the [every] pattern and is
/// not valid for the [invalidator].
/// {@endtemplate}
class EverySkipInvalidModifier<T extends Every, V extends DateValidator>
    extends EveryModifier<T, V>
    with
        EquatableMixin,
        LimitedEveryModifierMixin<T, V>,
        LimitedEveryMixin,
        DateValidatorMixin,
        EveryModifierInvalidatorMixin<T, V> {
  /// {@macro everySkipInvalidModifier}
  const EverySkipInvalidModifier({
    required super.every,
    required this.invalidator,
  });

  @override
  final V invalidator;

  @override
  DateTime processDate(
    DateTime date,
    DateDirection direction, {
    DateTime? limit,
  }) {
    throwIfLimitReached(date, direction, limit: limit);
    if (valid(date)) return date;
    if (direction.isForward) return next(date, limit: limit);
    return previous(date, limit: limit);
  }

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is EverySkipInvalidModifier) &&
            (other.every == every) &&
            (other.invalidator == invalidator));
  }

  @override
  List<Object?> get props => [every, invalidator];
}
