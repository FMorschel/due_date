import 'package:equatable/equatable.dart';

import '../../date_validators/date_validator.dart';
import '../../date_validators/date_validator_mixin.dart';
import '../date_direction.dart';
import '../every.dart';
import '../limited_every_mixin.dart';
import 'every_adapter.dart';
import 'every_adapter_invalidator_mixin.dart';
import 'limited_every_adapter_mixin.dart';

/// {@template everySkipInvalidModifier}
/// Class that wraps an [Every] generator and adds a [DateValidator] that will
/// be used to invalidate the generated dates.
///
/// It will return the next [DateTime] that matches the [every] pattern and is
/// not valid for the [validator].
/// {@endtemplate}
class EverySkipInvalidAdapter<T extends Every, V extends DateValidator>
    extends EveryAdapter<T, V>
    with
        EquatableMixin,
        LimitedEveryAdapterMixin<T, V>,
        LimitedEveryMixin,
        DateValidatorMixin,
        EveryAdapterInvalidatorMixin<T, V> {
  /// {@macro everySkipInvalidModifier}
  const EverySkipInvalidAdapter({
    required super.every,
    required super.validator,
  });

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
        ((other is EverySkipInvalidAdapter) &&
            (other.every == every) &&
            (other.validator == validator));
  }

  @override
  List<Object?> get props => [every, validator];
}
