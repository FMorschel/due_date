import 'package:equatable/equatable.dart';

import '../../date_validators/date_validator.dart';
import '../../date_validators/date_validator_mixin.dart';
import '../../helpers/limited_or_every_handler.dart';
import '../date_direction.dart';
import '../every.dart';
import '../limited_every_mixin.dart';
import 'every_adapter_invalidator_mixin.dart';
import 'limited_every_adapter_invalidator.dart';
import 'limited_every_adapter_mixin.dart';

/// {@template everyOverrideWrapper}
/// Class that wraps an [Every] generator and adds a [DateValidator] that will
/// be used to invalidate the generated dates and an [overrider] that will be
/// used instead.
///
/// When the [validator] invalidates the generated dates, the [overrider]
/// will be used instead.
/// {@endtemplate}
class EveryOverrideAdapter<T extends Every, V extends DateValidator>
    extends LimitedEveryAdapterInvalidator<T, V>
    with
        EquatableMixin,
        LimitedEveryAdapterMixin<T, V>,
        LimitedEveryMixin,
        DateValidatorMixin,
        EveryAdapterInvalidatorMixin<T, V> {
  /// {@macro everyOverrideWrapper}
  const EveryOverrideAdapter({
    required super.every,
    required super.validator,
    required this.overrider,
  });

  /// The every used instead of the original when the generated date is valid
  /// for the [validator].
  final T overrider;

  /// When the [date] is valid for the [validator], the [overrider] will be
  /// used instead of [every].
  ///
  /// If the [date] is invalid for the [validator], [date] will be returned.
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
        ((other is EveryOverrideAdapter) &&
            (other.every == every) &&
            (other.validator == validator) &&
            (other.overrider == overrider));
  }

  @override
  List<Object?> get props => [every, validator, overrider];
}
