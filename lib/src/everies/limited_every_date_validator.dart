import 'every_date_validator.dart';
import 'every_month.dart';
import 'every_week.dart';
import 'every_year.dart';
import 'group/every_date_validator_difference.dart';
import 'group/every_date_validator_intersection.dart';
import 'group/every_date_validator_union.dart';
import 'limited_every.dart';

/// Abstract class that forces the implementation of [EveryDateValidator] to
/// have a limit parameter for the [next] and [previous] methods.
abstract class LimitedEveryDateValidator extends EveryDateValidator
    implements LimitedEvery {
  /// Abstract class that, when extended, processes [DateTime] with custom
  /// logic.
  ///
  /// Abstract class that forces the implementation of [EveryDateValidator] to
  /// have a limit parameter for the [next] and [previous] methods.
  ///
  /// See [EveryDateValidatorDifference], [EveryDateValidatorIntersection] and
  /// [EveryDateValidatorUnion] for complete base implementations.
  ///
  /// See [EveryWeek], [EveryMonth], [EveryYear] for your base implementations.
  const LimitedEveryDateValidator();

  /// {@macro startDate}
  ///
  /// {@macro limit}
  @override
  DateTime startDate(DateTime date, {DateTime? limit});

  /// {@macro next}
  ///
  /// {@macro limit}
  @override
  DateTime next(DateTime date, {DateTime? limit});

  /// {@macro previous}
  ///
  /// {@macro limit}
  @override
  DateTime previous(DateTime date, {DateTime? limit});

  /// {@macro endDate}
  ///
  /// {@macro limit}
  @override
  DateTime endDate(DateTime date, {DateTime? limit});
}
