import 'package:meta/meta.dart';

import 'date_validator_mixin.dart';
import 'exact_date_validator.dart';

/// A class to save a specific validation for a [DateTime].
///
/// See also [ExactDateValidator].
@immutable
abstract class DateValidator {
  /// A class to save a specific validation for a [DateTime].
  const DateValidator();

  /// Returns true if the [date] is valid for this [DateValidator].
  ///
  /// This is the opposite of [valid].
  /// Implementations that return true for invalid should also return false for
  /// valid.
  bool valid(DateTime date);

  /// Returns true if the [date] is invalid for this [DateValidator].
  ///
  /// This is the opposite of [valid].
  /// Implementations that return true for invalid should also return false for
  /// valid.
  ///
  /// Usually, this will be implemented as `!valid(date)` by
  /// [DateValidatorMixin]. However, if there is a simpler way to check
  /// for invalid dates, it can be implemented here.
  bool invalid(DateTime date);

  /// A [DateValidator] with the opposite logic.
  DateValidator operator -();

  /// Returns the valid dates for this [DateValidator] in [dates].
  Iterable<DateTime> filterValidDates(Iterable<DateTime> dates);
}
