import 'package:due_date/src/date_validators/date_validator_weekday.dart';
import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/everies/adapters/limited_every_skip_count_adapter.dart';
import 'package:due_date/src/everies/built_in/every_weekday.dart';
import 'package:due_date/src/everies/date_direction.dart';
import 'package:due_date/src/everies/date_time_limit_reached_exception.dart';
import 'package:test/test.dart';

import '../../src/date_time_match.dart';
import '../../src/every_match.dart';

void main() {
  group('LimitedEverySkipCountAdapter:', () {
    final every = Weekday.monday.every;
    final validator = DateValidatorWeekday(Weekday.monday);

    group('Constructor', () {
      group('Unnamed', () {
        test('Valid basic case', () {
          expect(
            LimitedEverySkipCountAdapter(
              every: every,
              validator: validator,
              count: 1,
            ),
            isNotNull,
          );
        });
        test('Can be created as constant', () {
          const adapter = LimitedEverySkipCountAdapter(
            every: EveryWeekday(Weekday.monday),
            validator: DateValidatorWeekday(Weekday.monday),
            count: 1,
          );
          expect(adapter, isNotNull);
        });
        test('Creates with correct every', () {
          final adapter = LimitedEverySkipCountAdapter(
            every: every,
            validator: validator,
            count: 1,
          );
          expect(adapter.every, equals(every));
        });
        test('Creates with correct validator', () {
          final adapter = LimitedEverySkipCountAdapter(
            every: every,
            validator: validator,
            count: 1,
          );
          expect(adapter.validator, equals(validator));
        });
        test('Creates with correct count', () {
          final adapter = LimitedEverySkipCountAdapter(
            every: every,
            validator: validator,
            count: 2,
          );
          expect(adapter.count, equals(2));
        });
        group('asserts limits', () {
          test('Count cannot be negative', () {
            expect(
              () => LimitedEverySkipCountAdapter(
                every: every,
                validator: validator,
                count: -1,
              ),
              throwsA(isA<AssertionError>()),
            );
          });
        });
      });
    });

    group('Methods', () {
      group('Skip count 0', () {
        final adapter = LimitedEverySkipCountAdapter(
          every: every,
          validator: validator,
          count: 0,
        );

        group('startDate', () {
          test('Returns same date when input is valid', () {
            // July 1, 2024 is Monday.
            final validDate = DateTime(2024, 7);
            expect(adapter, startsAtSameDate.withInput(validDate));
          });
          test('Returns next valid date when input is invalid', () {
            // July 2, 2024 is Tuesday.
            final invalidDate = DateTime(2024, 7, 2);
            // July 8, 2024 is Monday.
            final expected = DateTime(2024, 7, 8);
            expect(adapter, startsAt(expected).withInput(invalidDate));
          });
          test('Accepts limit parameter', () {
            // July 1, 2024 is Monday.
            final validDate = DateTime(2024, 7);
            // July 31, 2024 is Wednesday.
            final limit = DateTime(2024, 7, 31);
            final result = adapter.startDate(validDate, limit: limit);
            expect(result, isNotNull);
          });
        });

        group('next', () {
          test('Always generates date after input', () {
            // July 1, 2024 is Monday.
            final validDate = DateTime(2024, 7);
            expect(adapter, nextIsAfter.withInput(validDate));
          });
          test('Generates next occurrence from valid date', () {
            // July 1, 2024 is Monday.
            final validDate = DateTime(2024, 7);
            // July 8, 2024 is Monday.
            final expected = DateTime(2024, 7, 8);
            expect(adapter, hasNext(expected).withInput(validDate));
          });
          test('Accepts limit parameter', () {
            // July 1, 2024 is Monday.
            final validDate = DateTime(2024, 7);
            // July 31, 2024 is Wednesday.
            final limit = DateTime(2024, 7, 31);
            final result = adapter.next(validDate, limit: limit);
            expect(result, isNotNull);
          });
        });

        group('previous', () {
          test('Always generates date before input', () {
            // July 8, 2024 is Monday.
            final validDate = DateTime(2024, 7, 8);
            expect(adapter, previousIsBefore.withInput(validDate));
          });
          test('Generates previous occurrence from valid date', () {
            // July 8, 2024 is Monday.
            final validDate = DateTime(2024, 7, 8);
            // July 1, 2024 is Monday.
            final expected = DateTime(2024, 7);
            expect(adapter, hasPrevious(expected).withInput(validDate));
          });
          test('Accepts limit parameter', () {
            // July 8, 2024 is Monday.
            final validDate = DateTime(2024, 7, 8);
            // June 1, 2024 is Saturday.
            final limit = DateTime(2024, 6);
            final result = adapter.previous(validDate, limit: limit);
            expect(result, isNotNull);
          });
        });

        group('endDate', () {
          test('Returns same date when input is valid', () {
            // July 1, 2024 is Monday.
            final validDate = DateTime(2024, 7);
            expect(adapter, endsAtSameDate.withInput(validDate));
          });
          test('Returns previous valid date when input is invalid', () {
            // July 2, 2024 is Tuesday.
            final invalidDate = DateTime(2024, 7, 2);
            // July 1, 2024 is Monday.
            final expected = DateTime(2024, 7);
            expect(adapter, endsAt(expected).withInput(invalidDate));
          });
          test('Accepts limit parameter', () {
            // July 1, 2024 is Monday.
            final validDate = DateTime(2024, 7);
            // June 1, 2024 is Saturday.
            final limit = DateTime(2024, 6);
            final result = adapter.endDate(validDate, limit: limit);
            expect(result, isNotNull);
          });
        });
      });

      group('Skip count 1', () {
        final adapter = LimitedEverySkipCountAdapter(
          every: every,
          validator: validator,
          count: 1,
        );

        group('next', () {
          test('Skips one occurrence', () {
            // July 1, 2024 is Monday.
            final validDate = DateTime(2024, 7);
            // July 15, 2024 is Monday (skips July 8).
            final expected = DateTime(2024, 7, 15);
            expect(adapter, hasNext(expected).withInput(validDate));
          });
          test('Accepts limit parameter', () {
            // July 1, 2024 is Monday.
            final validDate = DateTime(2024, 7);
            // July 31, 2024 is Wednesday.
            final limit = DateTime(2024, 7, 31);
            final result = adapter.next(validDate, limit: limit);
            expect(result, isNotNull);
          });
        });

        group('previous', () {
          test('Skips one occurrence', () {
            // July 15, 2024 is Monday.
            final validDate = DateTime(2024, 7, 15);
            // July 1, 2024 is Monday (skips July 8).
            final expected = DateTime(2024, 7);
            expect(adapter, hasPrevious(expected).withInput(validDate));
          });
          test('Accepts limit parameter', () {
            // July 15, 2024 is Monday.
            final validDate = DateTime(2024, 7, 15);
            // June 1, 2024 is Saturday.
            final limit = DateTime(2024, 6);
            final result = adapter.previous(validDate, limit: limit);
            expect(result, isNotNull);
          });
        });
      });

      group('Skip count 2', () {
        final adapter = LimitedEverySkipCountAdapter(
          every: every,
          validator: validator,
          count: 2,
        );

        group('next', () {
          test('Skips two occurrences', () {
            // July 1, 2024 is Monday.
            final validDate = DateTime(2024, 7);
            // July 22, 2024 is Monday (skips July 8 and July 15).
            final expected = DateTime(2024, 7, 22);
            expect(adapter, hasNext(expected).withInput(validDate));
          });
        });

        group('previous', () {
          test('Skips two occurrences', () {
            // July 22, 2024 is Monday.
            final validDate = DateTime(2024, 7, 22);
            // July 1, 2024 is Monday (skips July 15 and July 8).
            final expected = DateTime(2024, 7);
            expect(adapter, hasPrevious(expected).withInput(validDate));
          });
        });
      });

      group('valid', () {
        final adapter = LimitedEverySkipCountAdapter(
          every: every,
          validator: validator,
          count: 1,
        );

        test('Returns true when date is valid and currentCount is 0', () {
          // July 1, 2024 is Monday.
          final validDate = DateTime(2024, 7);
          final result = adapter.valid(validDate, currentCount: 0);
          expect(result, isTrue);
        });
        test('Returns false when currentCount is greater than 0', () {
          // July 1, 2024 is Monday.
          final validDate = DateTime(2024, 7);
          final result = adapter.valid(validDate, currentCount: 1);
          expect(result, isFalse);
        });
        test('Returns false when date is invalid', () {
          // July 2, 2024 is Tuesday.
          final invalidDate = DateTime(2024, 7, 2);
          final result = adapter.valid(invalidDate, currentCount: 0);
          expect(result, isFalse);
        });
        test('Throws assertion error when currentCount is negative', () {
          // July 1, 2024 is Monday.
          final validDate = DateTime(2024, 7);
          expect(
            () => adapter.valid(validDate, currentCount: -1),
            throwsA(isA<AssertionError>()),
          );
        });
      });

      group('processDate', () {
        final adapter = LimitedEverySkipCountAdapter(
          every: every,
          validator: validator,
          count: 1,
        );

        test('Returns date when currentCount is 0', () {
          // July 1, 2024 is Monday.
          final date = DateTime(2024, 7);
          final result = adapter.processDate(
            date,
            DateDirection.next,
            currentCount: 0,
          );
          expect(result, isSameDateTime(date));
        });
        test('Accepts limit parameter', () {
          // July 1, 2024 is Monday.
          final date = DateTime(2024, 7);
          // July 31, 2024 is Wednesday.
          final limit = DateTime(2024, 7, 31);
          final result = adapter.processDate(
            date,
            DateDirection.next,
            limit: limit,
            currentCount: 1,
          );
          expect(result, isNotNull);
        });
      });
    });

    group('Limit handling:', () {
      final adapter = LimitedEverySkipCountAdapter(
        every: every,
        validator: validator,
        count: 1,
      );

      test('Throws when limit is reached in next', () {
        // July 1, 2024 is Monday.
        final inputDate = DateTime(2024, 7);
        // July 2, 2024 is Tuesday (before expected result).
        final limitDate = DateTime(2024, 7, 2);
        expect(
          () => adapter.next(inputDate, limit: limitDate),
          throwsA(isA<DateTimeLimitReachedException>()),
        );
      });

      test('Throws when limit is reached in previous', () {
        // July 15, 2024 is Monday.
        final inputDate = DateTime(2024, 7, 15);
        // July 10, 2024 is Wednesday (after expected result).
        final limitDate = DateTime(2024, 7, 10);
        expect(
          () => adapter.previous(inputDate, limit: limitDate),
          throwsA(isA<DateTimeLimitReachedException>()),
        );
      });
    });

    group('Equality', () {
      final adapter1 = LimitedEverySkipCountAdapter(
        every: every,
        validator: validator,
        count: 1,
      );
      final adapter2 = LimitedEverySkipCountAdapter(
        every: every,
        validator: validator,
        count: 1,
      );
      final adapter3 = LimitedEverySkipCountAdapter(
        every: every,
        validator: validator,
        count: 2,
      );

      test('Same properties are equal', () {
        expect(adapter1, equals(adapter2));
      });
      test('Different count are not equal', () {
        expect(adapter1, isNot(equals(adapter3)));
      });
      test('hashCode is consistent', () {
        expect(adapter1.hashCode, equals(adapter2.hashCode));
      });
    });
  });
}
