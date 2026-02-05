import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../date_validator.dart';
import 'date_validator_list_mixin.dart';
import '../date_validator_mixin.dart';

/// A [DateValidator] that validates a [DateTime] if the date is valid for only
/// one of the [validators].
class DateValidatorDifference<E extends DateValidator> extends DelegatingList<E>
    with EquatableMixin, DateValidatorMixin, DateValidatorListMixin {
  /// A [DateValidator] that validates a [DateTime] if the date is valid for
  /// only one of the [validators].
  const DateValidatorDifference(super.base);

  @override
  bool valid(DateTime date) {
    var validCount = 0;
    for (final validator in validators) {
      if (validator.valid(date)) validCount++;
      if (validCount > 1) return false;
    }
    if (validCount == 0) return false;
    return true;
  }

  @override
  bool invalid(DateTime date) {
    var validCount = 0;
    for (final validator in validators) {
      if (validator.valid(date)) validCount++;
      if (validCount > 1) return true;
    }
    if (validCount == 0) return true;
    return false;
  }

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is DateValidatorDifference) &&
            (other.validators == validators));
  }

  @override
  List<Object> get props => [...this];
}
