import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../date_validator.dart';
import '../date_validator_mixin.dart';
import 'date_validator_list_mixin.dart';

/// A [DateValidator] that validates a [DateTime] if the date is valid for any
/// of the [validators].
class DateValidatorUnion<E extends DateValidator> extends DelegatingList<E>
    with EquatableMixin, DateValidatorMixin, DateValidatorListMixin {
  /// A [DateValidator] that validates a [DateTime] if the date is valid for any
  /// of the [validators].
  const DateValidatorUnion(super.base);

  @override
  bool valid(DateTime date) {
    return validators.any((validator) => validator.valid(date));
  }

  @override
  // ignore: hash_and_equals, already implemented by EquatableMixin
  bool operator ==(Object other) {
    return (super == other) ||
        ((other is DateValidatorUnion) && (other.validators == validators));
  }

  @override
  List<Object> get props => [...this];
}
