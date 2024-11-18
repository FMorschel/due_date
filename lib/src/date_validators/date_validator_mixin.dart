import 'date_validator.dart';

/// Mixin to easily implement the [DateValidator.invalid],
/// [DateValidator.filterValidDates] and [DateValidator.filterValidDates]
/// methods.
mixin DateValidatorMixin implements DateValidator {
  @override
  bool invalid(DateTime date) => !valid(date);

  @override
  @Deprecated("Use 'DateValidator.filterValidDates' instead.")
  Iterable<DateTime> validsIn(Iterable<DateTime> dates) =>
      filterValidDates(dates);

  @override
  Iterable<DateTime> filterValidDates(Iterable<DateTime> dates) sync* {
    for (final date in dates) {
      if (valid(date)) yield date;
    }
  }
}
