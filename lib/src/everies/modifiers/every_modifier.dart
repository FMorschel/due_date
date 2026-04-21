import 'package:essential_lints_annotations/essential_lints_annotations.dart';

import '../../date_validators/date_validator_mixin.dart';
import '../built_in/every_due_time_of_day.dart';
import '../date_direction.dart';
import '../every_date_validator.dart';
import '../wrappers/every_wrapper.dart';
import 'every_skip_count_modifier.dart';
import 'every_time_of_day_modifier.dart';
import 'limited_every_skip_count_modifier.dart';
import 'limited_every_time_of_day_modifier.dart';

/// {@template every_modifier}
/// Abstract class that, when extended, processes [DateTime] with custom logic.
/// {@endtemplate}
@SubtypeNaming(containing: 'Modifier', packageOption: PackageOption.private)
@SubtypeUnnaming(containing: 'Wrapper', packageOption: PackageOption.private)
abstract class EveryModifier<T extends EveryDateValidator>
    extends EveryDateValidator
    with DateValidatorMixin
    implements EveryWrapper<T> {
  /// {@macro every_modifier}
  const EveryModifier({required this.every});

  /// {@macro every_skip_count_wrapper}
  const factory EveryModifier.skipCount({
    required T every,
    required int count,
  }) = EverySkipCountModifier<T>;

  /// {@macro every_time_of_day_modifier}
  const factory EveryModifier.timeOfDay({
    required T every,
    required EveryDueTimeOfDay everyTimeOfDay,
  }) = EveryTimeOfDayModifier<T>;

  /// {@macro limited_every_skip_count_modifier}
  const factory EveryModifier.limitedSkipCount({
    required T every,
    required int count,
  }) = LimitedEverySkipCountModifier<T>;

  /// {@macro limited_every_time_of_day_modifier}
  const factory EveryModifier.limitedTimeOfDay({
    required T every,
    required EveryDueTimeOfDay everyTimeOfDay,
  }) = LimitedEveryTimeOfDayModifier<T>;

  /// The base generator for this [EveryModifier].
  @override
  final T every;

  /// A method that processes [date] with custom logic.
  @override
  DateTime processDate(DateTime date, DateDirection direction);
}
