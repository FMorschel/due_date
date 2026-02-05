import 'date_validator.dart';
import 'built_in/date_validator_opposite.dart';

/// Mixin to easily implement the [DateValidator.invalid],
/// [DateValidator.filterValidDates] and [DateValidator.filterValidDates]
/// methods.
mixin DateValidatorMixin implements DateValidator {
  @override
  bool invalid(DateTime date) => !valid(date);

  @override
  Iterable<DateTime> filterValidDates(Iterable<DateTime> dates) sync* {
    for (final date in dates) {
      if (valid(date)) yield date;
    }
  }

  @override
  DateValidator operator -() {
    if (this is DateValidatorOpposite) return -this;
    return DateValidatorOpposite(this);
  }
}
