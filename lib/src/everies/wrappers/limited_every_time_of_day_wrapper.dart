import 'package:equatable/equatable.dart';
import 'package:time/time.dart';

import '../built_in/every_due_time_of_day.dart';
import '../date_direction.dart';
import '../every.dart';
import 'every_time_of_day_wrapper.dart';
import 'limited_every_wrapper.dart';
import 'limited_every_wrapper_mixin.dart';

/// {@template limitedEveryTimeOfDayWrapper}
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
class LimitedEveryTimeOfDayWrapper<T extends Every>
    extends LimitedEveryWrapper<T>
    with LimitedEveryWrapperMixin<T>, EquatableMixin
    implements EveryTimeOfDayWrapper<T> {
  /// {@macro limitedEveryTimeOfDayWrapper}
  const LimitedEveryTimeOfDayWrapper({
    required super.every,
    this.everyTimeOfDay = EveryDueTimeOfDay.midnight,
  });

  /// The [EveryDueTimeOfDay] that specifies the time of day to set on all
  /// processed [DateTime]s.
  @override
  final EveryDueTimeOfDay everyTimeOfDay;

  @override
  DateTime processDate(
    DateTime date,
    DateDirection direction, {
    DateTime? limit,
  }) {
    throwIfLimitReached(date, direction, limit: limit);
    return everyTimeOfDay.startDate(date.date);
  }

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is LimitedEveryTimeOfDayWrapper<T>) &&
            (every == other.every) &&
            (everyTimeOfDay == other.everyTimeOfDay));
  }

  @override
  List<Object?> get props => [every, everyTimeOfDay];
}
