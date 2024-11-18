import 'package:equatable/equatable.dart';

import '../../date_validators/date_validators.dart';
import '../../helpers/helpers.dart';
import '../date_time_limit_reached_exception.dart';
import '../every.dart';
import 'date_direction.dart';
import 'every_modifier_invalidator.dart';
import 'limited_every_modifier_mixin.dart';

/// {@template everyOverrideWrapper}
/// Class that wraps an [Every] generator and adds a [DateValidator] that will
/// be used to invalidate the generated dates and an [overrider] that will be
/// used instead.
///
/// When the [invalidator] invalidates the generated dates, the [overrider]
/// will be used instead.
/// {@endtemplate}
class EveryOverrideWrapper<T extends Every> extends EveryModifierInvalidator<T>
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

  /// Generates the start date of the [every] base process.
  /// If the [date] is valid for the [invalidator], the [overrider] startDate
  /// will be used instead of the [every].
  @override
  DateTime startDate(DateTime date, {DateTime? limit}) {
    final validForEveryValidator =
        (every is DateValidator) && ((every as DateValidator).valid(date));
    if (!validForEveryValidator && (every.startDate(date) != date)) {
      var previous = LimitedOrEveryHandler.previous(
        overrider,
        date,
        limit: limit,
      );

      /// - Iterate over the next possible dates after [previous] with the
      /// [every] generator using startDate on the first iteration and next on
      /// every following.
      /// If the date generated for the  iteration is already bigger than the
      /// given [date], super.startDate will be used.
      /// If the date is valid for the [invalidator], the [overrider] startDate
      /// will be used.
      /// If that date is then the exact given [date], it will be returned.
      /// If that date is before the given [date], a new iteration will be
      /// started.
      previous = every.startDate(previous);
      if (previous.isAfter(date)) {
        return super.startDate(date, limit: limit);
      } else if (previous.isAtSameMomentAs(date)) {
        if (invalidator.invalid(previous)) return date;
      }
      while (previous.isBefore(date)) {
        if (invalidator.valid(previous)) {
          previous = overrider.startDate(previous);
        }
        if (previous.isAfter(date)) {
          return super.startDate(date, limit: limit);
        } else if (previous.isAtSameMomentAs(date)) {
          if (invalidator.invalid(previous)) return date;
        }
        previous = every.next(previous);
      }
      if (previous.isAfter(date)) {
        return super.startDate(date, limit: limit);
      } else if (previous.isAtSameMomentAs(date)) {
        if (invalidator.invalid(previous)) return date;
      }
    }
    return super.startDate(date, limit: limit);
  }

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
