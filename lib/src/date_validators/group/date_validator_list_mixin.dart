import '../date_validator.dart';

/// Mixin that represents a list of [DateValidator]s.
mixin DateValidatorListMixin<E extends DateValidator> on List<E>
    implements DateValidator {
  /// List for all of the [validators] that will be used to validate the date.
  List<DateValidator> get validators => [...this];
}
