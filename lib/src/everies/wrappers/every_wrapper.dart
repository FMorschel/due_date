import 'package:essential_lints_annotations/essential_lints_annotations.dart';

import '../built_in/every_due_time_of_day.dart';
import '../date_direction.dart';
import '../every.dart';
import 'every_skip_count_wrapper.dart';
import 'every_time_of_day_wrapper.dart';
import 'limited_every_skip_count_wrapper.dart';
import 'limited_every_time_of_day_wrapper.dart';

/// {@template every_wrapper}
/// Abstract class that, when extended, processes [DateTime] with custom logic.
/// {@endtemplate}
@SubtypeNaming(containing: 'Wrapper', packageOption: PackageOption.private)
abstract class EveryWrapper<T extends Every> extends Every {
  /// {@macro every_wrapper}
  const EveryWrapper({required this.every});

  /// {@macro every_skip_count_wrapper}
  const factory EveryWrapper.skipCount({
    required T every,
    required int count,
  }) = EverySkipCountWrapper<T>;

  /// {@macro every_time_of_day_wrapper}
  const factory EveryWrapper.timeOfDay({
    required T every,
    required EveryDueTimeOfDay everyTimeOfDay,
  }) = EveryTimeOfDayWrapper<T>;

  /// {@macro limited_every_skip_count_wrapper}
  const factory EveryWrapper.limitedSkipCount({
    required T every,
    required int count,
  }) = LimitedEverySkipCountWrapper<T>;

  /// {@macro limited_every_time_of_day_wrapper}
  const factory EveryWrapper.limitedTimeOfDay({
    required T every,
    required EveryDueTimeOfDay everyTimeOfDay,
  }) = LimitedEveryTimeOfDayWrapper<T>;

  /// The base generator for this [EveryWrapper].
  final T every;

  /// A method that processes [date] with custom logic.
  DateTime processDate(DateTime date, DateDirection direction);
}
