import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/everies/date_time_limit_reached_exception.dart';
import 'package:due_date/src/everies/modifiers/date_direction.dart';
import 'package:due_date/src/everies/modifiers/every_skip_count_wrapper.dart';
import 'package:test/test.dart';

import '../../src/date_time_match.dart';
import '../../src/every_match.dart';

void main() {
  group('EverySkipCountWrapper:', () {
    final every = Weekday.monday.every;
    final wrapper = EverySkipCountWrapper(every: every, count: 1);

    group('Constructor', () {
      group('Unnamed', () {
        test('Valid basic case', () {
          expect(EverySkipCountWrapper(every: every, count: 1), isNotNull);
        });
        test('Creates with correct every', () {
          expect(wrapper.every, equals(every));
        });
        test('Creates with correct count', () {
          expect(wrapper.count, equals(1));
        });
        group('asserts limits', () {
          test('count cannot be negative', () {
            expect(
              () => EverySkipCountWrapper(every: every, count: -1),
              throwsA(isA<AssertionError>()),
            );
          });
        });
      });
    });

    group('Methods', () {
      group('next', () {
        test('Always generates date after input', () {
          // December 11, 2023 is Monday.
          final validDate = DateTime(2023, 12, 11);
          expect(wrapper, nextIsAfter.withInput(validDate));
        });
        test('Generates next occurrence from valid date', () {
          // December 11, 2023 is Monday.
          final validDate = DateTime(2023, 12, 11);
          // December 25, 2023 is Monday (skip count 1).
          final expected = DateTime(2023, 12, 25);
          expect(wrapper, hasNext(expected).withInput(validDate));
        });
        test('Generates next occurrence from invalid date', () {
          // December 3, 2023 is Sunday.
          final invalidDate = DateTime(2023, 12, 3);
          // December 11, 2023 is Monday (skip count 1).
          final expected = DateTime(2023, 12, 11);
          expect(wrapper, hasNext(expected).withInput(invalidDate));
        });
      });

      group('previous', () {
        test('Always generates date before input', () {
          // December 11, 2023 is Monday.
          final validDate = DateTime(2023, 12, 11);
          expect(wrapper, previousIsBefore.withInput(validDate));
        });
        test('Generates previous occurrence from valid date', () {
          // December 11, 2023 is Monday.
          final validDate = DateTime(2023, 12, 11);
          // November 27, 2023 is Monday (skip count 1).
          final expected = DateTime(2023, 11, 27);
          expect(wrapper, hasPrevious(expected).withInput(validDate));
        });
        test('Generates previous occurrence from invalid date', () {
          // December 10, 2023 is Sunday.
          final invalidDate = DateTime(2023, 12, 10);
          // November 27, 2023 is Monday (skip count 1).
          final expected = DateTime(2023, 11, 27);
          expect(wrapper, hasPrevious(expected).withInput(invalidDate));
        });
      });
    });

    group('Skip count behavior:', () {
      group('Count 0', () {
        final wrapperCount0 = EverySkipCountWrapper(every: every, count: 0);

        test('Acts like regular every with count 0', () {
          // September 27, 2022 is Tuesday.
          final inputDate = DateTime(2022, DateTime.september, 27);
          // October 3, 2022 is Monday (next Monday).
          final expected = DateTime(2022, DateTime.october, 3);
          expect(wrapperCount0, hasNext(expected).withInput(inputDate));
        });

        test('Next from valid date with count 0', () {
          // October 3, 2022 is Monday.
          final validDate = DateTime(2022, DateTime.october, 3);
          // October 10, 2022 is Monday (next Monday).
          final expected = DateTime(2022, DateTime.october, 10);
          expect(wrapperCount0, hasNext(expected).withInput(validDate));
        });
      });

      group('Count 1', () {
        final wrapperCount1 = EverySkipCountWrapper(every: every, count: 1);

        test('Skips one occurrence with count 1', () {
          // September 27, 2022 is Tuesday.
          final inputDate = DateTime(2022, DateTime.september, 27);
          // October 10, 2022 is Monday (skip October 3).
          final expected = DateTime(2022, DateTime.october, 10);
          expect(wrapperCount1, hasNext(expected).withInput(inputDate));
        });

        test('Next from valid date with count 1', () {
          // October 3, 2022 is Monday.
          final validDate = DateTime(2022, DateTime.october, 3);
          // October 17, 2022 is Monday (skip October 10).
          final expected = DateTime(2022, DateTime.october, 17);
          expect(wrapperCount1, hasNext(expected).withInput(validDate));
        });

        test('Previous with count 1', () {
          // October 3, 2022 is Monday.
          final validDate = DateTime(2022, DateTime.october, 3);
          // September 19, 2022 is Monday (skip September 26).
          final expected = DateTime(2022, DateTime.september, 19);
          expect(wrapperCount1, hasPrevious(expected).withInput(validDate));
        });
      });
    });

    group('Explicit datetime tests:', () {
      test('Skip count 1 calculation', () {
        // December 3, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 3);
        // December 11, 2023 is Monday (skip December 4).
        final expectedDate = DateTime(2023, 12, 11);
        expect(wrapper, hasNext(expectedDate).withInput(inputDate));
      });

      test('Previous calculation with skip count', () {
        // December 10, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 10);
        // November 27, 2023 is Monday (skip December 4).
        final expectedDate = DateTime(2023, 11, 27);
        expect(wrapper, hasPrevious(expectedDate).withInput(inputDate));
      });

      test('Edge case: limit reached in next', () {
        // December 3, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 3);
        // December 1, 2023 is before input date.
        final limitDate = DateTime(2023, 12);
        expect(
          () => wrapper.next(inputDate, limit: limitDate),
          throwsA(isA<DateTimeLimitReachedException>()),
        );
      });

      test('Edge case: limit reached in previous', () {
        // December 10, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 10);
        // November 29, 2023 is after expected previous date.
        final limitDate = DateTime(2023, 11, 29);
        expect(
          () => wrapper.previous(inputDate, limit: limitDate),
          throwsA(isA<DateTimeLimitReachedException>()),
        );
      });

      test('Limit is exactly the expected date', () {
        // December 3, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 3);
        // December 11, 2023 is Monday.
        final expectedDate = DateTime(2023, 12, 11);
        expect(
          wrapper,
          hasNext(expectedDate).withInput(inputDate, limit: expectedDate),
        );
      });
    });

    group('Time component preservation:', () {
      test('Maintains time components in local DateTime', () {
        final inputWithTime = DateTime(2023, 12, 3, 14, 30, 45, 123, 456);
        final result = wrapper.next(inputWithTime);

        // Should preserve time components.
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
        expect(result, isLocalDateTime);
      });

      test('Maintains time components in UTC DateTime', () {
        final inputWithTime = DateTime.utc(2023, 12, 3, 14, 30, 45, 123, 456);
        final result = wrapper.next(inputWithTime);

        // Should preserve time components and UTC flag.
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
        expect(result, isUtcDateTime);
      });

      test('Previous maintains time components in local DateTime', () {
        final inputWithTime = DateTime(2023, 12, 10, 9, 15, 30, 500, 250);
        final result = wrapper.previous(inputWithTime);

        // Should preserve time components.
        expect(result.hour, equals(9));
        expect(result.minute, equals(15));
        expect(result.second, equals(30));
        expect(result.millisecond, equals(500));
        expect(result.microsecond, equals(250));
        expect(result, isLocalDateTime);
      });

      test('Previous maintains time components in UTC DateTime', () {
        final inputWithTime = DateTime.utc(2023, 12, 10, 9, 15, 30, 500, 250);
        final result = wrapper.previous(inputWithTime);

        // Should preserve time components and UTC flag.
        expect(result.hour, equals(9));
        expect(result.minute, equals(15));
        expect(result.second, equals(30));
        expect(result.millisecond, equals(500));
        expect(result.microsecond, equals(250));
        expect(result, isUtcDateTime);
      });

      test('Normal generation with date-only input (local)', () {
        final inputDate = DateTime(2023, 12, 3);
        final expected = DateTime(2023, 12, 11);
        expect(wrapper, hasNext(expected).withInput(inputDate));
      });

      test('Normal generation with date-only input (UTC)', () {
        final inputDate = DateTime.utc(2023, 12, 3);
        final expected = DateTime.utc(2023, 12, 11);
        expect(wrapper, hasNext(expected).withInput(inputDate));
      });
    });

    group('Edge Cases', () {
      test('Limit validation in next', () {
        // December 3, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 3);
        // December 12, 2023 is after expected date.
        final limitDate = DateTime(2023, 12, 12);
        final expectedDate = DateTime(2023, 12, 11);
        expect(
          wrapper,
          hasNext(expectedDate).withInput(inputDate, limit: limitDate),
        );
      });

      test('Limit validation in previous', () {
        // December 10, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 10);
        // November 26, 2023 is before expected date.
        final limitDate = DateTime(2023, 11, 26);
        final expectedDate = DateTime(2023, 11, 27);
        expect(
          wrapper,
          hasPrevious(expectedDate).withInput(inputDate, limit: limitDate),
        );
      });

      test('Count 0 behaves like regular every', () {
        final wrapperCount0 = EverySkipCountWrapper(every: every, count: 0);
        // December 3, 2023 is Sunday.
        final inputDate = DateTime(2023, 12, 3);
        // December 4, 2023 is Monday (no skip).
        final expected = DateTime(2023, 12, 4);
        expect(wrapperCount0, hasNext(expected).withInput(inputDate));
      });
    });

    group('Equality', () {
      final wrapper1 = EverySkipCountWrapper(every: every, count: 1);
      final wrapper2 = EverySkipCountWrapper(every: every, count: 2);
      final wrapper3 = EverySkipCountWrapper(
        every: Weekday.tuesday.every,
        count: 1,
      );
      final wrapper4 = EverySkipCountWrapper(every: every, count: 1);

      test('Same instance', () {
        expect(wrapper1, equals(wrapper1));
      });
      test('Same every, different count', () {
        expect(wrapper1, isNot(equals(wrapper2)));
      });
      test('Different every, same count', () {
        expect(wrapper1, isNot(equals(wrapper3)));
      });
      test('Same every, same count', () {
        expect(wrapper1, equals(wrapper4));
      });
    });

    group('processDate method:', () {
      test('processDate with null currentCount defaults to count (next)', () {
        // December 4, 2023 is Monday (first Monday).
        final firstMonday = DateTime(2023, 12, 4);
        // December 11, 2023 is Monday (skip December 4).
        final expected = DateTime(2023, 12, 11);

        final result = wrapper.processDate(
          firstMonday,
          DateDirection.next,
        );
        expect(result, equals(expected));
      });

      test('processDate with null currentCount defaults to count (start)', () {
        // December 4, 2023 is Monday (first Monday).
        final firstMonday = DateTime(2023, 12, 4);
        // December 11, 2023 is Monday (skip December 4).
        final expected = DateTime(2023, 12, 11);

        final result = wrapper.processDate(
          firstMonday,
          DateDirection.start,
        );
        expect(result, equals(expected));
      });

      test('processDate with null currentCount defaults to count (previous)',
          () {
        // December 4, 2023 is Monday (first Monday).
        final firstMonday = DateTime(2023, 12, 4);
        // November 27, 2023 is Monday (skip November 20).
        final expected = DateTime(2023, 11, 27);

        final result = wrapper.processDate(
          firstMonday,
          DateDirection.previous,
        );
        expect(result, equals(expected));
      });

      test('processDate with currentCount 0 returns input date', () {
        // December 4, 2023 is Monday.
        final inputDate = DateTime(2023, 12, 4);

        final result = wrapper.processDate(
          inputDate,
          DateDirection.next,
          currentCount: 0,
        );
        expect(result, equals(inputDate));
      });

      test('processDate with explicit currentCount overrides default', () {
        // December 4, 2023 is Monday.
        final inputDate = DateTime(2023, 12, 4);
        // December 18, 2023 is Monday (skip December 11).
        final expected = DateTime(2023, 12, 18);

        final result = wrapper.processDate(
          inputDate,
          DateDirection.next,
          currentCount: 2,
        );
        expect(result, equals(expected));
      });

      test('processDate start direction with explicit currentCount', () {
        // December 4, 2023 is Monday.
        final inputDate = DateTime(2023, 12, 4);
        // December 18, 2023 is Monday (skip December 11).
        final expected = DateTime(2023, 12, 18);

        final result = wrapper.processDate(
          inputDate,
          DateDirection.start,
          currentCount: 2,
        );
        expect(result, equals(expected));
      });

      test('processDate with limit validation (next)', () {
        // December 4, 2023 is Monday.
        final inputDate = DateTime(2023, 12, 4);
        // December 10, 2023 is before expected date.
        final limitDate = DateTime(2023, 12, 10);

        expect(
          () => wrapper.processDate(
            inputDate,
            DateDirection.next,
            limit: limitDate,
          ),
          throwsA(isA<DateTimeLimitReachedException>()),
        );
      });

      test('processDate with limit validation (start)', () {
        // December 4, 2023 is Monday.
        final inputDate = DateTime(2023, 12, 4);
        // December 10, 2023 is before expected date.
        final limitDate = DateTime(2023, 12, 10);

        expect(
          () => wrapper.processDate(
            inputDate,
            DateDirection.start,
            limit: limitDate,
          ),
          throwsA(isA<DateTimeLimitReachedException>()),
        );
      });

      test('processDate with limit validation (previous)', () {
        // December 4, 2023 is Monday.
        final inputDate = DateTime(2023, 12, 4);
        // November 28, 2023 is after expected date.
        final limitDate = DateTime(2023, 11, 28);

        expect(
          () => wrapper.processDate(
            inputDate,
            DateDirection.previous,
            limit: limitDate,
          ),
          throwsA(isA<DateTimeLimitReachedException>()),
        );
      });
    });
  });
}
