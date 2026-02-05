import 'package:due_date/src/date_validators/date_validator.dart';
import 'package:due_date/src/date_validators/built_in/date_validator_weekday.dart';
import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/everies/adapters/every_adapter.dart';
import 'package:due_date/src/everies/adapters/every_adapter_mixin.dart';
import 'package:due_date/src/everies/built_in/every_weekday.dart';
import 'package:due_date/src/everies/date_direction.dart';
import 'package:due_date/src/everies/every.dart';
import 'package:test/test.dart';

/// Test implementation of [EveryAdapter] with [EveryAdapterMixin].
class _TestEveryAdapter extends EveryAdapter<Every, DateValidator>
    with EveryAdapterMixin<Every, DateValidator> {
  /// Creates a test implementation of [EveryAdapter].
  const _TestEveryAdapter({
    required super.every,
    required super.validator,
  });

  @override
  DateTime processDate(DateTime date, DateDirection direction) => date;

  @override
  bool valid(DateTime date) => validator.valid(date);
}

void main() {
  group('EveryAdapterMixin:', () {
    final every = EveryWeekday(Weekday.monday);
    final validator = DateValidatorWeekday(Weekday.monday);
    final adapter = _TestEveryAdapter(every: every, validator: validator);

    group('Constructor', () {
      test('Can be created as constant', () {
        const constAdapter = _TestEveryAdapter(
          every: EveryWeekday(Weekday.monday),
          validator: DateValidatorWeekday(Weekday.monday),
        );
        expect(constAdapter, isNotNull);
        expect(constAdapter.runtimeType, equals(_TestEveryAdapter));
      });
      test('Properties are set correctly', () {
        expect(adapter.every, equals(every));
        expect(adapter.validator, equals(validator));
      });
    });

    group('Methods', () {
      group('startDate', () {
        test('Returns date from processDate', () {
          // July 1, 2024 is Monday.
          final date = DateTime(2024, 7);
          final result = adapter.startDate(date);
          expect(result, isNotNull);
        });
      });

      group('next', () {
        test('Returns date from processDate', () {
          // July 1, 2024 is Monday.
          final date = DateTime(2024, 7);
          final result = adapter.next(date);
          expect(result, isNotNull);
        });
      });

      group('previous', () {
        test('Returns date from processDate', () {
          // July 1, 2024 is Monday.
          final date = DateTime(2024, 7);
          final result = adapter.previous(date);
          expect(result, isNotNull);
        });
      });

      group('endDate', () {
        test('Returns date from processDate', () {
          // July 1, 2024 is Monday.
          final date = DateTime(2024, 7);
          final result = adapter.endDate(date);
          expect(result, isNotNull);
        });
      });
    });
  });
}
