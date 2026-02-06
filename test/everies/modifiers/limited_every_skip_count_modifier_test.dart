import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/everies/built_in/every_weekday.dart';
import 'package:due_date/src/everies/date_direction.dart';
import 'package:due_date/src/everies/date_time_limit_reached_exception.dart';
import 'package:due_date/src/everies/modifiers/limited_every_skip_count_modifier.dart';
import 'package:test/test.dart';

import '../../src/every_match.dart';

void main() {
  group('LimitedEverySkipCountModifier:', () {
    const every = EveryWeekday(Weekday.monday);

    group('Constructor', () {
      group('Unnamed', () {
        test('Valid basic case', () {
          expect(
            LimitedEverySkipCountModifier(every: every, count: 1),
            isNotNull,
          );
        });
        test('Can be created as constant', () {
          const modifier = LimitedEverySkipCountModifier(
            every: EveryWeekday(Weekday.monday),
            count: 1,
          );
          expect(modifier, isNotNull);
        });
        test('Creates with correct every', () {
          final modifier =
              LimitedEverySkipCountModifier(every: every, count: 1);
          expect(modifier.every, equals(every));
        });
        test('Creates with correct count', () {
          final modifier =
              LimitedEverySkipCountModifier(every: every, count: 2);
          expect(modifier.count, equals(2));
        });
        group('asserts limits', () {
          test('Count cannot be negative', () {
            expect(
              () => LimitedEverySkipCountModifier(every: every, count: -1),
              throwsA(isA<AssertionError>()),
            );
          });
        });
      });
    });

    group('Methods', () {
      group('Skip count 0', () {
        final modifier = LimitedEverySkipCountModifier(every: every, count: 0);

        group('startDate', () {
          test('Returns same date when input is valid', () {
            // December 11, 2023 is Monday.
            final validDate = DateTime(2023, 12, 11);
            expect(modifier, startsAtSameDate.withInput(validDate));
          });
          test('Returns next valid date when input is invalid', () {
            // December 3, 2023 is Sunday.
            final invalidDate = DateTime(2023, 12, 3);
            // December 4, 2023 is Monday.
            final expected = DateTime(2023, 12, 4);
            expect(modifier, startsAt(expected).withInput(invalidDate));
          });
        });

        group('next', () {
          test('Always generates date after input', () {
            // December 11, 2023 is Monday.
            final validDate = DateTime(2023, 12, 11);
            expect(modifier, nextIsAfter.withInput(validDate));
          });
          test('Generates next occurrence without skipping', () {
            // December 11, 2023 is Monday.
            final validDate = DateTime(2023, 12, 11);
            // December 18, 2023 is Monday.
            final expected = DateTime(2023, 12, 18);
            expect(modifier, hasNext(expected).withInput(validDate));
          });
        });

        group('previous', () {
          test('Always generates date before input', () {
            // December 11, 2023 is Monday.
            final validDate = DateTime(2023, 12, 11);
            expect(modifier, previousIsBefore.withInput(validDate));
          });
          test('Generates previous occurrence without skipping', () {
            // December 11, 2023 is Monday.
            final validDate = DateTime(2023, 12, 11);
            // December 4, 2023 is Monday.
            final expected = DateTime(2023, 12, 4);
            expect(modifier, hasPrevious(expected).withInput(validDate));
          });
        });

        group('endDate', () {
          test('Returns same date when input is valid', () {
            // December 11, 2023 is Monday.
            final validDate = DateTime(2023, 12, 11);
            expect(modifier, endsAtSameDate.withInput(validDate));
          });
          test('Returns previous valid date when input is invalid', () {
            // December 10, 2023 is Sunday.
            final invalidDate = DateTime(2023, 12, 10);
            // December 4, 2023 is Monday.
            final expected = DateTime(2023, 12, 4);
            expect(modifier, endsAt(expected).withInput(invalidDate));
          });
        });
      });

      group('Skip count 1', () {
        final modifier = LimitedEverySkipCountModifier(every: every, count: 1);

        group('next', () {
          test('Skips one occurrence from valid date', () {
            // December 11, 2023 is Monday.
            final validDate = DateTime(2023, 12, 11);
            // December 25, 2023 is Monday (skips December 18).
            final expected = DateTime(2023, 12, 25);
            expect(modifier, hasNext(expected).withInput(validDate));
          });
          test('Skips one occurrence from invalid date', () {
            // December 3, 2023 is Sunday.
            final invalidDate = DateTime(2023, 12, 3);
            // December 11, 2023 is Monday (skips December 4).
            final expected = DateTime(2023, 12, 11);
            expect(modifier, hasNext(expected).withInput(invalidDate));
          });
        });

        group('previous', () {
          test('Skips one occurrence from valid date', () {
            // December 11, 2023 is Monday.
            final validDate = DateTime(2023, 12, 11);
            // November 27, 2023 is Monday (skips December 4).
            final expected = DateTime(2023, 11, 27);
            expect(modifier, hasPrevious(expected).withInput(validDate));
          });
          test('Skips one occurrence from invalid date', () {
            // December 10, 2023 is Sunday.
            final invalidDate = DateTime(2023, 12, 10);
            // November 27, 2023 is Monday (skips December 4).
            final expected = DateTime(2023, 11, 27);
            expect(modifier, hasPrevious(expected).withInput(invalidDate));
          });
        });
      });

      group('Skip count 2', () {
        final modifier = LimitedEverySkipCountModifier(every: every, count: 2);

        group('next', () {
          test('Skips two occurrences', () {
            // December 11, 2023 is Monday.
            final validDate = DateTime(2023, 12, 11);
            // January 1, 2024 is Monday (skips December 18 and 25).
            final expected = DateTime(2024);
            expect(modifier, hasNext(expected).withInput(validDate));
          });
        });

        group('previous', () {
          test('Skips two occurrences', () {
            // December 11, 2023 is Monday.
            final validDate = DateTime(2023, 12, 11);
            // November 20, 2023 is Monday (skips December 4 and November 27).
            final expected = DateTime(2023, 11, 20);
            expect(modifier, hasPrevious(expected).withInput(validDate));
          });
        });
      });

      group('Limit handling', () {
        final modifier = LimitedEverySkipCountModifier(every: every, count: 1);

        test('Accepts limit parameter in next', () {
          // December 11, 2023 is Monday.
          final validDate = DateTime(2023, 12, 11);
          // December 26, 2023 is after December 25.
          final limit = DateTime(2023, 12, 26);
          final result = modifier.next(validDate, limit: limit);
          expect(result, isNotNull);
        });

        test('Throws when limit is reached in next', () {
          // December 11, 2023 is Monday.
          final validDate = DateTime(2023, 12, 11);
          // December 20, 2023 is before December 25.
          final limit = DateTime(2023, 12, 20);
          expect(
            () => modifier.next(validDate, limit: limit),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });

        test('Accepts limit parameter in previous', () {
          // December 11, 2023 is Monday.
          final validDate = DateTime(2023, 12, 11);
          // November 26, 2023 is before November 27.
          final limit = DateTime(2023, 11, 26);
          final result = modifier.previous(validDate, limit: limit);
          expect(result, isNotNull);
        });

        test('Throws when limit is reached in previous', () {
          // December 11, 2023 is Monday.
          final validDate = DateTime(2023, 12, 11);
          // November 28, 2023 is after November 27.
          final limit = DateTime(2023, 11, 28);
          expect(
            () => modifier.previous(validDate, limit: limit),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });

        test('Limit exactly equals expected date in next', () {
          // December 11, 2023 is Monday.
          final validDate = DateTime(2023, 12, 11);
          // December 25, 2023 is Monday.
          final limit = DateTime(2023, 12, 25);
          final result = modifier.next(validDate, limit: limit);
          expect(result, equals(limit));
        });

        test('Limit exactly equals expected date in previous', () {
          // December 11, 2023 is Monday.
          final validDate = DateTime(2023, 12, 11);
          // November 27, 2023 is Monday.
          final limit = DateTime(2023, 11, 27);
          final result = modifier.previous(validDate, limit: limit);
          expect(result, equals(limit));
        });
      });

      group('processDate', () {
        final modifier = LimitedEverySkipCountModifier(every: every, count: 2);

        test('Uses default count when currentCount is not provided', () {
          // December 11, 2023 is Monday.
          final inputDate = DateTime(2023, 12, 11);
          // December 25, 2023 is Monday (skips 2 ahead).
          final expected = DateTime(2023, 12, 25);
          final result = modifier.processDate(
            inputDate,
            DateDirection.next,
          );
          expect(result, equals(expected));
        });

        test('Returns input date when currentCount is 0', () {
          // December 11, 2023 is Monday.
          final inputDate = DateTime(2023, 12, 11);
          final result = modifier.processDate(
            inputDate,
            DateDirection.next,
            currentCount: 0,
          );
          expect(result, equals(inputDate));
        });

        test('Recursively skips in forward direction with currentCount > 0',
            () {
          // December 11, 2023 is Monday.
          final inputDate = DateTime(2023, 12, 11);
          // December 18, 2023 is Monday (one iteration from input).
          final expected = DateTime(2023, 12, 18);
          final result = modifier.processDate(
            inputDate,
            DateDirection.next,
            currentCount: 1,
          );
          expect(result, equals(expected));
        });

        test('Recursively skips in backward direction with currentCount > 0',
            () {
          // December 11, 2023 is Monday.
          final inputDate = DateTime(2023, 12, 11);
          // December 4, 2023 is Monday (one iteration backward).
          final expected = DateTime(2023, 12, 4);
          final result = modifier.processDate(
            inputDate,
            DateDirection.previous,
            currentCount: 1,
          );
          expect(result, equals(expected));
        });

        test('Respects limit in forward direction', () {
          // December 11, 2023 is Monday.
          final inputDate = DateTime(2023, 12, 11);
          // December 19, 2023 is after December 18.
          final limit = DateTime(2023, 12, 19);
          final result = modifier.processDate(
            inputDate,
            DateDirection.next,
            currentCount: 1,
            limit: limit,
          );
          expect(result, isNotNull);
        });

        test('Throws when limit is reached in forward direction', () {
          // December 11, 2023 is Monday.
          final inputDate = DateTime(2023, 12, 11);
          // December 15, 2023 is before December 18.
          final limit = DateTime(2023, 12, 15);
          expect(
            () => modifier.processDate(
              inputDate,
              DateDirection.next,
              limit: limit,
              currentCount: 1,
            ),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });

        test('Throws when limit is reached in backward direction', () {
          // December 11, 2023 is Monday.
          final inputDate = DateTime(2023, 12, 11);
          // December 5, 2023 is after December 4.
          final limit = DateTime(2023, 12, 5);
          expect(
            () => modifier.processDate(
              inputDate,
              DateDirection.previous,
              limit: limit,
              currentCount: 1,
            ),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });
      });

      group('next with currentCount parameter', () {
        final modifier = LimitedEverySkipCountModifier(every: every, count: 2);

        test('Uses default count when currentCount is null', () {
          // December 11, 2023 is Monday.
          final inputDate = DateTime(2023, 12, 11);
          // January 1, 2024 is Monday (skips 2).
          final expected = DateTime(2024);
          expect(modifier.next(inputDate), equals(expected));
        });

        test('Uses explicit currentCount parameter', () {
          // December 11, 2023 is Monday.
          final inputDate = DateTime(2023, 12, 11);
          // December 25, 2023 is Monday (skips 1).
          final expected = DateTime(2023, 12, 25);
          expect(modifier.next(inputDate, currentCount: 1), equals(expected));
        });
      });

      group('previous with currentCount parameter', () {
        final modifier = LimitedEverySkipCountModifier(every: every, count: 2);

        test('Uses default count when currentCount is null', () {
          // December 11, 2023 is Monday.
          final inputDate = DateTime(2023, 12, 11);
          // November 20, 2023 is Monday (skips 2).
          final expected = DateTime(2023, 11, 20);
          expect(modifier.previous(inputDate), equals(expected));
        });

        test('Uses explicit currentCount parameter', () {
          // December 11, 2023 is Monday.
          final inputDate = DateTime(2023, 12, 11);
          // November 27, 2023 is Monday (skips 1).
          final expected = DateTime(2023, 11, 27);
          expect(
            modifier.previous(inputDate, currentCount: 1),
            equals(expected),
          );
        });
      });

      group('valid', () {
        final modifier = LimitedEverySkipCountModifier(every: every, count: 1);

        test('Returns true when date is valid and currentCount is 0', () {
          // December 11, 2023 is Monday.
          final validDate = DateTime(2023, 12, 11);
          final result = modifier.valid(validDate, currentCount: 0);
          expect(result, isTrue);
        });
        test('Returns true when date is valid and currentCount is null', () {
          // December 11, 2023 is Monday.
          final validDate = DateTime(2023, 12, 11);
          final result = modifier.valid(validDate);
          expect(result, isTrue);
        });
        test('Returns false when currentCount is greater than 0', () {
          // December 11, 2023 is Monday.
          final validDate = DateTime(2023, 12, 11);
          final result = modifier.valid(validDate, currentCount: 1);
          expect(result, isFalse);
        });
        test('Returns false when date is invalid', () {
          // December 10, 2023 is Sunday.
          final invalidDate = DateTime(2023, 12, 10);
          final result = modifier.valid(invalidDate);
          expect(result, isFalse);
        });
      });
    });

    group('Equality', () {
      final modifier1 = LimitedEverySkipCountModifier(every: every, count: 1);
      final modifier2 = LimitedEverySkipCountModifier(every: every, count: 1);
      final modifier3 = LimitedEverySkipCountModifier(every: every, count: 2);
      const differentEvery = EveryWeekday(Weekday.tuesday);
      final modifier4 =
          LimitedEverySkipCountModifier(every: differentEvery, count: 1);

      test('Same instance', () {
        expect(modifier1, equals(modifier1));
      });
      test('Same properties are equal', () {
        expect(modifier1, equals(modifier2));
      });
      test('Different count are not equal', () {
        expect(modifier1, isNot(equals(modifier3)));
      });
      test('Different every are not equal', () {
        expect(modifier1, isNot(equals(modifier4)));
      });
      test('hashCode is consistent', () {
        expect(modifier1.hashCode, equals(modifier2.hashCode));
      });
    });
  });
}
