import 'limited_every_date_validator.dart';

/// Mixin to easily implement the [LimitedEveryDateValidator] methods.
mixin LimitedEveryDateValidatorMixin implements LimitedEveryDateValidator {
  @override
  DateTime startDate(DateTime date, {DateTime? limit}) {
    if (valid(date)) return date;
    return next(date, limit: limit);
  }

  @override
  DateTime endDate(DateTime date, {DateTime? limit}) {
    if (valid(date)) return date;
    return previous(date, limit: limit);
  }
}
