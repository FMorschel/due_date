import '../date_validators/date_validators.dart';

/// Extension methods related to [DateValidator]s. Simply wrappers around
/// creating [DateValidatorIntersection], [DateValidatorUnion] or
/// [DateValidatorDifference].
extension DateValidatorListExt on List<DateValidator> {
  /// Returns a [DateValidatorIntersection] of this [List] of [DateValidator]s.
  DateValidatorIntersection get intersection => DateValidatorIntersection(this);

  /// Returns a [DateValidatorUnion] of this [List] of [DateValidator]s.
  DateValidatorDifference get difference => DateValidatorDifference(this);

  /// Returns a [DateValidatorDifference] of this [List] of [DateValidator]s.
  DateValidatorUnion get union => DateValidatorUnion(this);
}
