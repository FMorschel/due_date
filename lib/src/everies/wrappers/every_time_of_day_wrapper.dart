import 'package:equatable/equatable.dart';
import 'package:time/time.dart';

import '../built_in/every_due_time_of_day.dart';
import '../date_direction.dart';
import '../every.dart';
import 'every_wrapper.dart';
import 'every_wrapper_mixin.dart';

/// {@template everyTimeOfDayWrapper}
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
class EveryTimeOfDayWrapper<T extends Every> extends EveryWrapper<T>
    with EveryWrapperMixin<T>, EquatableMixin {
  /// {@macro everyTimeOfDayWrapper}
  const EveryTimeOfDayWrapper({
    required super.every,
    this.everyTimeOfDay = EveryDueTimeOfDay.midnight,
  });

  /// The [EveryDueTimeOfDay] that specifies the time of day to set on all
  /// processed [DateTime]s.
  final EveryDueTimeOfDay everyTimeOfDay;

  @override
  DateTime processDate(DateTime date, DateDirection direction) {
    return everyTimeOfDay.startDate(date.date);
  }

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is EveryTimeOfDayWrapper<T>) &&
            (every == other.every) &&
            (everyTimeOfDay == other.everyTimeOfDay));
  }

  @override
  List<Object?> get props => [every, everyTimeOfDay];
}
