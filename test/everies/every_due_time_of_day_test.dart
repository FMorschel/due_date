import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

import '../src/date_time_match.dart';
import '../src/every_match.dart';

void main() {
  group('EveryDueTimeOfDay:', () {
    group('Constructor', () {
      group('Unnamed', () {
        test('Valid basic case', () {
          expect(
            EveryDueTimeOfDay(const Duration(hours: 9, minutes: 30)),
            isNotNull,
          );
        });
        test('Default property values', () {
          const timeOfDay = Duration(hours: 9, minutes: 30);
          expect(
            EveryDueTimeOfDay(timeOfDay).timeOfDay,
            equals(timeOfDay),
          );
        });
        group('Valid durations', () {
          test('Zero duration (midnight)', () {
            expect(EveryDueTimeOfDay(Duration.zero), isNotNull);
          });
          test('End of day minus 1 microsecond', () {
            expect(
              EveryDueTimeOfDay(
                const Duration(days: 1) - const Duration(microseconds: 1),
              ),
              isNotNull,
            );
          });
          test('Random valid duration', () {
            expect(
              EveryDueTimeOfDay(const Duration(hours: 14, minutes: 45)),
              isNotNull,
            );
          });
        });
        group('asserts limits', () {
          test('Negative duration', () {
            expect(
              () => EveryDueTimeOfDay(-const Duration(microseconds: 1)),
              throwsA(isA<AssertionError>()),
            );
          });
          test('Duration of 1 day', () {
            expect(
              () => EveryDueTimeOfDay(const Duration(days: 1)),
              throwsA(isA<AssertionError>()),
            );
          });
          test('Duration greater than 1 day', () {
            expect(
              () => EveryDueTimeOfDay(const Duration(days: 2)),
              throwsA(isA<AssertionError>()),
            );
          });
        });
      });

      group('from', () {
        test('Valid case description', () {
          final dateTime = DateTime(2022, 1, 1, 13, 30);
          final every = EveryDueTimeOfDay.from(dateTime);

          expect(
            every.timeOfDay,
            equals(const Duration(hours: 13, minutes: 30)),
          );
        });
        test('Creates instance with microsecond precision', () {
          final dateTime = DateTime(2022, 1, 1, 13, 30, 45, 123, 456);
          final every = EveryDueTimeOfDay.from(dateTime);

          expect(
            every.timeOfDay,
            equals(
              const Duration(
                hours: 13,
                minutes: 30,
                seconds: 45,
                milliseconds: 123,
                microseconds: 456,
              ),
            ),
          );
        });
      });
    });

    group('Methods', () {
      group('startDate', () {
        final every = EveryDueTimeOfDay(
          const Duration(hours: 23, minutes: 30),
        );

        test('Returns same date when input is valid', () {
          final validDate = DateTime(2022, 1, 1, 23, 30);
          expect(every, startsAtSameDate.withInput(validDate));
        });
        test('Returns next valid date when input is invalid', () {
          final invalidDate = DateTime(2022, 1, 1, 23, 29);
          final expected = DateTime(2022, 1, 1, 23, 30);
          expect(every, startsAt(expected).withInput(invalidDate));
        });
        test('Works with UTC dates', () {
          final validDateUtc = DateTime.utc(2022, 1, 1, 23, 30);
          expect(every, startsAtSameDate.withInput(validDateUtc));
        });
      });

      group('next', () {
        final every = EveryDueTimeOfDay(
          const Duration(hours: 23, minutes: 30),
        );

        test('Always generates date after input', () {
          final validDate = DateTime(2022, 1, 1, 23, 30);
          expect(every, nextIsAfter.withInput(validDate));
        });
        test('Generates next occurrence from valid date', () {
          final validDate = DateTime(2022, 1, 1, 23, 30);
          final expected = DateTime(2022, 1, 2, 23, 30);
          expect(every, hasNext(expected).withInput(validDate));
        });
        test('Generates next occurrence from invalid date', () {
          final invalidDate = DateTime(2022, 1, 1, 23, 29);
          final expected = DateTime(2022, 1, 1, 23, 30);
          expect(every, hasNext(expected).withInput(invalidDate));
        });
        test('Works with UTC dates', () {
          final validDateUtc = DateTime.utc(2022, 1, 1, 23, 30);
          final expectedUtc = DateTime.utc(2022, 1, 2, 23, 30);
          expect(every, hasNext(expectedUtc).withInput(validDateUtc));
        });
      });

      group('previous', () {
        final every = EveryDueTimeOfDay(
          const Duration(hours: 23, minutes: 30),
        );

        test('Always generates date before input', () {
          final validDate = DateTime(2022, 1, 2, 23, 30);
          expect(every, previousIsBefore.withInput(validDate));
        });
        test('Generates previous occurrence from valid date', () {
          final validDate = DateTime(2022, 1, 2, 23, 30);
          final expected = DateTime(2022, 1, 1, 23, 30);
          expect(every, hasPrevious(expected).withInput(validDate));
        });
        test('Generates previous occurrence from invalid date', () {
          final invalidDate = DateTime(2022, 1, 2, 23, 29);
          final expected = DateTime(2022, 1, 1, 23, 30);
          expect(every, hasPrevious(expected).withInput(invalidDate));
        });
        test('Works with UTC dates', () {
          final validDateUtc = DateTime.utc(2022, 1, 2, 23, 30);
          final expectedUtc = DateTime.utc(2022, 1, 1, 23, 30);
          expect(every, hasPrevious(expectedUtc).withInput(validDateUtc));
        });
      });
    });

    // REQUIRED: Explicit datetime-to-datetime tests.
    group('Explicit datetime tests:', () {
      test('9:30 AM time calculation', () {
        final everyMorning = EveryDueTimeOfDay(
          const Duration(hours: 9, minutes: 30),
        );
        // January 1, 2022 at 8:00 AM.
        final inputDate = DateTime(2022, 1, 1, 8);
        // January 1, 2022 at 9:30 AM.
        final expected = DateTime(2022, 1, 1, 9, 30);

        expect(everyMorning, hasNext(expected).withInput(inputDate));
      });

      test('11:59 PM time calculation', () {
        final everyNight = EveryDueTimeOfDay(
          const Duration(hours: 23, minutes: 59),
        );
        // January 1, 2022 at 10:00 PM.
        final inputDate = DateTime(2022, 1, 1, 22);
        // January 1, 2022 at 11:59 PM.
        final expected = DateTime(2022, 1, 1, 23, 59);

        expect(everyNight, hasNext(expected).withInput(inputDate));
      });

      test('Midnight (00:00) time calculation', () {
        final everyMidnight = EveryDueTimeOfDay(Duration.zero);
        // January 1, 2022 at 11:30 PM.
        final inputDate = DateTime(2022, 1, 1, 23, 30);
        // January 2, 2022 at 12:00 AM.
        final expected = DateTime(2022, 1, 2);

        expect(everyMidnight, hasNext(expected).withInput(inputDate));
      });

      test('Time after current time same day', () {
        final everyAfternoon = EveryDueTimeOfDay(
          const Duration(hours: 15, minutes: 45),
        );
        // January 1, 2022 at 10:00 AM.
        final inputDate = DateTime(2022, 1, 1, 10);
        // January 1, 2022 at 3:45 PM.
        final expected = DateTime(2022, 1, 1, 15, 45);

        expect(everyAfternoon, hasNext(expected).withInput(inputDate));
      });

      test('Time before current time next day', () {
        final everyMorning = EveryDueTimeOfDay(
          const Duration(hours: 9, minutes: 30),
        );
        // January 1, 2022 at 10:00 AM.
        final inputDate = DateTime(2022, 1, 1, 10);
        // January 2, 2022 at 9:30 AM.
        final expected = DateTime(2022, 1, 2, 9, 30);

        expect(everyMorning, hasNext(expected).withInput(inputDate));
      });

      test('Previous calculation across days', () {
        final everyMorning = EveryDueTimeOfDay(
          const Duration(hours: 9, minutes: 30),
        );
        // January 2, 2022 at 8:00 AM.
        final inputDate = DateTime(2022, 1, 2, 8);
        // January 1, 2022 at 9:30 AM.
        final expected = DateTime(2022, 1, 1, 9, 30);

        expect(everyMorning, hasPrevious(expected).withInput(inputDate));
      });
    });

    // REQUIRED: Time component preservation tests.
    group('Time component preservation:', () {
      test('Maintains microsecond precision in local DateTime', () {
        final everyMorning = EveryDueTimeOfDay(
          const Duration(
            hours: 9,
            minutes: 30,
            seconds: 45,
            milliseconds: 123,
            microseconds: 456,
          ),
        );
        // Input with different time but same date.
        final inputDate = DateTime(2022, 1, 1, 8);
        final result = everyMorning.next(inputDate);

        // Should preserve exact time components from timeOfDay.
        expect(result.hour, equals(9));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
        expect(result, isLocalDateTime);
      });

      test('Maintains microsecond precision in UTC DateTime', () {
        final everyMorning = EveryDueTimeOfDay(
          const Duration(
            hours: 9,
            minutes: 30,
            seconds: 45,
            milliseconds: 123,
            microseconds: 456,
          ),
        );
        // Input with different time but same date (UTC).
        final inputDate = DateTime.utc(2022, 1, 1, 8);
        final result = everyMorning.next(inputDate);

        // Should preserve exact time components from timeOfDay and UTC flag.
        expect(result.hour, equals(9));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
        expect(result, isUtcDateTime);
      });

      test('Previous maintains microsecond precision in local DateTime', () {
        final everyMorning = EveryDueTimeOfDay(
          const Duration(hours: 9, minutes: 30, seconds: 45),
        );
        // Input at 8:00 AM on day 2.
        final inputDate = DateTime(2022, 1, 2, 8);
        final result = everyMorning.previous(inputDate);

        // Should preserve exact time components from timeOfDay.
        expect(result.hour, equals(9));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(0));
        expect(result.microsecond, equals(0));
        expect(result, isLocalDateTime);
      });

      test('Previous maintains microsecond precision in UTC DateTime', () {
        final everyMorning = EveryDueTimeOfDay(
          const Duration(hours: 9, minutes: 30, seconds: 45),
        );
        // Input at 8:00 AM on day 2 (UTC).
        final inputDate = DateTime.utc(2022, 1, 2, 8);
        final result = everyMorning.previous(inputDate);

        // Should preserve exact time components from timeOfDay and UTC flag.
        expect(result.hour, equals(9));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(0));
        expect(result.microsecond, equals(0));
        expect(result, isUtcDateTime);
      });

      test('Normal generation preserves date components (local)', () {
        final everyMorning = EveryDueTimeOfDay(
          const Duration(hours: 9, minutes: 30),
        );
        final inputDate = DateTime(2022, 1, 1, 8);
        final result = everyMorning.next(inputDate);

        // Should preserve date components and apply time.
        expect(result.year, equals(2022));
        expect(result.month, equals(1));
        expect(result.day, equals(1));
        expect(result.hour, equals(9));
        expect(result.minute, equals(30));
        expect(result, isLocalDateTime);
      });

      test('Normal generation preserves date components (UTC)', () {
        final everyMorning = EveryDueTimeOfDay(
          const Duration(hours: 9, minutes: 30),
        );
        final inputDate = DateTime.utc(2022, 1, 1, 8);
        final result = everyMorning.next(inputDate);

        // Should preserve date components and apply time with UTC flag.
        expect(result.year, equals(2022));
        expect(result.month, equals(1));
        expect(result.day, equals(1));
        expect(result.hour, equals(9));
        expect(result.minute, equals(30));
        expect(result, isUtcDateTime);
      });
    });

    group('Edge Cases', () {
      group('Midnight handling', () {
        final everyMidnight = EveryDueTimeOfDay(Duration.zero);

        test('Handles midnight calculation correctly', () {
          // January 1, 2022 at 11:30 PM.
          final inputDate = DateTime(2022, 1, 1, 23, 30);
          // January 2, 2022 at 12:00 AM.
          final expected = DateTime(2022, 1, 2);
          expect(everyMidnight, hasNext(expected).withInput(inputDate));
        });

        test('Handles midnight as valid time', () {
          // January 1, 2022 at 12:00 AM.
          final validDate = DateTime(2022);
          expect(everyMidnight, startsAtSameDate.withInput(validDate));
        });
      });

      group('End of day handling', () {
        final everyEndOfDay = EveryDueTimeOfDay(
          const Duration(hours: 23, minutes: 59, seconds: 59),
        );

        test('Handles end of day correctly', () {
          // January 1, 2022 at 10:00 PM.
          final inputDate = DateTime(2022, 1, 1, 22);
          // January 1, 2022 at 11:59:59 PM.
          final expected = DateTime(2022, 1, 1, 23, 59, 59);
          expect(everyEndOfDay, hasNext(expected).withInput(inputDate));
        });

        test('Handles rollover to next day', () {
          // January 1, 2022 at 11:59:59 PM.
          final validDate = DateTime(2022, 1, 1, 23, 59, 59);
          // January 2, 2022 at 11:59:59 PM.
          final expected = DateTime(2022, 1, 2, 23, 59, 59);
          expect(everyEndOfDay, hasNext(expected).withInput(validDate));
        });
      });

      group('Year boundary transitions', () {
        final everyMorning = EveryDueTimeOfDay(
          const Duration(hours: 9, minutes: 30),
        );

        test('December 31 to January 1 transition', () {
          // December 31, 2022 at 10:00 AM.
          final inputDate = DateTime(2022, 12, 31, 10);
          // January 1, 2023 at 9:30 AM.
          final expected = DateTime(2023, 1, 1, 9, 30);
          expect(everyMorning, hasNext(expected).withInput(inputDate));
        });

        test('January 1 to December 31 transition (previous)', () {
          // January 1, 2023 at 8:00 AM.
          final inputDate = DateTime(2023, 1, 1, 8);
          // December 31, 2022 at 9:30 AM.
          final expected = DateTime(2022, 12, 31, 9, 30);
          expect(everyMorning, hasPrevious(expected).withInput(inputDate));
        });
      });
    });

    group('Equality', () {
      final everyMorning1 = EveryDueTimeOfDay(
        const Duration(hours: 9, minutes: 30),
      );
      final everyMorning2 = EveryDueTimeOfDay(
        const Duration(hours: 9, minutes: 30),
      );
      final everyAfternoon = EveryDueTimeOfDay(
        const Duration(hours: 15, minutes: 45),
      );

      test('Same instance', () {
        expect(everyMorning1, equals(everyMorning1));
      });
      test('Different timeOfDay', () {
        expect(everyMorning1, isNot(equals(everyAfternoon)));
      });
      test('Same timeOfDay', () {
        expect(everyMorning1, equals(everyMorning2));
      });
      test('Hash code consistency', () {
        expect(everyMorning1.hashCode, equals(everyMorning2.hashCode));
      });
    });
  });
}
