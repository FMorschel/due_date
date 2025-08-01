import 'package:equatable/equatable.dart';

import '../../date_validators/date_validators.dart';
import '../../helpers/limited_or_every_handler.dart';
import '../date_time_limit_reached_exception.dart';
import '../every.dart';
import '../every_date_validator.dart';
import '../limited_every_date_validator.dart';
import 'date_direction.dart';
import 'every_modifier.dart';
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
    extends EveryModifier<T>
    with EquatableMixin, DateValidatorMixin
    implements
        LimitedEveryDateValidator,
        EveryModifierInvalidator<T, V>,
        LimitedEveryModifierMixin<T> {
  /// {@macro everySkipInvalidModifier}
  const EverySkipInvalidModifier({
    required super.every,
    required this.invalidator,
  });

  @override
  final V invalidator;

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
  bool invalid(DateTime date) => !valid(date);

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
    if (valid(date)) return date;
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

  @override
  DateTime startDate(DateTime date, {DateTime? limit}) {
    return processDate(
      LimitedOrEveryHandler.startDate2(every, this, date, limit: limit),
      DateDirection.start,
      limit: limit,
    );
  }

  @override
  DateTime next(DateTime date, {DateTime? limit}) {
    return processDate(
      LimitedOrEveryHandler.next(every, date, limit: limit),
      DateDirection.next,
      limit: limit,
    );
  }

  @override
  DateTime previous(DateTime date, {DateTime? limit}) {
    return processDate(
      LimitedOrEveryHandler.previous(every, date, limit: limit),
      DateDirection.previous,
      limit: limit,
    );
  }

  @override
  DateTime endDate(DateTime date, {DateTime? limit}) {
    return processDate(
      LimitedOrEveryHandler.endDate2(every, this, date, limit: limit),
      DateDirection.end,
      limit: limit,
    );
  }
}
