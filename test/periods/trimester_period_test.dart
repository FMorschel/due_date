// ignore_for_file: prefer_const_constructors

import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('TrimesterPeriod:', () {
    group('Constructor', () {
      group('Valid cases', () {
        test('Creates TrimesterPeriod with valid start and end', () {
          final start = DateTime(2024);
          final end = DateTime(2024, 3, 31, 23, 59, 59, 999, 999);
          expect(TrimesterPeriod(start: start, end: end), isNotNull);
        });

        test('Creates TrimesterPeriod with UTC dates', () {
          final start = DateTime.utc(2024);
          final end = DateTime.utc(2024, 3, 31, 23, 59, 59, 999, 999);
          expect(TrimesterPeriod(start: start, end: end), isNotNull);
        });

        test('Works with second trimester', () {
          final start = DateTime(2024, 4);
          final end = DateTime(2024, 6, 30, 23, 59, 59, 999, 999);
          expect(TrimesterPeriod(start: start, end: end), isNotNull);
        });

        test('Works with third trimester', () {
          final start = DateTime(2024, 7);
          final end = DateTime(2024, 9, 30, 23, 59, 59, 999, 999);
          expect(TrimesterPeriod(start: start, end: end), isNotNull);
        });

        test('Works with fourth trimester', () {
          final start = DateTime(2024, 10);
          final end = DateTime(2024, 12, 31, 23, 59, 59, 999, 999);
          expect(TrimesterPeriod(start: start, end: end), isNotNull);
        });
      });

      group('Validation errors', () {
        test('Throws AssertionError if duration is not exactly 3 months', () {
          final start = DateTime(2024, 1);
          // 4 months.
          final end = DateTime(2024, 4, 30, 23, 59, 59, 999, 999);
          expect(
            () => TrimesterPeriod(start: start, end: end),
            throwsA(isA<AssertionError>()),
          );
        });

        test('Throws ArgumentError if end is not last microsecond of trimester',
            () {
          final start = DateTime(2024, 1);
          final end = DateTime(2024, 3, 31, 23, 59, 59, 999, 998);
          expect(
            () => TrimesterPeriod(start: start, end: end),
            throwsArgumentError,
          );
        });
      });
    });

    group('Properties', () {
      test('Duration varies by trimester due to different month lengths', () {
        // Q1: Jan(31) + Feb(29 in 2024) + Mar(31) = 91 days.
        final q1 = TrimesterPeriod(
          start: DateTime(2024, 1, 1),
          end: DateTime(2024, 3, 31, 23, 59, 59, 999, 999),
        );
        expect(q1.duration, equals(Duration(days: 91)));

        // Q2: Apr(30) + May(31) + Jun(30) = 91 days.
        final q2 = TrimesterPeriod(
          start: DateTime(2024, 4, 1),
          end: DateTime(2024, 6, 30, 23, 59, 59, 999, 999),
        );
        expect(q2.duration, equals(Duration(days: 91)));

        // Q3: Jul(31) + Aug(31) + Sep(30) = 92 days.
        final q3 = TrimesterPeriod(
          start: DateTime(2024, 7, 1),
          end: DateTime(2024, 9, 30, 23, 59, 59, 999, 999),
        );
        expect(q3.duration, equals(Duration(days: 92)));

        // Q4: Oct(31) + Nov(30) + Dec(31) = 92 days.
        final q4 = TrimesterPeriod(
          start: DateTime(2024, 10, 1),
          end: DateTime(2024, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(q4.duration, equals(Duration(days: 92)));
      });

      test('Start and end are properly set', () {
        final trimester = TrimesterPeriod(
          start: DateTime(2024, 1, 1),
          end: DateTime(2024, 3, 31, 23, 59, 59, 999, 999),
        );
        expect(trimester.start.day, equals(1));
        // Q1 starts in January.
        expect(trimester.start.month, equals(1));
        expect(trimester.end.day, equals(31));
        // Q1 ends in March.
        expect(trimester.end.month, equals(3));
      });
    });

    group('Months property', () {
      test('Returns 3 MonthPeriod objects', () {
        final trimester = TrimesterPeriod(
          start: DateTime(2020, 1, 1),
          end: DateTime(2020, 3, 31, 23, 59, 59, 999, 999),
        );
        final months = trimester.months;
        expect(months, isA<List<MonthPeriod>>());
        expect(months, hasLength(3));
        expect(months.every((month) => month.start.year == 2020), isTrue);
      });

      test('First month starts at trimester start', () {
        final trimester = TrimesterPeriod(
          start: DateTime(2020, 1, 1),
          end: DateTime(2020, 3, 31, 23, 59, 59, 999, 999),
        );
        final months = trimester.months;
        expect(
          months.first,
          equals(
            Period(
              start: DateTime(2020, 1, 1),
              end: DateTime(2020, 1, 31, 23, 59, 59, 999, 999),
            ),
          ),
        );
      });

      test('Last month ends at trimester end', () {
        final trimester = TrimesterPeriod(
          start: DateTime(2020, 1, 1),
          end: DateTime(2020, 3, 31, 23, 59, 59, 999, 999),
        );
        final months = trimester.months;
        expect(
          months.last,
          equals(
            Period(
              start: DateTime(2020, 3, 1),
              end: DateTime(2020, 3, 31, 23, 59, 59, 999, 999),
            ),
          ),
        );
      });

      test('Months progress correctly through trimester', () {
        // Q1.
        final trimester = TrimesterPeriod(
          start: DateTime(2024, 1, 1),
          end: DateTime(2024, 3, 31, 23, 59, 59, 999, 999),
        );
        final months = trimester.months;

        // January.
        expect(months.first.start.month, equals(1));
        // February.
        expect(months[1].start.month, equals(2));
        // March.
        expect(months[2].start.month, equals(3));
      });

      test('Months cover entire trimester with no gaps', () {
        // Q2.
        final trimester = TrimesterPeriod(
          start: DateTime(2024, 4, 1),
          end: DateTime(2024, 6, 30, 23, 59, 59, 999, 999),
        );
        final months = trimester.months;

        // Check no gaps between consecutive months.
        for (var i = 0; i < months.length - 1; i++) {
          final currentEnd = months[i].end;
          final nextStart = months[i + 1].start;
          expect(
            nextStart.difference(currentEnd),
            equals(Duration(microseconds: 1)),
          );
        }
      });
    });

    group('Trimester progression', () {
      test('Q1 contains January, February, March', () {
        final q1 = TrimesterPeriod(
          start: DateTime(2024, 1, 1),
          end: DateTime(2024, 3, 31, 23, 59, 59, 999, 999),
        );
        final months = q1.months;

        expect(months.first.start.month, equals(1));
        expect(months[1].start.month, equals(2));
        expect(months[2].start.month, equals(3));
      });

      test('Q2 contains April, May, June', () {
        final q2 = TrimesterPeriod(
          start: DateTime(2024, 4, 1),
          end: DateTime(2024, 6, 30, 23, 59, 59, 999, 999),
        );
        final months = q2.months;

        expect(months.first.start.month, equals(4));
        expect(months[1].start.month, equals(5));
        expect(months[2].start.month, equals(6));
      });

      test('Q3 contains July, August, September', () {
        final q3 = TrimesterPeriod(
          start: DateTime(2024, 7, 1),
          end: DateTime(2024, 9, 30, 23, 59, 59, 999, 999),
        );
        final months = q3.months;

        expect(months.first.start.month, equals(7));
        expect(months[1].start.month, equals(8));
        expect(months[2].start.month, equals(9));
      });

      test('Q4 contains October, November, December', () {
        final q4 = TrimesterPeriod(
          start: DateTime(2024, 10, 1),
          end: DateTime(2024, 12, 31, 23, 59, 59, 999, 999),
        );
        final months = q4.months;

        expect(months.first.start.month, equals(10));
        expect(months[1].start.month, equals(11));
        expect(months[2].start.month, equals(12));
      });
    });

    group('Edge cases', () {
      test('Handles leap year February correctly in Q1', () {
        // Leap year.
        final q1_2024 = TrimesterPeriod(
          start: DateTime(2024, 1, 1),
          end: DateTime(2024, 3, 31, 23, 59, 59, 999, 999),
        );
        // Non-leap year.
        final q1_2023 = TrimesterPeriod(
          start: DateTime(2023, 1, 1),
          end: DateTime(2023, 3, 31, 23, 59, 59, 999, 999),
        );

        // 31+29+31.
        expect(q1_2024.duration.inDays, equals(91));
        // 31+28+31.
        expect(q1_2023.duration.inDays, equals(90));
      });

      test('Works across year boundaries', () {
        // This tests Q4 trimester.
        final q4 = TrimesterPeriod(
          start: DateTime(2024, 10, 1),
          end: DateTime(2024, 12, 31, 23, 59, 59, 999, 999),
        );
        final months = q4.months;

        expect(months, hasLength(3));
        // October.
        expect(months.first.start.month, equals(10));
        // November.
        expect(months[1].start.month, equals(11));
        // December.
        expect(months[2].start.month, equals(12));
      });

      test('All months have correct year', () {
        final trimester = TrimesterPeriod(
          start: DateTime(2024, 7, 1),
          end: DateTime(2024, 9, 30, 23, 59, 59, 999, 999),
        );
        final months = trimester.months;

        for (final month in months) {
          expect(month.start.year, equals(2024));
          expect(month.end.year, equals(2024));
        }
      });
    });

    group('Equality', () {
      final start1 = DateTime(2024);
      final end1 = DateTime(2024, 3, 31, 23, 59, 59, 999, 999);
      final trimester1 = TrimesterPeriod(start: start1, end: end1);

      final start2 = DateTime(2024, 4);
      final end2 = DateTime(2024, 6, 30, 23, 59, 59, 999, 999);
      final trimester2 = TrimesterPeriod(start: start2, end: end2);

      final trimester3 = TrimesterPeriod(start: start1, end: end1);

      test('Same instance equals itself', () {
        expect(trimester1, equals(trimester1));
      });

      test('Different trimesters are not equal', () {
        expect(trimester1, isNot(equals(trimester2)));
      });

      test('Same start and end dates are equal', () {
        expect(trimester1, equals(trimester3));
      });

      test('HashCode is consistent', () {
        expect(trimester1.hashCode, equals(trimester3.hashCode));
        expect(trimester1.hashCode, isNot(equals(trimester2.hashCode)));
      });
    });
  });
}
