import 'package:due_date/src/date_validators/date_validator_opposite.dart';
import 'package:due_date/src/everies/every_due_day_month.dart';
import 'package:test/test.dart';

class DateValidatorOppositeTest extends DateValidatorOpposite {
  const DateValidatorOppositeTest(super._validator);
}

void main() {
  group('DateValidatorOpposite', () {
    const validator = EveryDueDayMonth(1);
    const oppositeValidator = DateValidatorOppositeTest(validator);
    test('negating the validator returns the original one', () {
      expect(-oppositeValidator, equals(validator));
    });
  });
}
