import '../date_validators/date_validators.dart';
import 'every_date_validator.dart';

/// Mixin that represents a list of [EveryDateValidator].
mixin EveryDateValidatorListMixin<E extends EveryDateValidator>
    on DateValidatorListMixin<E> {
  /// List for all of the [everies] that will be used to generate the date.
  List<EveryDateValidator> get everies => [...this];
}
