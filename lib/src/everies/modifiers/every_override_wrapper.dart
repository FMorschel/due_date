import 'package:equatable/equatable.dart';

import '../../date_validators/date_validators.dart';
import '../../helpers/helpers.dart';
import '../date_time_limit_reached_exception.dart';
import '../every.dart';
import '../limited_every_modifier_invalidator.dart';
import 'date_direction.dart';
import 'limited_every_modifier_mixin.dart';

/// {@template everyOverrideWrapper}
/// Class that wraps an [Every] generator and adds a [DateValidator] that will
/// be used to invalidate the generated dates and an [overrider] that will be
/// used instead.
///
/// When the [invalidator] invalidates the generated dates, the [overrider]
/// will be used instead.
/// {@endtemplate}
class EveryOverrideWrapper<T extends Every, V extends DateValidator>
    extends LimitedEveryModifierInvalidator<T, V>
    with EquatableMixin, LimitedEveryModifierMixin<T> {
  /// {@macro everyOverrideWrapper}
  const EveryOverrideWrapper({
    required super.every,
    required super.invalidator,
    required this.overrider,
  });

  /// The every used instead of the original when the generated date is valid
  /// for the [invalidator].
  final T overrider;

  /// Generates the next instance of the given [date] considering the [every]
  /// base process.
  /// If the [date] is valid for the [invalidator], the [overrider] next will
  /// be used instead of the [every].
  @override
  DateTime next(DateTime date, {DateTime? limit}) =>
      super.next(date, limit: limit);

  /// Generates the previous instance of the given [date] considering the
  /// [every] base process.
  /// If the [date] is valid for the [invalidator], the [overrider] previous
  /// will be used instead of the [every].
  @override
  DateTime previous(DateTime date, {DateTime? limit}) =>
      super.previous(date, limit: limit);

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
    if ((limit != null) &&
        (direction.isPrevious ? date.isBefore(limit) : date.isAfter(limit))) {
      throw DateTimeLimitReachedException(date: date, limit: limit);
    }
    if (invalidator.invalid(date)) return date;
    if (!direction.isPrevious) {
      return processDate(
        LimitedOrEveryHandler.next(overrider, date, limit: limit),
        direction,
        limit: limit,
      );
    }
    return processDate(
      LimitedOrEveryHandler.previous(overrider, date, limit: limit),
      direction,
      limit: limit,
    );
  }

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is EveryOverrideWrapper) &&
            (other.every == every) &&
            (other.invalidator == invalidator) &&
            (other.overrider == overrider));
  }

  @override
  List<Object?> get props => [every, invalidator, overrider];
}
