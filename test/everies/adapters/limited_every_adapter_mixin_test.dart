import 'package:due_date/src/date_validators/date_validator.dart';
import 'package:due_date/src/date_validators/date_validator_mixin.dart';
import 'package:due_date/src/date_validators/date_validator_weekday.dart';
import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/everies/adapters/limited_every_adapter.dart';
import 'package:due_date/src/everies/adapters/limited_every_adapter_mixin.dart';
import 'package:due_date/src/everies/built_in/every_weekday.dart';
import 'package:due_date/src/everies/date_direction.dart';
import 'package:due_date/src/everies/every.dart';
import 'package:test/test.dart';

/// Test implementation of [LimitedEveryAdapter] with [LimitedEveryAdapterMixin].
class _TestLimitedEveryAdapter extends LimitedEveryAdapter<Every, DateValidator>
    with DateValidatorMixin, LimitedEveryAdapterMixin<Every, DateValidator> {
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
}

void main() {
  group('LimitedEveryAdapterMixin:', () {
    final every = EveryWeekday(Weekday.monday);
    final validator = DateValidatorWeekday(Weekday.monday);
    final adapter =
        _TestLimitedEveryAdapter(every: every, validator: validator);

    group('Constructor', () {
      test('Can be created as constant', () {
        const constAdapter = _TestLimitedEveryAdapter(
          every: EveryWeekday(Weekday.monday),
          validator: DateValidatorWeekday(Weekday.monday),
        );
        expect(constAdapter, isNotNull);
        expect(constAdapter.runtimeType, equals(_TestLimitedEveryAdapter));
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
        test('Accepts limit parameter', () {
          // July 1, 2024 is Monday.
          final date = DateTime(2024, 7);
          // July 31, 2024 is Wednesday.
          final limit = DateTime(2024, 7, 31);
          final result = adapter.startDate(date, limit: limit);
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
        test('Accepts limit parameter', () {
          // July 1, 2024 is Monday.
          final date = DateTime(2024, 7);
          // July 31, 2024 is Wednesday.
          final limit = DateTime(2024, 7, 31);
          final result = adapter.next(date, limit: limit);
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
        test('Accepts limit parameter', () {
          // July 1, 2024 is Monday.
          final date = DateTime(2024, 7);
          // June 1, 2024 is Saturday.
          final limit = DateTime(2024, 6);
          final result = adapter.previous(date, limit: limit);
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
        test('Accepts limit parameter', () {
          // July 1, 2024 is Monday.
          final date = DateTime(2024, 7);
          // June 1, 2024 is Saturday.
          final limit = DateTime(2024, 6);
          final result = adapter.endDate(date, limit: limit);
          expect(result, isNotNull);
        });
      });

      group('throwIfLimitReached', () {
        test('Does not throw when limit is null', () {
          // July 1, 2024 is Monday.
          final date = DateTime(2024, 7);
          expect(
            () => adapter.throwIfLimitReached(
              date,
              DateDirection.next,
              limit: null,
            ),
            returnsNormally,
          );
        });
      });
    });
  });
}
