import 'package:due_date/src/date_validators/date_validator.dart';
import 'package:due_date/src/date_validators/date_validator_weekday.dart';
import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/everies/adapters/limited_every_adapter.dart';
import 'package:due_date/src/everies/built_in/every_weekday.dart';
import 'package:due_date/src/everies/date_direction.dart';
import 'package:due_date/src/everies/every.dart';
import 'package:test/test.dart';

/// Test implementation of [LimitedEveryAdapter] that can be made constant.
class _TestLimitedEveryAdapter
    extends LimitedEveryAdapter<Every, DateValidator> {
  /// Creates a test implementation of [LimitedEveryAdapter].
  const _TestLimitedEveryAdapter({
    required super.every,
    required super.validator,
  });

  @override
  DateTime processDate(
    DateTime date,
    DateDirection direction, {
    DateTime? limit,
  }) =>
      date;

  @override
  bool valid(DateTime date) => validator.valid(date);

  @override
  DateTime startDate(DateTime date, {DateTime? limit}) => date;

  @override
  DateTime next(DateTime date, {DateTime? limit}) => date;

  @override
  DateTime previous(DateTime date, {DateTime? limit}) => date;

  @override
  DateTime endDate(DateTime date, {DateTime? limit}) => date;

  @override
  void throwIfLimitReached(
    DateTime date,
    DateDirection direction, {
    required DateTime? limit,
  }) {}
}

void main() {
  group('LimitedEveryAdapter:', () {
    group('Constructor', () {
      test('Can be created as constant', () {
        const adapter = _TestLimitedEveryAdapter(
          every: EveryWeekday(Weekday.monday),
          validator: DateValidatorWeekday(Weekday.monday),
        );
        expect(adapter, isNotNull);
        expect(adapter.runtimeType, equals(_TestLimitedEveryAdapter));
      });
      test('Properties are set correctly', () {
        final every = EveryWeekday(Weekday.monday);
        final validator = DateValidatorWeekday(Weekday.monday);
        final adapter = _TestLimitedEveryAdapter(
          every: every,
          validator: validator,
        );
        expect(adapter.every, equals(every));
        expect(adapter.validator, equals(validator));
      });
    });
  });
}
