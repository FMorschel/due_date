import 'package:equatable/equatable.dart';
import 'package:time/time.dart';

import '../../date_validators/date_validator_mixin.dart';
import '../date_direction.dart';
import '../every.dart';
import '../every_date_validator.dart';
import '../every_due_time_of_day.dart';
import '../limited_every_mixin.dart';
import '../wrappers/every_time_of_day_wrapper.dart';
import 'limited_every_modifier_mixin.dart';

/// {@template everyTimeOfDayModifier}
/// Class that wraps an [Every] and modifies its behavior so that all
/// processed [DateTime]s have the same time of day as specified by
/// [everyTimeOfDay].
///
/// If the [everyTimeOfDay] is set to midnight (00:00), then all processed
/// [DateTime]s will have their time set to midnight.
///
/// If your input date is `2024-01-01 15:30` and the [every] returns
/// `2024-01-05 15:30`, but this wrapper has an [everyTimeOfDay] of
/// midnight, the final output will be `2024-01-05 00:00`.
/// {@endtemplate}
class EveryTimeOfDayModifier<T extends EveryDateValidator>
    extends EveryTimeOfDayWrapper<T>
    with
        DateValidatorMixin,
        LimitedEveryModifierMixin<T>,
        LimitedEveryMixin,
        EquatableMixin {
  /// {@macro everyTimeOfDayModifier}
  const EveryTimeOfDayModifier({
    required super.every,
    super.everyTimeOfDay = EveryDueTimeOfDay.midnight,
  });

  @override
  bool valid(DateTime date) => every.valid(date) && everyTimeOfDay.valid(date);

  @override
  DateTime processDate(
    DateTime date,
    DateDirection direction, {
    DateTime? limit,
  }) {
    throwIfLimitReached(date, direction, limit: limit);
    if (invalid(date) && every.valid(date) && direction.couldStayEqual) {
      return everyTimeOfDay.startDate(date.date);
    }
    return super.processDate(date, direction);
  }

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is EveryTimeOfDayModifier<T>) &&
            (every == other.every) &&
            (everyTimeOfDay == other.everyTimeOfDay));
  }

  @override
  List<Object?> get props => [every, everyTimeOfDay];
}
