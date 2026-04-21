import 'package:essential_lints_annotations/essential_lints_annotations.dart';

import '../../date_validators/date_validator.dart';
import '../../date_validators/date_validator_mixin.dart';
import '../built_in/every_due_time_of_day.dart';
import '../date_direction.dart';
import '../every.dart';
import '../every_date_validator.dart';
import '../wrappers/every_wrapper.dart';
import 'every_override_adapter.dart';
import 'every_skip_count_adapter.dart';
import 'every_skip_invalid_adapter.dart';
import 'every_time_of_day_adapter.dart';
import 'limited_every_override_adapter.dart';
import 'limited_every_skip_count_adapter.dart';
import 'limited_every_skip_invalid_adapter.dart';
import 'limited_every_time_of_day_adapter.dart';

/// {@template every_adapter}
/// Abstract class that, when extended, processes [DateTime] with custom logic.
/// {@endtemplate}
@SubtypeNaming(containing: 'Adapter', packageOption: PackageOption.private)
@SubtypeUnnaming(containing: 'Wrapper', packageOption: PackageOption.private)
abstract class EveryAdapter<T extends Every, V extends DateValidator>
    extends EveryDateValidator
    with DateValidatorMixin
    implements EveryWrapper<T> {
  /// {@macro every_adapter}
  const EveryAdapter({required this.every, required this.validator});

  /// {@macro every_skip_count_adapter}
  const factory EveryAdapter.skipCount({
    required T every,
    required V validator,
    required int count,
  }) = EverySkipCountAdapter<T, V>;

  /// {@macro every_time_of_day_adapter}
  const factory EveryAdapter.timeOfDay({
    required T every,
    required V validator,
    required EveryDueTimeOfDay everyTimeOfDay,
  }) = EveryTimeOfDayAdapter<T, V>;

  /// {@macro every_skip_invalid_adapter}
  const factory EveryAdapter.skipInvalid({
    required T every,
    required V validator,
  }) = EverySkipInvalidAdapter<T, V>;

  /// {@macro every_override_adapter}
  const factory EveryAdapter.override({
    required T every,
    required V validator,
    required T overrider,
  }) = EveryOverrideAdapter<T, V>;

  /// {@macro limited_every_skip_count_adapter}
  const factory EveryAdapter.limitedSkipCount({
    required T every,
    required V validator,
    required int count,
  }) = LimitedEverySkipCountAdapter<T, V>;

  /// {@macro limited_every_time_of_day_adapter}
  const factory EveryAdapter.limitedTimeOfDay({
    required T every,
    required V validator,
    required EveryDueTimeOfDay everyTimeOfDay,
  }) = LimitedEveryTimeOfDayAdapter<T, V>;

  /// {@macro limited_every_skip_invalid_adapter}
  const factory EveryAdapter.limitedSkipInvalid({
    required T every,
    required V validator,
  }) = LimitedEverySkipInvalidAdapter<T, V>;

  /// {@macro limited_every_override_adapter}
  const factory EveryAdapter.limitedOverride({
    required T every,
    required V validator,
    required T overrider,
  }) = LimitedEveryOverrideAdapter<T, V>;

  /// The base generator for this [EveryAdapter].
  @override
  final T every;

  /// The validator used by this [EveryAdapter].
  final V validator;

  /// A method that processes [date] with custom logic.
  @override
  DateTime processDate(DateTime date, DateDirection direction);
}
