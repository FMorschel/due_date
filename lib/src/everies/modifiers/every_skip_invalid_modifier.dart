import 'package:equatable/equatable.dart';

import '../../date_validator.dart';
import '../date_time_limit_reached_exception.dart';
import '../every.dart';
import '../every_date_validator.dart';
import 'date_direction.dart';
import 'every_modifier_invalidator.dart';
import 'limited_every_modifier_mixin.dart';

/// {@template everySkipInvalidModifier}
/// Class that wraps an [Every] generator and adds a [DateValidator] that will
/// be used to invalidate the generated dates.
///
/// It will return the next [DateTime] that matches the [every] pattern and is
/// not valid for the [invalidator].
/// {@endtemplate}
class EverySkipInvalidModifier<T extends Every, V extends DateValidator>
    extends EveryModifierInvalidator<T>
    with EquatableMixin, DateValidatorMixin, LimitedEveryModifierMixin<T>
    implements EveryDateValidator {
  /// {@macro everySkipInvalidModifier}
  const EverySkipInvalidModifier({
    required super.every,
    required super.invalidator,
  });

  /// Returns the next [DateTime] that matches the [every] pattern and is not
  /// valid for the [invalidator].
  @override
  DateTime startDate(DateTime date, {DateTime? limit}) =>
      super.startDate(date, limit: limit);

  /// Returns the next instance of the given [date] considering the [every]
  /// base process. If the [date] is valid for the [invalidator], a new
  /// [DateTime] will be returned.
  @override
  DateTime next(DateTime date, {DateTime? limit}) =>
      super.next(date, limit: limit);

  /// Returns the previous instance of the given [date] considering the [every]
  /// base process. If the [date] is valid for the [invalidator], a new
  /// [DateTime] will be returned.
  @override
  DateTime previous(DateTime date, {DateTime? limit}) =>
      super.previous(date, limit: limit);

  /// Returns `true` if the [date] is valid for the [every] (if it is a
  /// [DateValidator], like an [EveryDateValidator], for example) and not valid
  /// for the [invalidator].
  @override
  bool valid(DateTime date) {
    if (every is DateValidator) {
      final invalid = (every as DateValidator).invalid(date);
      if (invalid) return false;
    }
    return invalidator.invalid(date);
  }

  /// Returns `true` if the [date] is invalid for the [every] (if it is a
  /// [DateValidator], like an [EveryDateValidator], for example) and valid for
  /// the [invalidator].
  ///
  /// This is the opposite of [valid].
  /// Implementations that return true for invalid should also return false for
  /// valid.
  ///
  /// Usually, this will be implemented as `!valid(date)` by the [Every] classes
  /// that implement [DateValidatorMixin]. However, if there is a simpler way to
  /// check for invalid dates, it can be implemented here.
  @override
  bool invalid(DateTime date) {
    if (every is DateValidator) {
      final invalid = (every as DateValidator).invalid(date);
      if (invalid) return true;
    }
    return invalidator.valid(date);
  }

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
    if (!direction.isPrevious) return next(date, limit: limit);
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
