import '../everies/everies.dart';

/// Extension methods related to [EveryDateValidator]s. Simply wrappers around
/// creating [EveryDateValidatorIntersection], [EveryDateValidatorUnion] or
/// [EveryDateValidatorDifference].
extension EveryDateValidatorListExt on List<EveryDateValidator> {
  /// Returns a [EveryDateValidatorIntersection] of this [List] of
  /// [EveryDateValidator]s.
  EveryDateValidatorIntersection get intersection {
    return EveryDateValidatorIntersection(this);
  }

  /// Returns a [EveryDateValidatorDifference] of this [List] of
  /// [EveryDateValidator]s.
  EveryDateValidatorDifference get difference {
    return EveryDateValidatorDifference(this);
  }

  /// Returns a [EveryDateValidatorUnion] of this [List] of
  /// [EveryDateValidator]s.
  EveryDateValidatorUnion get union {
    return EveryDateValidatorUnion(this);
  }
}
