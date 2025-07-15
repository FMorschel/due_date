import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

import '../src/date_time_match.dart';

void main() {
  group('EveryDayInYear:', () {
    group('Constructor', () {
      group('Unnamed', () {
        test('Valid basic case', () {
          expect(EveryDayInYear(15), isNotNull);
        });
        test('Creates with correct dayInYear', () {
          expect(EveryDayInYear(100).dayInYear, equals(100));
        });
        test('Default exact is false', () {
          expect(EveryDayInYear(100).exact, isFalse);
        });
        group('asserts limits', () {
          test('Day less than 1', () {
            expect(
              () => EveryDayInYear(0),
              throwsA(isA<AssertionError>()),
            );
          });
          test('Day greater than 366', () {
            expect(
              () => EveryDayInYear(367),
              throwsA(isA<AssertionError>()),
            );
          });
        });
      });

      group('from', () {
        test('Valid basic case', () {
          // Day 75 of 2024 (leap year).
          final date = DateTime(2024, 3, 15);
          expect(EveryDayInYear.from(date), isNotNull);
        });
        test('Creates with correct dayInYear', () {
          // Day 75 of 2024 (leap year).
          final date = DateTime(2024, 3, 15);
          final every = EveryDayInYear.from(date);
          expect(every.dayInYear, equals(75));
        });
        test('Default exact is false', () {
          final date = DateTime(2024, 3, 15);
          final every = EveryDayInYear.from(date);
          expect(every.exact, isFalse);
        });
      });
    });

    group('Methods', () {
      group('startDate', () {
        const every = EveryDayInYear(15);

        test('Returns same date when input is valid', () {
          // January 15, 2022 is day 15 of the year.
          final january15th = DateTime(2022, DateTime.january, 15);
          expect(every.startDate(january15th), isSameDateTime(january15th));
        });
        test('Returns next valid date when input is invalid', () {
          // January 14, 2022 is day 14 of the year.
          final january14th = DateTime(2022, DateTime.january, 14);
          // January 15, 2022 is day 15 of the year.
          final january15th = DateTime(2022, DateTime.january, 15);
          expect(every.startDate(january14th), isSameDateTime(january15th));
        });
        test('Works with UTC dates', () {
          // January 15, 2022 is day 15 of the year (UTC).
          final january15thUtc = DateTime.utc(2022, DateTime.january, 15);
          expect(
            every.startDate(january15thUtc),
            isSameDateTime(january15thUtc),
          );
        });
      });

      group('next', () {
        const every = EveryDayInYear(15);

        test('Always generates date after or equal to input', () {
          // January 15, 2022 is day 15 of the year.
          final january15th2022 = DateTime(2022, DateTime.january, 15);
          final result = every.next(january15th2022);
          expect(result.isAfter(january15th2022), isTrue);
        });
        test('Generates next occurrence from valid date', () {
          // January 15, 2022 is day 15 of the year.
          final january15th2022 = DateTime(2022, DateTime.january, 15);
          // January 15, 2023 is day 15 of the year.
          final january15th2023 = DateTime(2023, DateTime.january, 15);
          expect(every.next(january15th2022), isSameDateTime(january15th2023));
        });
        test('Generates next occurrence from invalid date', () {
          // January 14, 2022 is day 14 of the year.
          final january14th2022 = DateTime(2022, DateTime.january, 14);
          // January 15, 2022 is day 15 of the year.
          final january15th2022 = DateTime(2022, DateTime.january, 15);
          expect(every.next(january14th2022), isSameDateTime(january15th2022));
        });
        test('Works with UTC dates', () {
          // January 15, 2022 is day 15 of the year (UTC).
          final january15th2022Utc = DateTime.utc(2022, DateTime.january, 15);
          // January 15, 2023 is day 15 of the year (UTC).
          final january15th2023Utc = DateTime.utc(2023, DateTime.january, 15);
          expect(
            every.next(january15th2022Utc),
            isSameDateTime(january15th2023Utc),
          );
        });
      });

      group('previous', () {
        const every = EveryDayInYear(15);

        test('Always generates date before input', () {
          // January 15, 2022 is day 15 of the year.
          final january15th2022 = DateTime(2022, DateTime.january, 15);
          final result = every.previous(january15th2022);
          expect(result.isBefore(january15th2022), isTrue);
        });
        test('Generates previous occurrence from valid date', () {
          // January 15, 2022 is day 15 of the year.
          final january15th2022 = DateTime(2022, DateTime.january, 15);
          // January 15, 2021 is day 15 of the year.
          final january15th2021 = DateTime(2021, DateTime.january, 15);
          expect(
            every.previous(january15th2022),
            isSameDateTime(january15th2021),
          );
        });
        test('Generates previous occurrence from invalid date', () {
          // January 14, 2022 is day 14 of the year.
          final january14th2022 = DateTime(2022, DateTime.january, 14);
          // January 15, 2021 is day 15 of the year.
          final january15th2021 = DateTime(2021, DateTime.january, 15);
          expect(
            every.previous(january14th2022),
            isSameDateTime(january15th2021),
          );
        });
        test('Works with UTC dates', () {
          // January 15, 2022 is day 15 of the year (UTC).
          final january15th2022Utc = DateTime.utc(2022, DateTime.january, 15);
          // January 15, 2021 is day 15 of the year (UTC).
          final january15th2021Utc = DateTime.utc(2021, DateTime.january, 15);
          expect(
            every.previous(january15th2022Utc),
            isSameDateTime(january15th2021Utc),
          );
        });
      });

      group('addYears', () {
        const every = EveryDayInYear(100);

        test('Zero years returns same date when valid', () {
          // April 10, 2022 is day 100 of the year.
          final april10th2022 = DateTime(2022, DateTime.april, 10);
          expect(
            every.addYears(april10th2022, 0),
            isSameDateTime(april10th2022),
          );
        });
        test('Positive years adds correctly', () {
          // April 10, 2022 is day 100 of the year.
          final april10th2022 = DateTime(2022, DateTime.april, 10);
          // April 9, 2024 is day 100 of the year.
          final april9th2024 = DateTime(2024, DateTime.april, 9);
          expect(
            every.addYears(april10th2022, 2),
            isSameDateTime(april9th2024),
          );
        });
        test('Negative years subtracts correctly', () {
          // April 10, 2022 is day 100 of the year.
          final april10th2022 = DateTime(2022, DateTime.april, 10);
          // April 9, 2020 is day 100 of the year.
          final april9th2020 = DateTime(2020, DateTime.april, 9);
          expect(
            every.addYears(april10th2022, -2),
            isSameDateTime(april9th2020),
          );
        });
        test('Works with UTC dates', () {
          // April 10, 2022 is day 100 of the year (UTC).
          final april10th2022Utc = DateTime.utc(2022, DateTime.april, 10);
          // April 10, 2023 is day 100 of the year (UTC).
          final april10th2023Utc = DateTime.utc(2023, DateTime.april, 10);
          expect(
            every.addYears(april10th2022Utc, 1),
            isSameDateTime(april10th2023Utc),
          );
        });
      });
    });

    // REQUIRED: Explicit datetime-to-datetime tests.
    group('Explicit datetime tests:', () {
      test('Day 15 calculation (January 15)', () {
        const everyDay15 = EveryDayInYear(15);
        // January 10, 2022 is day 10 of the year.
        final inputDate = DateTime(2022, 1, 10);
        // January 15, 2022 is day 15 of the year.
        final expected = DateTime(2022, 1, 15);

        expect(everyDay15.next(inputDate), isSameDateTime(expected));
      });

      test("Day 256 calculation (Programmer's Day)", () {
        const everyDay256 = EveryDayInYear(256);
        // August 1, 2022 is day 213 of the year.
        final inputDate = DateTime(2022, 8);
        // September 13, 2022 is day 256 of the year.
        final expected = DateTime(2022, 9, 13);

        expect(everyDay256.next(inputDate), isSameDateTime(expected));
      });

      test('Edge case: Day 366 in leap year', () {
        const everyDay366 = EveryDayInYear(366);
        // February 1, 2024 is day 32 of the leap year.
        final inputDate = DateTime(2024, 2);
        // December 31, 2024 is day 366 of the leap year.
        final expected = DateTime(2024, 12, 31);

        expect(everyDay366.next(inputDate), isSameDateTime(expected));
      });

      test('Edge case: Day 366 in non-leap year still goes to end of the year',
          () {
        const everyDay366 = EveryDayInYear(366);
        // February 1, 2023 is day 32 of the non-leap year.
        final inputDate = DateTime(2023, 2);
        // December 31, 2023 is day 365 of the non-leap year.
        final expected = DateTime(2023, 12, 31);

        expect(everyDay366.next(inputDate), isSameDateTime(expected));
      });

      test('Edge case: year boundary crossing', () {
        const everyDay15 = EveryDayInYear(15);
        // December 31, 2022 is day 365 of the year.
        final inputDate = DateTime(2022, 12, 31);
        // January 15, 2023 is day 15 of the year.
        final expected = DateTime(2023, 1, 15);

        expect(everyDay15.next(inputDate), isSameDateTime(expected));
      });

      test('Previous calculation across years', () {
        const everyDay100 = EveryDayInYear(100);
        // January 1, 2023 is day 1 of the year.
        final inputDate = DateTime(2023);
        // April 10, 2022 is day 100 of the year.
        final expected = DateTime(2022, 4, 10);

        expect(everyDay100.previous(inputDate), isSameDateTime(expected));
      });
    });

    // REQUIRED: Time component preservation tests.
    group('Time component preservation:', () {
      test('Maintains time components in local DateTime', () {
        const everyDay100 = EveryDayInYear(100);
        final inputWithTime = DateTime(2022, 1, 15, 14, 30, 45, 123, 456);
        final result = everyDay100.next(inputWithTime);

        // Should preserve time components.
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
        expect(result, isLocalDateTime);
      });

      test('Maintains time components in UTC DateTime', () {
        const everyDay100 = EveryDayInYear(100);
        final inputWithTime = DateTime.utc(2022, 1, 15, 14, 30, 45, 123, 456);
        final result = everyDay100.next(inputWithTime);

        // Should preserve time components and UTC flag.
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
        expect(result, isUtcDateTime);
      });

      test('Previous maintains time components in local DateTime', () {
        const everyDay50 = EveryDayInYear(50);
        final inputWithTime = DateTime(2022, 8, 15, 9, 15, 30, 500, 250);
        final result = everyDay50.previous(inputWithTime);

        // Should preserve time components.
        expect(result.hour, equals(9));
        expect(result.minute, equals(15));
        expect(result.second, equals(30));
        expect(result.millisecond, equals(500));
        expect(result.microsecond, equals(250));
        expect(result, isLocalDateTime);
      });

      test('Previous maintains time components in UTC DateTime', () {
        const everyDay50 = EveryDayInYear(50);
        final inputWithTime = DateTime.utc(2022, 8, 15, 9, 15, 30, 500, 250);
        final result = everyDay50.previous(inputWithTime);

        // Should preserve time components and UTC flag.
        expect(result.hour, equals(9));
        expect(result.minute, equals(15));
        expect(result.second, equals(30));
        expect(result.millisecond, equals(500));
        expect(result.microsecond, equals(250));
        expect(result, isUtcDateTime);
      });

      test('Normal generation with date-only input (local)', () {
        const everyDay200 = EveryDayInYear(200);
        final inputDate = DateTime(2022, 5, 15);
        final result = everyDay200.next(inputDate);

        // Should maintain date-only format.
        expect(result.hour, equals(0));
        expect(result.minute, equals(0));
        expect(result.second, equals(0));
        expect(result.millisecond, equals(0));
        expect(result.microsecond, equals(0));
        expect(result, isLocalDateTime);
      });

      test('Normal generation with date-only input (UTC)', () {
        const everyDay200 = EveryDayInYear(200);
        final inputDate = DateTime.utc(2022, 5, 15);
        final result = everyDay200.next(inputDate);

        // Should maintain date-only format and UTC flag.
        expect(result.hour, equals(0));
        expect(result.minute, equals(0));
        expect(result.second, equals(0));
        expect(result.millisecond, equals(0));
        expect(result.microsecond, equals(0));
        expect(result, isUtcDateTime);
      });
    });

    // Tests for validation behavior (day 366 handling).
    group('Day 366 validation behavior:', () {
      test('Day 366 validates correctly in leap year', () {
        const everyDay366 = EveryDayInYear(366);
        // December 31, 2024 is day 366 of the leap year.
        final leapYearEnd = DateTime(2024, 12, 31);
        expect(everyDay366.valid(leapYearEnd), isTrue);
      });

      test(
          'Day 366 validates correctly in non-leap year (falls back to day '
          '365)', () {
        const everyDay366 = EveryDayInYear(366);
        // December 31, 2023 is day 365 of the non-leap year.
        final nonLeapYearEnd = DateTime(2023, 12, 31);
        expect(everyDay366.valid(nonLeapYearEnd), isTrue);
      });

      test('Day 366 next() in non-leap year returns day 365', () {
        const everyDay366 = EveryDayInYear(366);
        // March 1, 2023 is day 60 of the non-leap year.
        final inputDate = DateTime(2023, 3);
        final result = everyDay366.next(inputDate);

        // Should return December 31, 2023 (day 365).
        expect(result.month, equals(12));
        expect(result.day, equals(31));
        expect(result.year, equals(2023));
      });

      test('Day 366 next() in leap year returns day 366', () {
        const everyDay366 = EveryDayInYear(366);
        // March 1, 2024 is day 61 of the leap year.
        final inputDate = DateTime(2024, 3);
        final result = everyDay366.next(inputDate);

        // Should return December 31, 2024 (day 366).
        expect(result.month, equals(12));
        expect(result.day, equals(31));
        expect(result.year, equals(2024));
      });
    });

    group('Edge Cases', () {
      group('Leap year handling', () {
        test('Day 366 in leap year', () {
          const everyDay366 = EveryDayInYear(366);
          // December 31, 2024 is day 366 of the leap year.
          final leapYearEnd = DateTime(2024, 12, 31);
          expect(everyDay366.valid(leapYearEnd), isTrue);
        });

        test('Day 366 in non-leap year falls back to day 365', () {
          const everyDay366 = EveryDayInYear(366);
          // December 31, 2023 is day 365 of the non-leap year.
          final nonLeapYearEnd = DateTime(2023, 12, 31);
          expect(everyDay366.valid(nonLeapYearEnd), isTrue);
        });
      });

      group('Year boundary transitions', () {
        test('December to January transition', () {
          const everyDay1 = EveryDayInYear(1);
          // December 31, 2022 is day 365 of the year.
          final december31 = DateTime(2022, 12, 31);
          // January 1, 2023 is day 1 of the year.
          final expected = DateTime(2023);
          expect(everyDay1.next(december31), isSameDateTime(expected));
        });

        test('January to December transition (previous)', () {
          const everyDay365 = EveryDayInYear(365);
          // January 1, 2023 is day 1 of the year.
          final january1 = DateTime(2023);
          // December 31, 2022 is day 365 of the year.
          final expected = DateTime(2022, 12, 31);
          expect(everyDay365.previous(january1), isSameDateTime(expected));
        });
      });
    });

    group('toString', () {
      test('Returns meaningful string representation', () {
        const everyDay100 = EveryDayInYear(100);
        expect(everyDay100.toString(), equals('EveryDayInYear<100>'));
      });

      test('Returns meaningful string representation for day 366', () {
        const everyDay366 = EveryDayInYear(366);
        expect(everyDay366.toString(), equals('EveryDayInYear<366>'));
      });
    });

    group('Equality', () {
      final everyDay100_1 = EveryDayInYear(100);
      final everyDay100_2 = EveryDayInYear(100);
      final everyDay200 = EveryDayInYear(200);

      test('Same instance', () {
        expect(everyDay100_1, equals(everyDay100_1));
      });
      test('Different dayInYear', () {
        expect(everyDay100_1, isNot(equals(everyDay200)));
      });
      test('Same dayInYear', () {
        expect(everyDay100_1, equals(everyDay100_2));
      });
      test('Hash code consistency', () {
        expect(everyDay100_1.hashCode, equals(everyDay100_2.hashCode));
      });
    });
  });
}
