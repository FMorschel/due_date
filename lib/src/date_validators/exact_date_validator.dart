import 'package:meta/meta.dart';

import 'date_validator.dart';

/// {@template exactDateValidator}
/// A class to save a specific validation for a [DateTime].
///
/// This version of [DateValidator] is used to validate a [DateTime] if it is
/// exactly the same as the [DateTime] passed to [valid] or [invalid].
///
/// {@template inexactDates}
/// There can be cases where an inexact date is valid. For example, if the
/// validator is testing for a day in a period with an specific property, there
/// can be an exception for the last day(s) of the period with this property.
/// {@endtemplate}
/// {@endtemplate}
@immutable
abstract class ExactDateValidator extends DateValidator {
  /// {@macro exactDateValidator}
  const ExactDateValidator({this.exact = true});

  /// {@template inexactDates}
  /// Returns whether the [DateTime] given to [valid] or [invalid] can be
  /// inexact.
  ///
  /// If [exact] is true, this will return false.
  /// {@endtemplate}
  bool get inexact => !exact;

  /// {@template exactDates}
  /// Returns whether the [DateTime] given to [valid] or [invalid] needs to fit
  /// exactly a specific date.
  /// {@endtemplate}
  final bool exact;
}
