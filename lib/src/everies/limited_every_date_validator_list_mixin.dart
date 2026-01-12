import '../date_validators/date_validator_list_mixin.dart';
import 'every.dart';
import 'every_date_validator.dart';
import 'every_date_validator_list_mixin.dart';
import 'limited_every.dart';
import 'limited_every_date_validator.dart';

/// Mixin that represents a list of [EveryDateValidator].
mixin LimitedEveryDateValidatorListMixin<E extends EveryDateValidator>
    on DateValidatorListMixin<E>
    implements LimitedEveryDateValidator, EveryDateValidatorListMixin<E> {
  /// List for all of the [everies] that will be used to generate the date.
  @override
  List<EveryDateValidator> get everies => [...this];

  /// Returns the next [DateTime] that matches the [Every] pattern.
  ///
  /// For every one one of the [everies] that is a [LimitedEvery], the [limit]
  /// will be passed.
  /// If none of the [everies] is a [LimitedEvery], the [limit] will be ignored.
  @override
  DateTime startDate(DateTime date, {DateTime? limit}) {
    if (valid(date)) return date;
    return next(date, limit: limit);
  }

  /// Returns the next [DateTime] that matches the [Every] pattern.
  ///
  /// For every one one of the [everies] that is a [LimitedEvery], the [limit]
  /// will be passed.
  /// If none of the [everies] is a [LimitedEvery], the [limit] will be ignored.
  @override
  DateTime endDate(DateTime date, {DateTime? limit}) {
    if (valid(date)) return date;
    return previous(date, limit: limit);
  }
}
