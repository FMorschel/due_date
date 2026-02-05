import 'package:due_date/src/everies/built_in/every_due_day_month.dart';
import 'package:due_date/src/everies/built_in/every_due_time_of_day.dart';
import 'package:due_date/src/everies/date_direction.dart';
import 'package:due_date/src/everies/date_time_limit_reached_exception.dart';
import 'package:due_date/src/everies/wrappers/limited_every_time_of_day_wrapper.dart';
import 'package:test/test.dart';

import '../../src/every_match.dart';

void main() {
  group('LimitedEveryTimeOfDayWrapper:', () {
    const every = EveryDueDayMonth(1);

    group('Constructor', () {
      group('Unnamed', () {
        test('Valid basic case', () {
          expect(
            LimitedEveryTimeOfDayWrapper(every: every),
            isNotNull,
          );
        });
        test('Can be created as constant', () {
          const wrapper = LimitedEveryTimeOfDayWrapper(
            every: EveryDueDayMonth(1),
          );
          expect(wrapper, isNotNull);
        });
        test('Creates with correct every', () {
          final wrapper = LimitedEveryTimeOfDayWrapper(every: every);
          expect(wrapper.every, equals(every));
        });
        test('Default everyTimeOfDay is midnight', () {
          final wrapper = LimitedEveryTimeOfDayWrapper(every: every);
          expect(wrapper.everyTimeOfDay, equals(EveryDueTimeOfDay.midnight));
        });
        test('Creates with custom everyTimeOfDay', () {
          const customTime =
              EveryDueTimeOfDay(Duration(hours: 14, minutes: 30));
          final wrapper = LimitedEveryTimeOfDayWrapper(
            every: every,
            everyTimeOfDay: customTime,
          );
          expect(wrapper.everyTimeOfDay, equals(customTime));
        });
      });
    });

    group('Methods', () {
      group('Default midnight', () {
        final wrapper = LimitedEveryTimeOfDayWrapper(every: every);

        group('next', () {
          test('Always generates date after input', () {
            // January 1, 2024 at 00:00.
            final inputDate = DateTime(2024);
            expect(wrapper, nextIsAfter.withInput(inputDate));
          });
          test('Generates next occurrence at midnight', () {
            // January 1, 2024 at 00:00.
            final inputDate = DateTime(2024);
            // February 1, 2024 at 00:00.
            final expected = DateTime(2024, 2);
            expect(wrapper, hasNext(expected).withInput(inputDate));
          });
          test('Generates next occurrence at midnight from non-midnight input',
              () {
            // January 1, 2024 at 15:30.
            final inputDate = DateTime(2024, 1, 1, 15, 30);
            // February 1, 2024 at 00:00.
            final expected = DateTime(2024, 2);
            expect(wrapper, hasNext(expected).withInput(inputDate));
          });
        });

        group('previous', () {
          test('Always generates date before input', () {
            // February 1, 2024 at 00:00.
            final inputDate = DateTime(2024, 2);
            expect(wrapper, previousIsBefore.withInput(inputDate));
          });
          test('Generates previous occurrence at midnight', () {
            // February 1, 2024 at 00:00.
            final inputDate = DateTime(2024, 2);
            // January 1, 2024 at 00:00.
            final expected = DateTime(2024);
            expect(wrapper, hasPrevious(expected).withInput(inputDate));
          });
          test(
              'Generates previous occurrence at midnight from non-midnight '
              'input', () {
            // February 1, 2024 at 15:30.
            final inputDate = DateTime(2024, 2, 1, 15, 30);
            // January 1, 2024 at 00:00.
            final expected = DateTime(2024);
            expect(wrapper, hasPrevious(expected).withInput(inputDate));
          });
        });
      });

      group('Custom time of day', () {
        const customTime = EveryDueTimeOfDay(Duration(hours: 14, minutes: 30));
        final wrapper = LimitedEveryTimeOfDayWrapper(
          every: every,
          everyTimeOfDay: customTime,
        );

        group('next', () {
          test('Generates next occurrence at custom time', () {
            // January 1, 2024 at 14:30.
            final inputDate = DateTime(2024, 1, 1, 14, 30);
            // February 1, 2024 at 14:30.
            final expected = DateTime(2024, 2, 1, 14, 30);
            expect(wrapper, hasNext(expected).withInput(inputDate));
          });
          test('Generates next occurrence at custom time from midnight input',
              () {
            // January 1, 2024 at 00:00.
            final inputDate = DateTime(2024);
            // February 1, 2024 at 14:30.
            final expected = DateTime(2024, 2, 1, 14, 30);
            expect(wrapper, hasNext(expected).withInput(inputDate));
          });
        });

        group('previous', () {
          test('Generates previous occurrence at custom time', () {
            // February 1, 2024 at 14:30.
            final inputDate = DateTime(2024, 2, 1, 14, 30);
            // January 1, 2024 at 14:30.
            final expected = DateTime(2024, 1, 1, 14, 30);
            expect(wrapper, hasPrevious(expected).withInput(inputDate));
          });
          test(
              'Generates previous occurrence at custom time from midnight '
              'input', () {
            // February 1, 2024 at 00:00.
            final inputDate = DateTime(2024, 2);
            // January 1, 2024 at 14:30.
            final expected = DateTime(2024, 1, 1, 14, 30);
            expect(wrapper, hasPrevious(expected).withInput(inputDate));
          });
        });
      });

      group('Limit handling', () {
        final wrapper = LimitedEveryTimeOfDayWrapper(
          every: every,
          everyTimeOfDay: EveryDueTimeOfDay(Duration(hours: 10)),
        );

        test('Accepts limit parameter in next', () {
          // January 1, 2024 at 10:00.
          final inputDate = DateTime(2024, 1, 1, 10);
          // February 2, 2024 is after February 1.
          final limit = DateTime(2024, 2, 2);
          final result = wrapper.next(inputDate, limit: limit);
          expect(result, isNotNull);
        });

        test('Throws when limit is reached in next', () {
          // January 1, 2024 at 10:00.
          final inputDate = DateTime(2024, 1, 1, 10);
          // January 15, 2024 is before February 1.
          final limit = DateTime(2024, 1, 15);
          expect(
            () => wrapper.next(inputDate, limit: limit),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });

        test('Accepts limit parameter in previous', () {
          // February 1, 2024 at 10:00.
          final inputDate = DateTime(2024, 2, 1, 10);
          // December 31, 2023 is before January 1.
          final limit = DateTime(2023, 12, 31);
          final result = wrapper.previous(inputDate, limit: limit);
          expect(result, isNotNull);
        });

        test('Throws when limit is reached in previous', () {
          // February 1, 2024 at 10:00.
          final inputDate = DateTime(2024, 2, 1, 10);
          // January 15, 2024 is after January 1.
          final limit = DateTime(2024, 1, 15);
          expect(
            () => wrapper.previous(inputDate, limit: limit),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });

        test('Limit exactly equals expected date in next', () {
          // January 1, 2024 at 10:00.
          final inputDate = DateTime(2024, 1, 1, 10);
          // February 1, 2024 at 10:00.
          final limit = DateTime(2024, 2, 1, 10);
          final result = wrapper.next(inputDate, limit: limit);
          expect(result, equals(limit));
        });

        test('Limit exactly equals expected date in previous', () {
          // February 1, 2024 at 10:00.
          final inputDate = DateTime(2024, 2, 1, 10);
          // January 1, 2024 at 10:00.
          final limit = DateTime(2024, 1, 1, 10);
          final result = wrapper.previous(inputDate, limit: limit);
          expect(result, equals(limit));
        });
      });

      group('processDate', () {
        const customTime = EveryDueTimeOfDay(Duration(hours: 10));
        final wrapper = LimitedEveryTimeOfDayWrapper(
          every: every,
          everyTimeOfDay: customTime,
        );

        test('Sets time of day on input date', () {
          // January 1, 2024 at 15:30.
          final inputDate = DateTime(2024, 1, 1, 15, 30);
          // January 1, 2024 at 10:00.
          final expected = DateTime(2024, 1, 1, 10);
          final result = wrapper.processDate(
            inputDate,
            DateDirection.start,
          );
          expect(result, equals(expected));
        });

        test('Does not throw when limit is not reached in forward direction',
            () {
          // January 1, 2024 at 00:00.
          final inputDate = DateTime(2024);
          // January 2, 2024 is after the expected date.
          final limit = DateTime(2024, 1, 2);
          final result = wrapper.processDate(
            inputDate,
            DateDirection.start,
            limit: limit,
          );
          expect(result, isNotNull);
        });

        test('Throws when limit is reached in forward direction', () {
          // January 2, 2024 at 00:00.
          final inputDate = DateTime(2024, 1, 2);
          // January 1, 2024 is before the expected date.
          final limit = DateTime(2024, 1, 1);
          expect(
            () => wrapper.processDate(
              inputDate,
              DateDirection.start,
              limit: limit,
            ),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });

        test('Does not throw when limit is not reached in backward direction',
            () {
          // January 2, 2024 at 00:00.
          final inputDate = DateTime(2024, 1, 2);
          // January 1, 2024 is before the expected date.
          final limit = DateTime(2024, 1, 1);
          final result = wrapper.processDate(
            inputDate,
            DateDirection.end,
            limit: limit,
          );
          expect(result, isNotNull);
        });

        test('Throws when limit is reached in backward direction', () {
          // January 1, 2024 at 00:00.
          final inputDate = DateTime(2024, 1, 1);
          // January 2, 2024 is after the expected date.
          final limit = DateTime(2024, 1, 2);
          expect(
            () => wrapper.processDate(
              inputDate,
              DateDirection.end,
              limit: limit,
            ),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });
      });
    });

    group('Equality', () {
      final wrapper1 = LimitedEveryTimeOfDayWrapper(every: every);
      final wrapper2 = LimitedEveryTimeOfDayWrapper(every: every);
      const customTime = EveryDueTimeOfDay(Duration(hours: 14, minutes: 30));
      final wrapper3 = LimitedEveryTimeOfDayWrapper(
        every: every,
        everyTimeOfDay: customTime,
      );
      const differentEvery = EveryDueDayMonth(15);
      final wrapper4 = LimitedEveryTimeOfDayWrapper(every: differentEvery);

      test('Same instance', () {
        expect(wrapper1, equals(wrapper1));
      });
      test('Same properties are equal', () {
        expect(wrapper1, equals(wrapper2));
      });
      test('Different everyTimeOfDay are not equal', () {
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
