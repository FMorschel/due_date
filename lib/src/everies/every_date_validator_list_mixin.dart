import '../date_validators/date_validator_list_mixin.dart';
import 'every.dart';
import 'every_date_validator.dart';

/// Mixin that represents a list of [EveryDateValidator].
mixin EveryDateValidatorListMixin<E extends EveryDateValidator>
    on DateValidatorListMixin<E> implements EveryDateValidator {
  /// List for all of the [everies] that will be used to generate the date.
  List<EveryDateValidator> get everies => [...this];

  /// Returns the next [DateTime] that matches the [Every] pattern.
  @override
  DateTime startDate(DateTime date) {
    if (valid(date)) return date;
    return next(date);
  }

  /// Returns the next [DateTime] that matches the [Every] pattern.
  @override
  DateTime endDate(DateTime date) {
    if (valid(date)) return date;
    return previous(date);
  }
}
