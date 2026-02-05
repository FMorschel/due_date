import 'package:equatable/equatable.dart';
import 'package:time/time.dart';

import '../../date_validators/date_validator_mixin.dart';
import '../built_in/every_due_time_of_day.dart';
import '../date_direction.dart';
import '../every.dart';
import '../every_date_validator.dart';
import '../wrappers/every_time_of_day_wrapper.dart';
import 'every_modifier.dart';
import 'every_modifier_mixin.dart';

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
    extends EveryModifier<T>
    with DateValidatorMixin, EquatableMixin, EveryModifierMixin<T>
    implements EveryTimeOfDayWrapper<T> {
  /// {@macro everyTimeOfDayModifier}
  const EveryTimeOfDayModifier({
    required super.every,
    this.everyTimeOfDay = EveryDueTimeOfDay.midnight,
  });

  @override
  final EveryDueTimeOfDay everyTimeOfDay;

  @override
  bool valid(DateTime date) => every.valid(date) && everyTimeOfDay.valid(date);

  @override
  DateTime processDate(DateTime date, DateDirection direction) {
    if (every.valid(date)) {
      return everyTimeOfDay.startDate(date.date);
    }
    if (direction.isForward) {
      return processDate(every.next(date), DateDirection.start);
    }
    return processDate(every.previous(date), DateDirection.end);
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
