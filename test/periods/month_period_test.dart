// ignore_for_file: prefer_const_constructors

import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('MonthPeriod:', () {
    group('Constructor', () {
      group('Valid cases', () {
        test('Creates MonthPeriod with valid start and end', () {
          final start = DateTime(2024);
          final end = DateTime(2024, 1, 31, 23, 59, 59, 999, 999);
          expect(MonthPeriod(start: start, end: end), isNotNull);
        });

        test('Creates MonthPeriod with UTC dates', () {
          final start = DateTime.utc(2024);
          final end = DateTime.utc(2024, 1, 31, 23, 59, 59, 999, 999);
          expect(MonthPeriod(start: start, end: end), isNotNull);
        });

        test('Works with February in non-leap year', () {
          final start = DateTime(2023, 2);
          final end = DateTime(2023, 2, 28, 23, 59, 59, 999, 999);
          expect(MonthPeriod(start: start, end: end), isNotNull);
        });

        test('Works with February in leap year', () {
          final start = DateTime(2024, 2);
          final end = DateTime(2024, 2, 29, 23, 59, 59, 999, 999);
          expect(MonthPeriod(start: start, end: end), isNotNull);
        });
      });

      group('Validation errors', () {
        test('Throws AssertionError if duration exceeds month length', () {
          final start = DateTime(2024);
          // Feb 1.
          final end = DateTime(2024, 2, 1, 23, 59, 59, 999, 999);
          expect(
            () => MonthPeriod(start: start, end: end),
            throwsA(isA<AssertionError>()),
          );
        });

        test('Throws ArgumentError if end is not last microsecond of month',
            () {
          final start = DateTime(2024);
          final end = DateTime(2024, 1, 31, 23, 59, 59, 999, 998);
          expect(
            () => MonthPeriod(start: start, end: end),
            throwsArgumentError,
          );
        });
      });
    });

    group('Properties', () {
      test('Duration varies by month length', () {
        // January has 31 days.
        final january = MonthPeriod(
          start: DateTime(2024),
          end: DateTime(2024, 1, 31, 23, 59, 59, 999, 999),
        );
        expect(january.duration, equals(Duration(days: 31)));

        // February 2024 has 29 days (leap year).
        final february = MonthPeriod(
          start: DateTime(2024, 2),
          end: DateTime(2024, 2, 29, 23, 59, 59, 999, 999),
        );
        expect(february.duration, equals(Duration(days: 29)));

        // February 2023 has 28 days (non-leap year).
        final february2023 = MonthPeriod(
          start: DateTime(2023, 2),
          end: DateTime(2023, 2, 28, 23, 59, 59, 999, 999),
        );
        expect(february2023.duration, equals(Duration(days: 28)));
      });

      test('Start and end are properly set', () {
        final month = MonthPeriod(
          start: DateTime(2024, 3),
          end: DateTime(2024, 3, 31, 23, 59, 59, 999, 999),
        );
        expect(month.start.day, equals(1));
        expect(month.start.month, equals(3));
        expect(month.end.day, equals(31));
        expect(month.end.month, equals(3));
      });
    });

    group('Days property', () {
      test('Returns correct number of DayPeriod objects for January', () {
        final month = MonthPeriod(
          start: DateTime(2020),
          end: DateTime(2020, 1, 31, 23, 59, 59, 999, 999),
        );
        final days = month.days;
        expect(days, isA<List<DayPeriod>>());
        expect(days, hasLength(31));
        expect(days.every((day) => day.start.month == 1), isTrue);
      });

      test('Returns 28 days for February in non-leap year', () {
        final month = MonthPeriod(
          start: DateTime(2023, 2),
          end: DateTime(2023, 2, 28, 23, 59, 59, 999, 999),
        );
        final days = month.days;
        expect(days, hasLength(28));
      });

      test('Returns 29 days for February in leap year', () {
        final month = MonthPeriod(
          start: DateTime(2024, 2),
          end: DateTime(2024, 2, 29, 23, 59, 59, 999, 999),
        );
        final days = month.days;
        expect(days, hasLength(29));
      });

      test('Returns 30 days for April', () {
        final month = MonthPeriod(
          start: DateTime(2024, 4),
          end: DateTime(2024, 4, 30, 23, 59, 59, 999, 999),
        );
        final days = month.days;
        expect(days, hasLength(30));
      });

      test('First day starts at month start', () {
        final month = MonthPeriod(
          start: DateTime(2020),
          end: DateTime(2020, 1, 31, 23, 59, 59, 999, 999),
        );
        final days = month.days;
        expect(
          days.first,
          equals(
            Period(
              start: DateTime(2020),
              end: DateTime(2020, 1, 1, 23, 59, 59, 999, 999),
            ),
          ),
        );
      });

      test('Last day ends at month end', () {
        final month = MonthPeriod(
          start: DateTime(2020),
          end: DateTime(2020, 1, 31, 23, 59, 59, 999, 999),
        );
        final days = month.days;
        expect(
          days.last,
          equals(
            Period(
              start: DateTime(2020, 1, 31),
              end: DateTime(2020, 1, 31, 23, 59, 59, 999, 999),
            ),
          ),
        );
      });

      test('Days progress correctly through month', () {
        final month = MonthPeriod(
          start: DateTime(2024, 3),
          end: DateTime(2024, 3, 31, 23, 59, 59, 999, 999),
        );
        final days = month.days;

        for (var i = 0; i < days.length; i++) {
          expect(days[i].start.day, equals(i + 1));
          expect(days[i].start.month, equals(3));
          expect(days[i].end.day, equals(i + 1));
          expect(days[i].end.month, equals(3));
        }
      });

      test('Days cover entire month with no gaps', () {
        final month = MonthPeriod(
          start: DateTime(2024, 5),
          end: DateTime(2024, 5, 31, 23, 59, 59, 999, 999),
        );
        final days = month.days;

        // Check no gaps between consecutive days.
        for (var i = 0; i < days.length - 1; i++) {
          final currentEnd = days[i].end;
          final nextStart = days[i + 1].start;
          expect(
            nextStart.difference(currentEnd),
            equals(Duration(microseconds: 1)),
          );
        }
      });
    });

    group('Edge cases', () {
      test('Works with all 12 months', () {
        final expectedDays = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        final monthEnds = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

        for (var monthNum = 1; monthNum <= 12; monthNum++) {
          // 2024 is leap year.
          final month = MonthPeriod(
            start: DateTime(2024, monthNum),
            end: DateTime(
              2024,
              monthNum,
              monthEnds[monthNum - 1],
              23,
              59,
              59,
              999,
              999,
            ),
          );
          expect(
            month.days,
            hasLength(expectedDays[monthNum - 1]),
            reason: 'Month $monthNum should have ${expectedDays[monthNum - 1]} '
                'days',
          );
        }
      });

      test('Handles February in leap years correctly', () {
        // Leap years: 2020, 2024, 2028.
        final leapYears = [2020, 2024, 2028];
        for (final year in leapYears) {
          final month = MonthPeriod(
            start: DateTime(year, 2),
            end: DateTime(year, 2, 29, 23, 59, 59, 999, 999),
          );
          expect(
            month.days,
            hasLength(29),
            reason: 'February $year should have 29 days (leap year)',
          );
        }

        // Non-leap years: 2021, 2022, 2023.
        final nonLeapYears = [2021, 2022, 2023];
        for (final year in nonLeapYears) {
          final month = MonthPeriod(
            start: DateTime(year, 2),
            end: DateTime(year, 2, 28, 23, 59, 59, 999, 999),
          );
          expect(
            month.days,
            hasLength(28),
            reason: 'February $year should have 28 days (non-leap year)',
          );
        }
      });

      test('Works with century years', () {
        // 1900 was not a leap year (century rule).
        final month1900 = MonthPeriod(
          start: DateTime.utc(1900, 2),
          end: DateTime.utc(1900, 2, 28, 23, 59, 59, 999, 999),
        );
        expect(month1900.days, hasLength(28));

        // 2004 was a leap year (4 rule).
        final month2004 = MonthPeriod(
          start: DateTime.utc(2004, 2),
          end: DateTime.utc(2004, 2, 29, 23, 59, 59, 999, 999),
        );
        expect(month2004.days, hasLength(29));
      });
    });

    group('Equality', () {
      final start1 = DateTime(2024);
      final end1 = DateTime(2024, 1, 31, 23, 59, 59, 999, 999);
      final month1 = MonthPeriod(start: start1, end: end1);

      final start2 = DateTime(2024, 2);
      final end2 = DateTime(2024, 2, 29, 23, 59, 59, 999, 999);
      final month2 = MonthPeriod(start: start2, end: end2);

      final month3 = MonthPeriod(start: start1, end: end1);

      test('Same instance equals itself', () {
        expect(month1, equals(month1));
      });

      test('Different months are not equal', () {
        expect(month1, isNot(equals(month2)));
      });

      test('Same start and end dates are equal', () {
        expect(month1, equals(month3));
      });

      test('HashCode is consistent', () {
        expect(month1.hashCode, equals(month3.hashCode));
        expect(month1.hashCode, isNot(equals(month2.hashCode)));
      });
    });
  });
}
