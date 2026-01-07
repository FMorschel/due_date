import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import 'date_validator.dart';
import 'date_validator_list_mixin.dart';
import 'date_validator_mixin.dart';

/// A [DateValidator] that validates a [DateTime] if the date is valid for all
/// of the [validators].
class DateValidatorIntersection<E extends DateValidator>
    extends DelegatingList<E>
    with EquatableMixin, DateValidatorMixin, DateValidatorListMixin {
  /// A [DateValidator] that validates a [DateTime] if the date is valid for all
  /// of the [validators].
  const DateValidatorIntersection(super.base);

  @override
  bool valid(DateTime date) {
    return validators.every((validator) => validator.valid(date));
  }

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is DateValidatorIntersection) &&
            (other.validators == validators));
  }

  @override
  List<Object> get props => [...this];
}
