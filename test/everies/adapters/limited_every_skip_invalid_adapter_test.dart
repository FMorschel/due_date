import 'package:due_date/src/date_validators/date_validator_weekday_count_in_month.dart';
import 'package:due_date/src/enums/week.dart';
import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/everies/adapters/limited_every_skip_invalid_adapter.dart';
import 'package:due_date/src/everies/built_in/every_weekday.dart';
import 'package:due_date/src/everies/date_time_limit_reached_exception.dart';
import 'package:test/test.dart';

import '../../src/every_match.dart';

void main() {
  group('LimitedEverySkipInvalidAdapter:', () {
    final every = Weekday.monday.every;
    const invalidator = DateValidatorWeekdayCountInMonth(
      week: Week.first,
      day: Weekday.monday,
    );
    final adapter = LimitedEverySkipInvalidAdapter(
      every: every,
      validator: invalidator,
    );

    group('Constructor', () {
      group('Unnamed', () {
        test('Valid basic case', () {
          expect(
            LimitedEverySkipInvalidAdapter(
              every: every,
              validator: invalidator,
            ),
            isNotNull,
          );
        });
        test('Can be created as constant', () {
          const constAdapter = LimitedEverySkipInvalidAdapter(
            every: EveryWeekday(Weekday.monday),
            validator: DateValidatorWeekdayCountInMonth(
              week: Week.first,
              day: Weekday.monday,
            ),
          );
          expect(constAdapter, isNotNull);
        });
        test('Creates with correct every', () {
          expect(adapter.every, equals(every));
        });
        test('Creates with correct validator', () {
          expect(adapter.validator, equals(invalidator));
        });
      });
    });

    group('Methods', () {
      group('startDate', () {
        test('Returns same date when input is valid', () {
          // October 10, 2022 is Monday (not first Monday).
          final validDate = DateTime(2022, DateTime.october, 10);
          expect(adapter, startsAtSameDate.withInput(validDate));
        });
        test('Returns next valid date when input is invalid', () {
          // October 7, 2022 is Friday.
          final invalidDate = DateTime(2022, DateTime.october, 7);
          // October 10, 2022 is Monday (not first Monday).
          final expected = DateTime(2022, DateTime.october, 10);
          expect(adapter, startsAt(expected).withInput(invalidDate));
        });
        test('Accepts limit parameter', () {
          // October 10, 2022 is Monday (not first Monday).
          final validDate = DateTime(2022, DateTime.october, 10);
          // October 31, 2022 is Monday.
          final limit = DateTime(2022, DateTime.october, 31);
          final result = adapter.startDate(validDate, limit: limit);
          expect(result, isNotNull);
        });
      });

      group('next', () {
        test('Always generates date after input', () {
          // October 10, 2022 is Monday (not first Monday).
          final validDate = DateTime(2022, DateTime.october, 10);
          expect(adapter, nextIsAfter.withInput(validDate));
        });
        test('Generates next occurrence from valid date', () {
          // October 10, 2022 is Monday (not first Monday).
          final validDate = DateTime(2022, DateTime.october, 10);
          // October 17, 2022 is Monday (not first Monday).
          final expected = DateTime(2022, DateTime.october, 17);
          expect(adapter, hasNext(expected).withInput(validDate));
        });
        test('Generates next occurrence from invalid date', () {
          // October 7, 2022 is Friday.
          final invalidDate = DateTime(2022, DateTime.october, 7);
          // October 10, 2022 is Monday (not first Monday).
          final expected = DateTime(2022, DateTime.october, 10);
          expect(adapter, hasNext(expected).withInput(invalidDate));
        });
        test('Accepts limit parameter', () {
          // October 10, 2022 is Monday (not first Monday).
          final validDate = DateTime(2022, DateTime.october, 10);
          // October 31, 2022 is Monday.
          final limit = DateTime(2022, DateTime.october, 31);
          final result = adapter.next(validDate, limit: limit);
          expect(result, isNotNull);
        });
      });

      group('previous', () {
        test('Always generates date before input', () {
          // October 10, 2022 is Monday (not first Monday).
          final validDate = DateTime(2022, DateTime.october, 10);
          expect(adapter, previousIsBefore.withInput(validDate));
        });
        test('Generates previous occurrence from valid date', () {
          // October 10, 2022 is Monday (not first Monday).
          final validDate = DateTime(2022, DateTime.october, 10);
          // September 26, 2022 is Monday (not first Monday).
          final expected = DateTime(2022, DateTime.september, 26);
          expect(adapter, hasPrevious(expected).withInput(validDate));
        });
        test('Generates previous occurrence from invalid date', () {
          // October 7, 2022 is Friday.
          final invalidDate = DateTime(2022, DateTime.october, 7);
          // September 26, 2022 is Monday (not first Monday).
          final expected = DateTime(2022, DateTime.september, 26);
          expect(adapter, hasPrevious(expected).withInput(invalidDate));
        });
        test('Accepts limit parameter', () {
          // October 10, 2022 is Monday (not first Monday).
          final validDate = DateTime(2022, DateTime.october, 10);
          // September 1, 2022 is Thursday.
          final limit = DateTime(2022, DateTime.september);
          final result = adapter.previous(validDate, limit: limit);
          expect(result, isNotNull);
        });
      });

      group('endDate', () {
        test('Returns same date when input is valid', () {
          // October 10, 2022 is Monday (not first Monday).
          final validDate = DateTime(2022, DateTime.october, 10);
          expect(adapter, endsAtSameDate.withInput(validDate));
        });
        test('Returns previous valid date when input is invalid', () {
          // October 7, 2022 is Friday.
          final invalidDate = DateTime(2022, DateTime.october, 7);
          // October 3, 2022 is Monday (first Monday, so skip to September 26).
          final expected = DateTime(2022, DateTime.september, 26);
          expect(adapter, endsAt(expected).withInput(invalidDate));
        });
        test('Accepts limit parameter', () {
          // October 10, 2022 is Monday (not first Monday).
          final validDate = DateTime(2022, DateTime.october, 10);
          // September 1, 2022 is Thursday.
          final limit = DateTime(2022, DateTime.september);
          final result = adapter.endDate(validDate, limit: limit);
          expect(result, isNotNull);
        });
      });

      group('valid', () {
        test('Returns true when date is valid', () {
          // December 11, 2023 is Monday (not first Monday).
          final validDate = DateTime(2023, 12, 11);
          final result = adapter.valid(validDate);
          expect(result, isTrue);
        });
        test('Returns false when date is invalid because of invalidator', () {
          // December 4, 2023 is first Monday (invalidated).
          final invalidDate = DateTime(2023, 12, 4);
          final result = adapter.valid(invalidDate);
          expect(result, isFalse);
        });
        test('Returns false when date is invalid because of every', () {
          // December 3, 2023 is Sunday (not Monday).
          final invalidDate = DateTime(2023, 12, 3);
          final result = adapter.valid(invalidDate);
          expect(result, isFalse);
        });
      });

      group('invalid', () {
        test('Returns false when date is valid', () {
          // December 11, 2023 is Monday (not first Monday).
          final validDate = DateTime(2023, 12, 11);
          final result = adapter.invalid(validDate);
          expect(result, isFalse);
        });
        test('Returns true when date is invalid because of invalidator', () {
          // December 4, 2023 is first Monday (invalidated).
          final invalidDate = DateTime(2023, 12, 4);
          final result = adapter.invalid(invalidDate);
          expect(result, isTrue);
        });
        test('Returns true when date is invalid because of every', () {
          // December 3, 2023 is Sunday (not Monday).
          final invalidDate = DateTime(2023, 12, 3);
          final result = adapter.invalid(invalidDate);
          expect(result, isTrue);
        });
      });
    });

    group('Skip invalid behavior:', () {
      test('Skips first Monday of month', () {
        // December 3, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 3);
        // December 11, 2023 is Monday (skips December 4, first Monday).
        final expected = DateTime(2023, 12, 11);
        expect(adapter, hasNext(expected).withInput(inputDate));
      });

      test('Normal Monday generation when not first Monday', () {
        // December 10, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 10);
        // December 11, 2023 is Monday (not first Monday).
        final expected = DateTime(2023, 12, 11);
        expect(adapter, hasNext(expected).withInput(inputDate));
      });

      test('Previous skips first Monday of month', () {
        // December 10, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 10);
        // November 27, 2023 is Monday (skips December 4, first Monday).
        final expected = DateTime(2023, 11, 27);
        expect(adapter, hasPrevious(expected).withInput(inputDate));
      });
    });

    group('Limit handling:', () {
      test('Throws when limit is reached in next', () {
        // December 3, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 3);
        // December 1, 2023 is before input date.
        final limitDate = DateTime(2023, 12);
        expect(
          () => adapter.next(inputDate, limit: limitDate),
          throwsA(isA<DateTimeLimitReachedException>()),
        );
      });

      test('Throws when limit is reached in previous', () {
        // December 10, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 10);
        // November 28, 2023 is after expected previous date.
        final limitDate = DateTime(2023, 11, 28);
        expect(
          () => adapter.previous(inputDate, limit: limitDate),
          throwsA(isA<DateTimeLimitReachedException>()),
        );
      });
    });

    group('Equality', () {
      final adapter1 = LimitedEverySkipInvalidAdapter(
        every: every,
        validator: invalidator,
      );
      final adapter2 = LimitedEverySkipInvalidAdapter(
        every: every,
        validator: invalidator,
      );
      const differentInvalidator = DateValidatorWeekdayCountInMonth(
        week: Week.last,
        day: Weekday.monday,
      );
      final adapter3 = LimitedEverySkipInvalidAdapter(
        every: every,
        validator: differentInvalidator,
      );

      test('Same properties are equal', () {
        expect(adapter1, equals(adapter2));
      });
      test('Different validator are not equal', () {
        expect(adapter1, isNot(equals(adapter3)));
      });
      test('hashCode is consistent', () {
        expect(adapter1.hashCode, equals(adapter2.hashCode));
      });
    });
  });
}
