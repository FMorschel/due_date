import '../date_validators/date_validators.dart';
import 'every.dart';

/// A base class that represents an [Every] with a [DateValidator].
abstract class EveryDateValidator extends Every with DateValidatorMixin {
  /// A base class that represents an [Every] with a [DateValidator].
  const EveryDateValidator();
}
