import 'package:equatable/equatable.dart';
import 'package:time/time.dart';

import '../../date_validators/date_validator.dart';
import '../../date_validators/date_validator_mixin.dart';
import '../built_in/every_due_time_of_day.dart';
import '../date_direction.dart';
import '../every.dart';
import '../every_date_validator.dart';
import '../wrappers/every_time_of_day_wrapper.dart';
import 'every_adapter.dart';
import 'every_adapter_mixin.dart';

/// {@template everyTimeOfDayAdapter}
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
class EveryTimeOfDayAdapter<T extends Every, V extends DateValidator>
    extends EveryAdapter<T, V>
    with DateValidatorMixin, EveryAdapterMixin<T, V>, EquatableMixin
    implements EveryTimeOfDayWrapper<T> {
  /// {@macro everyTimeOfDayAdapter}
  const EveryTimeOfDayAdapter({
    required super.every,
    required super.validator,
    this.everyTimeOfDay = EveryDueTimeOfDay.midnight,
  });

  @override
  final EveryDueTimeOfDay everyTimeOfDay;

  @override
  bool valid(DateTime date) {
    if (!validator.valid(date)) return false;
    final every = this.every;
    if (every is EveryDateValidator) {
      return every.valid(date);
    }
    return false;
  }

  @override
  DateTime processDate(DateTime date, DateDirection direction) {
    if (validator.valid(date)) {
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
        ((other is EveryTimeOfDayAdapter<T, V>) &&
            (every == other.every) &&
            (everyTimeOfDay == other.everyTimeOfDay));
  }

  @override
  List<Object?> get props => [every, everyTimeOfDay];
}
