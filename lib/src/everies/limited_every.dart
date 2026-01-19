import 'package:essential_lints_annotations/essential_lints_annotations.dart';

import 'date_direction.dart';
import 'date_time_limit_reached_exception.dart';
import 'every.dart';
import 'every_date_validator_difference.dart';
import 'every_date_validator_intersection.dart';
import 'every_date_validator_union.dart';
import 'every_month.dart';
import 'every_week.dart';
import 'every_year.dart';

/// Abstract class that forces the implementation of [Every] to have a
/// limit parameter for the [next] and [previous] methods.
@SubtypeNaming(prefix: 'Limited', option: SubtypeOption.onlyAbstract)
abstract class LimitedEvery extends Every {
  /// Abstract class that, when extended, processes [DateTime] with custom
  /// logic.
  ///
  /// Abstract class that forces the implementation of [Every] to have a
  /// limit parameter for the [next] and [previous] methods.
  ///
  /// See [EveryDateValidatorDifference], [EveryDateValidatorIntersection] and
  /// [EveryDateValidatorUnion] for complete base implementations.
  ///
  /// See [EveryWeek], [EveryMonth], [EveryYear] for your base implementations.
  const LimitedEvery();

  /// {@macro next}
  ///
  /// {@template limit}
  /// If the generated [DateTime] is still not able to return the first call to
  /// this function it will be called recursively.
  /// If [limit] is not null and the generated [DateTime] is past [limit], a
  /// [DateTimeLimitReachedException] will be thrown.
  /// {@endtemplate}
  @override
  DateTime next(DateTime date, {DateTime? limit});

  /// {@macro previous}
  ///
  /// {@macro limit}
  @override
  DateTime previous(DateTime date, {DateTime? limit});

  /// Throws a [DateTimeLimitReachedException] if the [date] has reached the
  /// [limit] in the given [direction].
  void throwIfLimitReached(
    DateTime date,
    DateDirection direction, {
    required DateTime? limit,
  });
}
