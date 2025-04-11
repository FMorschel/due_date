import 'package:due_date/specific_exports/date_validators.dart';
import 'package:test/test.dart';

Matcher isValid(DateTime date) => _ValidDateValidator(date);
Matcher isInvalid(DateTime date) => _InvalidDateValidator(date);

abstract class _DateValidatorMatch extends Matcher {
  const _DateValidatorMatch(this._expected);

  final DateTime _expected;

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    if (item is! DateValidator) return false;
    return _fromDateValidator(item);
  }

  bool _fromDateValidator(DateValidator validator);
}

class _ValidDateValidator extends _DateValidatorMatch {
  const _ValidDateValidator(super.date);

  @override
  Description describe(Description description) =>
      description.add('$_expected is valid');

  @override
  bool _fromDateValidator(DateValidator validator) =>
      validator.valid(_expected);

  @override
  Description describeMismatch(
    Object? item,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) {
    if (item is DateValidator) {
      return mismatchDescription.replace('$_expected is not valid for $item');
    }
    return mismatchDescription.replace('$item is not a DateValidator');
  }
}

class _InvalidDateValidator extends _DateValidatorMatch {
  const _InvalidDateValidator(super.date);

  @override
  Description describe(Description description) =>
      description.add('is invalid');

  @override
  bool _fromDateValidator(DateValidator validator) =>
      validator.invalid(_expected);

  @override
  Description describeMismatch(
    Object? item,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) {
    if (item is DateValidator) {
      return mismatchDescription.add('$_expected is not valid for $item');
    }
    return mismatchDescription.add('$item is not a DateValidator');
  }
}
