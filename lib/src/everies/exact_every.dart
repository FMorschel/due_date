import 'package:meta/meta.dart';

import '../date_validators/date_validators.dart';
import 'every.dart';
import 'every_date_validator.dart';

/// {@template exactEvery}
/// A class to save a truncated generator of [DateTime]s.
///
/// This version of [Every] is used to generate a [DateTime] truncated to a
/// specific period, such as a week, month, or year.
///
/// This can make it easier to work with specific dates that match a
/// particular pattern, such as the last day of the month or similar.
/// {@endtemplate}
@immutable
abstract class ExactEvery extends ExactDateValidator
    implements EveryDateValidator {
  /// {@macro exactEvery}
  const ExactEvery({super.exact});
}
