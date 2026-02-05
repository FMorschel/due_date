import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/everies/built_in/every_weekday.dart';
import 'package:due_date/src/everies/date_direction.dart';
import 'package:due_date/src/everies/wrappers/every_skip_count_wrapper.dart';
import 'package:test/test.dart';

import '../../src/every_match.dart';

void main() {
  group('EverySkipCountWrapper:', () {
    final every = Weekday.monday.every;

    group('Constructor', () {
      group('Unnamed', () {
        test('Valid basic case', () {
          expect(
            EverySkipCountWrapper(every: every, count: 1),
            isNotNull,
          );
        });
        test('Can be created as constant', () {
          const wrapper = EverySkipCountWrapper(
            every: EveryWeekday(Weekday.monday),
            count: 1,
          );
          expect(wrapper, isNotNull);
        });
        test('Creates with correct every', () {
          final wrapper = EverySkipCountWrapper(every: every, count: 1);
          expect(wrapper.every, equals(every));
        });
        test('Creates with correct count', () {
          final wrapper = EverySkipCountWrapper(every: every, count: 2);
          expect(wrapper.count, equals(2));
        });
        group('asserts limits', () {
          test('Count cannot be negative', () {
            expect(
              () => EverySkipCountWrapper(every: every, count: -1),
              throwsA(isA<AssertionError>()),
            );
          });
        });
      });
    });

    group('Methods', () {
      group('Skip count 0', () {
        final wrapper = EverySkipCountWrapper(every: every, count: 0);

        group('next', () {
          test('Always generates date after input', () {
            // December 11, 2023 is Monday.
            final validDate = DateTime(2023, 12, 11);
            expect(wrapper, nextIsAfter.withInput(validDate));
          });
          test('Generates next occurrence without skipping', () {
            // December 11, 2023 is Monday.
            final validDate = DateTime(2023, 12, 11);
            // December 18, 2023 is Monday.
            final expected = DateTime(2023, 12, 18);
            expect(wrapper, hasNext(expected).withInput(validDate));
          });
        });

        group('previous', () {
          test('Always generates date before input', () {
            // December 11, 2023 is Monday.
            final validDate = DateTime(2023, 12, 11);
            expect(wrapper, previousIsBefore.withInput(validDate));
          });
          test('Generates previous occurrence without skipping', () {
            // December 11, 2023 is Monday.
            final validDate = DateTime(2023, 12, 11);
            // December 4, 2023 is Monday.
            final expected = DateTime(2023, 12, 4);
            expect(wrapper, hasPrevious(expected).withInput(validDate));
          });
        });
      });

      group('Skip count 1', () {
        final wrapper = EverySkipCountWrapper(every: every, count: 1);

        group('next', () {
          test('Skips one occurrence from valid date', () {
            // December 11, 2023 is Monday.
            final validDate = DateTime(2023, 12, 11);
            // December 25, 2023 is Monday (skips December 18).
            final expected = DateTime(2023, 12, 25);
            expect(wrapper, hasNext(expected).withInput(validDate));
          });
          test('Skips one occurrence from invalid date', () {
            // December 3, 2023 is Sunday.
            final invalidDate = DateTime(2023, 12, 3);
            // December 11, 2023 is Monday (skips December 4).
            final expected = DateTime(2023, 12, 11);
            expect(wrapper, hasNext(expected).withInput(invalidDate));
          });
        });

        group('previous', () {
          test('Skips one occurrence from valid date', () {
            // December 11, 2023 is Monday.
            final validDate = DateTime(2023, 12, 11);
            // November 27, 2023 is Monday (skips December 4).
            final expected = DateTime(2023, 11, 27);
            expect(wrapper, hasPrevious(expected).withInput(validDate));
          });
          test('Skips one occurrence from invalid date', () {
            // December 10, 2023 is Sunday.
            final invalidDate = DateTime(2023, 12, 10);
            // November 27, 2023 is Monday (skips December 4).
            final expected = DateTime(2023, 11, 27);
            expect(wrapper, hasPrevious(expected).withInput(invalidDate));
          });
        });
      });

      group('Skip count 2', () {
        final wrapper = EverySkipCountWrapper(every: every, count: 2);

        group('next', () {
          test('Skips two occurrences', () {
            // December 11, 2023 is Monday.
            final validDate = DateTime(2023, 12, 11);
            // January 1, 2024 is Monday (skips December 18 and 25).
            final expected = DateTime(2024);
            expect(wrapper, hasNext(expected).withInput(validDate));
          });
        });

        group('previous', () {
          test('Skips two occurrences', () {
            // December 11, 2023 is Monday.
            final validDate = DateTime(2023, 12, 11);
            // November 20, 2023 is Monday (skips December 4 and November 27).
            final expected = DateTime(2023, 11, 20);
            expect(wrapper, hasPrevious(expected).withInput(validDate));
          });
        });
      });

      group('processDate', () {
        final wrapper = EverySkipCountWrapper(every: every, count: 2);

        test('Returns input date when currentCount is 0', () {
          // December 11, 2023 is Monday.
          final inputDate = DateTime(2023, 12, 11);
          final result = wrapper.processDate(
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
          final result = wrapper.processDate(
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
          final result = wrapper.processDate(
            inputDate,
            DateDirection.previous,
            currentCount: 1,
          );
          expect(result, equals(expected));
        });
      });

      group('next with currentCount parameter', () {
        final wrapper = EverySkipCountWrapper(every: every, count: 2);

        test('Uses default count when currentCount is null', () {
          // December 11, 2023 is Monday.
          final inputDate = DateTime(2023, 12, 11);
          // January 1, 2024 is Monday (skips 2).
          final expected = DateTime(2024);
          expect(wrapper.next(inputDate), equals(expected));
        });

        test('Uses explicit currentCount parameter', () {
          // December 11, 2023 is Monday.
          final inputDate = DateTime(2023, 12, 11);
          // December 25, 2023 is Monday (skips 1).
          final expected = DateTime(2023, 12, 25);
          expect(wrapper.next(inputDate, currentCount: 1), equals(expected));
        });
      });

      group('previous with currentCount parameter', () {
        final wrapper = EverySkipCountWrapper(every: every, count: 2);

        test('Uses default count when currentCount is null', () {
          // December 11, 2023 is Monday.
          final inputDate = DateTime(2023, 12, 11);
          // November 20, 2023 is Monday (skips 2).
          final expected = DateTime(2023, 11, 20);
          expect(wrapper.previous(inputDate), equals(expected));
        });

        test('Uses explicit currentCount parameter', () {
          // December 11, 2023 is Monday.
          final inputDate = DateTime(2023, 12, 11);
          // November 27, 2023 is Monday (skips 1).
          final expected = DateTime(2023, 11, 27);
          expect(
            wrapper.previous(inputDate, currentCount: 1),
            equals(expected),
          );
        });
      });
    });

    group('Equality', () {
      final wrapper1 = EverySkipCountWrapper(every: every, count: 1);
      final wrapper2 = EverySkipCountWrapper(every: every, count: 1);
      final wrapper3 = EverySkipCountWrapper(every: every, count: 2);
      final wrapper4 = EverySkipCountWrapper(
        every: Weekday.tuesday.every,
        count: 1,
      );

      test('Same instance', () {
        expect(wrapper1, equals(wrapper1));
      });
      test('Same properties are equal', () {
        expect(wrapper1, equals(wrapper2));
      });
      test('Different count are not equal', () {
        expect(wrapper1, isNot(equals(wrapper3)));
      });
      test('Different every are not equal', () {
        expect(wrapper1, isNot(equals(wrapper4)));
      });
      test('hashCode is consistent', () {
        expect(wrapper1.hashCode, equals(wrapper2.hashCode));
      });
    });
  });
}
