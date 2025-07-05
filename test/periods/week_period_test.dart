// ignore_for_file: prefer_const_constructors

import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('WeekPeriod:', () {
    group('Constructor', () {
      group('Valid cases', () {
        test('Creates WeekPeriod with valid start and end', () {
          // Monday.
          final start = DateTime(2024, 1, 15);
          // Sunday.
          final end = DateTime(2024, 1, 21, 23, 59, 59, 999, 999);
          expect(WeekPeriod(start: start, end: end), isNotNull);
        });

        test('Creates WeekPeriod with UTC dates', () {
          // Monday.
          final start = DateTime.utc(2024, 1, 15);
          // Sunday.
          final end = DateTime.utc(2024, 1, 21, 23, 59, 59, 999, 999);
          expect(WeekPeriod(start: start, end: end), isNotNull);
        });
      });

      group('Validation errors', () {
        test('Throws AssertionError if duration is not exactly 7 days', () {
          final start = DateTime(2024, 1, 15);
          // 8 days.
          final end = DateTime(2024, 1, 22, 23, 59, 59, 999, 999);
          expect(
            () => WeekPeriod(start: start, end: end),
            throwsA(isA<AssertionError>()),
          );
        });

        test('Throws ArgumentError if end is not last microsecond of last day',
            () {
          final start = DateTime(2024, 1, 15);
          final end = DateTime(2024, 1, 21, 23, 59, 59, 999, 998);
          expect(
            () => WeekPeriod(start: start, end: end),
            throwsArgumentError,
          );
        });
      });
    });

    group('Properties', () {
      test('Duration is exactly 7 days', () {
        // Monday Jan 15, 2024 to Sunday Jan 21, 2024.
        final week = WeekPeriod(
          start: DateTime(2024, 1, 15),
          end: DateTime(2024, 1, 21, 23, 59, 59, 999, 999),
        );
        expect(week.duration, equals(Duration(days: 7)));
      });

      test('Start and end are properly set', () {
        // Monday Jan 15, 2024 to Sunday Jan 21, 2024.
        final week = WeekPeriod(
          start: DateTime(2024, 1, 15),
          end: DateTime(2024, 1, 21, 23, 59, 59, 999, 999),
        );
        expect(week.start.weekday, equals(DateTime.monday));
        expect(week.end.weekday, equals(DateTime.sunday));
      });
    });

    group('Days property', () {
      test('Returns 7 DayPeriod objects', () {
        // Monday Dec 30, 2019 to Sunday Jan 5, 2020.
        final week = WeekPeriod(
          start: DateTime(2019, 12, 30),
          end: DateTime(2020, 1, 5, 23, 59, 59, 999, 999),
        );
        final days = week.days;
        expect(days, isA<List<DayPeriod>>());
        expect(days, hasLength(7));
        expect(
          days.every(
            (day) => day.start.weekday >= 1 && day.start.weekday <= 7,
          ),
          isTrue,
        );
      });

      test('First day starts at week start', () {
        // Monday Dec 30, 2019 to Sunday Jan 5, 2020.
        final week = WeekPeriod(
          start: DateTime(2019, 12, 30),
          end: DateTime(2020, 1, 5, 23, 59, 59, 999, 999),
        );
        final days = week.days;
        expect(
          days.first,
          equals(
            Period(
              // Monday of that week.
              start: DateTime(2019, 12, 30),
              end: DateTime(2019, 12, 30, 23, 59, 59, 999, 999),
            ),
          ),
        );
      });

      test('Last day ends at week end', () {
        // Monday Dec 30, 2019 to Sunday Jan 5, 2020.
        final week = WeekPeriod(
          start: DateTime(2019, 12, 30),
          end: DateTime(2020, 1, 5, 23, 59, 59, 999, 999),
        );
        final days = week.days;
        expect(
          days.last,
          equals(
            Period(
              // Sunday of that week.
              start: DateTime(2020, 1, 5),
              end: DateTime(2020, 1, 5, 23, 59, 59, 999, 999),
            ),
          ),
        );
      });

      test('Days progress from Monday to Sunday', () {
        // Monday Jan 15, 2024 to Sunday Jan 21, 2024.
        final week = WeekPeriod(
          start: DateTime(2024, 1, 15),
          end: DateTime(2024, 1, 21, 23, 59, 59, 999, 999),
        );
        final days = week.days;

        expect(days.first.start.weekday, equals(DateTime.monday));
        expect(days[1].start.weekday, equals(DateTime.tuesday));
        expect(days[2].start.weekday, equals(DateTime.wednesday));
        expect(days[3].start.weekday, equals(DateTime.thursday));
        expect(days[4].start.weekday, equals(DateTime.friday));
        expect(days[5].start.weekday, equals(DateTime.saturday));
        expect(days[6].start.weekday, equals(DateTime.sunday));
      });

      test('Days cover entire week with no gaps', () {
        // Monday Feb 12, 2024 to Sunday Feb 18, 2024.
        final week = WeekPeriod(
          start: DateTime(2024, 2, 12),
          end: DateTime(2024, 2, 18, 23, 59, 59, 999, 999),
        );
        final days = week.days;

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
      test('Works with week crossing month boundary', () {
        // Week that crosses from January to February.
        // Monday Jan 29, 2024 to Sunday Feb 4, 2024.
        final week = WeekPeriod(
          start: DateTime(2024, 1, 29),
          end: DateTime(2024, 2, 4, 23, 59, 59, 999, 999),
        );
        final days = week.days;
        expect(days, hasLength(7));

        // Should include days from both January and February.
        // January.
        expect(days.first.start.month, equals(1));
        // February.
        expect(days.last.start.month, equals(2));
      });

      test('Works with week crossing year boundary', () {
        // Week that crosses from December to January.
        // Monday Dec 30, 2019 to Sunday Jan 5, 2020.
        final week = WeekPeriod(
          start: DateTime(2019, 12, 30),
          end: DateTime(2020, 1, 5, 23, 59, 59, 999, 999),
        );
        final days = week.days;
        expect(days, hasLength(7));

        // Should include days from both December and January.
        // December.
        expect(days.first.start.month, equals(12));
        expect(days.first.start.year, equals(2019));
        // January.
        expect(days.last.start.month, equals(1));
        expect(days.last.start.year, equals(2020));
      });

      test('Works with leap year February', () {
        // Week containing February 29, 2024.
        // Monday Feb 26, 2024 to Sunday Mar 3, 2024.
        final week = WeekPeriod(
          start: DateTime(2024, 2, 26),
          end: DateTime(2024, 3, 3, 23, 59, 59, 999, 999),
        );
        final days = week.days;
        expect(days, hasLength(7));

        // Find the day that should be Feb 29.
        final feb29Day = days.firstWhere(
          (day) => day.start.month == 2 && day.start.day == 29,
        );
        expect(feb29Day.start.day, equals(29));
      });
    });

    group('Equality', () {
      // Monday.
      final start1 = DateTime(2024, 1, 15);
      // Sunday.
      final end1 = DateTime(2024, 1, 21, 23, 59, 59, 999, 999);
      final week1 = WeekPeriod(start: start1, end: end1);

      // Next Monday.
      final start2 = DateTime(2024, 1, 22);
      // Next Sunday.
      final end2 = DateTime(2024, 1, 28, 23, 59, 59, 999, 999);
      final week2 = WeekPeriod(start: start2, end: end2);

      final week3 = WeekPeriod(start: start1, end: end1);

      test('Same instance equals itself', () {
        expect(week1, equals(week1));
      });

      test('Different weeks are not equal', () {
        expect(week1, isNot(equals(week2)));
      });

      test('Same start and end dates are equal', () {
        expect(week1, equals(week3));
      });

      test('HashCode is consistent', () {
        expect(week1.hashCode, equals(week3.hashCode));
        expect(week1.hashCode, isNot(equals(week2.hashCode)));
      });
    });
  });
}
