import 'package:due_date/src/date_validators/built_in/date_validator_weekday_count_in_month.dart';
import 'package:due_date/src/enums/week.dart';
import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/everies/adapters/limited_every_override_adapter.dart';
import 'package:due_date/src/everies/built_in/every_weekday.dart';
import 'package:due_date/src/everies/date_time_limit_reached_exception.dart';
import 'package:test/test.dart';

import '../../src/date_time_match.dart';
import '../../src/every_match.dart';

void main() {
  group('LimitedEveryOverrideAdapter:', () {
    final every = Weekday.monday.every;
    const invalidator = DateValidatorWeekdayCountInMonth(
      week: Week.first,
      day: Weekday.monday,
    );
    final adapter = LimitedEveryOverrideAdapter(
      every: every,
      validator: invalidator,
      overrider: Weekday.tuesday.every,
    );

    group('Constructor', () {
      group('Unnamed', () {
        test('Valid basic case', () {
          expect(adapter, isNotNull);
        });
        test('Can be created as constant', () {
          const constAdapter = LimitedEveryOverrideAdapter(
            every: EveryWeekday(Weekday.monday),
            validator: DateValidatorWeekdayCountInMonth(
              week: Week.first,
              day: Weekday.monday,
            ),
            overrider: EveryWeekday(Weekday.tuesday),
          );
          expect(constAdapter, isNotNull);
        });
        test('Creates with correct every', () {
          expect(adapter.every, equals(every));
        });
        test('Creates with correct validator', () {
          expect(adapter.validator, equals(invalidator));
        });
        test('Creates with correct overrider', () {
          expect(adapter.overrider, equals(Weekday.tuesday.every));
        });
      });
    });

    group('Methods', () {
      group('startDate', () {
        test('Generates same date from valid date', () {
          // October 10, 2022 is Monday.
          final validDate = DateTime(2022, DateTime.october, 10);
          expect(adapter, startsAtSameDate.withInput(validDate));
        });
        test('Generates next occurrence from invalid date', () {
          // September 27, 2022 is Tuesday.
          final invalidDate = DateTime(2022, DateTime.september, 27);
          expect(adapter, startsAtNext.withInput(invalidDate));
        });
        test('Accepts limit parameter', () {
          // October 10, 2022 is Monday.
          final validDate = DateTime(2022, DateTime.october, 10);
          // October 31, 2022 is Monday.
          final limit = DateTime(2022, DateTime.october, 31);
          final result = adapter.startDate(validDate, limit: limit);
          expect(result, isNotNull);
        });
      });

      group('next', () {
        test('Always generates date after input', () {
          // October 4, 2022 is Tuesday.
          final validDate = DateTime(2022, DateTime.october, 4);
          expect(adapter, nextIsAfter.withInput(validDate));
        });
        test('Generates next occurrence from valid date', () {
          // October 4, 2022 is Tuesday.
          final validDate = DateTime(2022, DateTime.october, 4);
          // October 10, 2022 is Monday.
          final expected = DateTime(2022, DateTime.october, 10);
          expect(adapter, hasNext(expected).withInput(validDate));
        });
        test('Generates next occurrence from invalid date', () {
          // September 27, 2022 is Tuesday.
          final invalidDate = DateTime(2022, DateTime.september, 27);
          // October 4, 2022 is Tuesday.
          final expected = DateTime(2022, DateTime.october, 4);
          expect(adapter, hasNext(expected).withInput(invalidDate));
        });
        test('Accepts limit parameter', () {
          // October 4, 2022 is Tuesday.
          final validDate = DateTime(2022, DateTime.october, 4);
          // October 31, 2022 is Monday.
          final limit = DateTime(2022, DateTime.october, 31);
          final result = adapter.next(validDate, limit: limit);
          expect(result, isNotNull);
        });
      });

      group('previous', () {
        test('Always generates date before input', () {
          // October 4, 2022 is Tuesday.
          final validDate = DateTime(2022, DateTime.october, 4);
          expect(adapter, previousIsBefore.withInput(validDate));
        });
        test('Generates previous occurrence from valid date', () {
          // October 4, 2022 is Tuesday.
          final validDate = DateTime(2022, DateTime.october, 4);
          // September 27, 2022 is Tuesday.
          final expected = DateTime(2022, DateTime.september, 27);
          expect(adapter, hasPrevious(expected).withInput(validDate));
        });
        test('Generates previous occurrence from invalid date', () {
          // September 27, 2022 is Tuesday.
          final invalidDate = DateTime(2022, DateTime.september, 27);
          // September 26, 2022 is Monday.
          final expected = DateTime(2022, DateTime.september, 26);
          expect(adapter, hasPrevious(expected).withInput(invalidDate));
        });
        test('Accepts limit parameter', () {
          // October 4, 2022 is Tuesday.
          final validDate = DateTime(2022, DateTime.october, 4);
          // September 1, 2022 is Thursday.
          final limit = DateTime(2022, DateTime.september);
          final result = adapter.previous(validDate, limit: limit);
          expect(result, isNotNull);
        });
      });

      group('endDate', () {
        test('Generates same date from valid date', () {
          // October 10, 2022 is Monday.
          final validDate = DateTime(2022, DateTime.october, 10);
          expect(adapter, endsAtSameDate.withInput(validDate));
        });
        test('Generates previous occurrence from invalid date', () {
          // September 27, 2022 is Tuesday.
          final invalidDate = DateTime(2022, DateTime.september, 27);
          expect(adapter, endsAtPrevious.withInput(invalidDate));
        });
        test('Accepts limit parameter', () {
          // October 10, 2022 is Monday.
          final validDate = DateTime(2022, DateTime.october, 10);
          // September 1, 2022 is Thursday.
          final limit = DateTime(2022, DateTime.september);
          final result = adapter.endDate(validDate, limit: limit);
          expect(result, isNotNull);
        });
      });
    });

    group('Override behavior:', () {
      test('Override first Monday with Tuesday', () {
        // December 3, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 3);
        // December 5, 2023 is Tuesday (overriding first Monday).
        final expectedDate = DateTime(2023, 12, 5);
        expect(adapter, hasNext(expectedDate).withInput(inputDate));
      });

      test('Previous calculation with override', () {
        // December 10, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 10);
        // November 28, 2023 is Tuesday.
        final expectedDate = DateTime(2023, 11, 28);
        expect(adapter, hasPrevious(expectedDate).withInput(inputDate));
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
        // November 29, 2023 is after expected previous date.
        final limitDate = DateTime(2023, 11, 29);
        expect(
          () => adapter.previous(inputDate, limit: limitDate),
          throwsA(isA<DateTimeLimitReachedException>()),
        );
      });

      test('Works when limit is exactly the expected date', () {
        // December 3, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 3);
        // December 5, 2023 is Tuesday.
        final expectedDate = DateTime(2023, 12, 5);
        final result = adapter.next(inputDate, limit: expectedDate);
        expect(result, isSameDateTime(expectedDate));
      });
    });

    group('Equality', () {
      final adapter1 = LimitedEveryOverrideAdapter(
        every: every,
        validator: invalidator,
        overrider: Weekday.tuesday.every,
      );
      final adapter2 = LimitedEveryOverrideAdapter(
        every: every,
        validator: invalidator,
        overrider: Weekday.tuesday.every,
      );
      final adapter3 = LimitedEveryOverrideAdapter(
        every: every,
        validator: invalidator,
        overrider: Weekday.wednesday.every,
      );

      test('Same properties are equal', () {
        expect(adapter1, equals(adapter2));
      });
      test('Different overrider are not equal', () {
        expect(adapter1, isNot(equals(adapter3)));
      });
      test('hashCode is consistent', () {
        expect(adapter1.hashCode, equals(adapter2.hashCode));
      });
    });
  });
}
