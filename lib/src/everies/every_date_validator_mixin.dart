import 'every_date_validator.dart';

/// A mixin to easily implement the [EveryDateValidator.startDate] and
/// [EveryDateValidator.endDate] methods.
mixin EveryDateValidatorMixin implements EveryDateValidator {
  @override
  DateTime startDate(DateTime date) {
    if (valid(date)) return date;
    return next(date);
  }

  @override
  DateTime endDate(DateTime date) {
    if (valid(date)) return date;
    return previous(date);
  }
}
