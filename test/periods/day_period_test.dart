// ignore_for_file: prefer_const_constructors

import 'package:collection/collection.dart';
import 'package:due_date/period.dart';
import 'package:test/test.dart';

import '../src/date_time_match.dart';

void main() {
  group('DayPeriod:', () {
    group('Constructor', () {
      group('Valid cases', () {
        test('Creates DayPeriod with valid start and end', () {
          final start = DateTime(2024, 1, 15);
          final end = DateTime(2024, 1, 15, 23, 59, 59, 999, 999);
          expect(DayPeriod(start: start, end: end), isNotNull);
        });

        test('Creates DayPeriod with UTC dates', () {
          final start = DateTime.utc(2024, 1, 15);
          final end = DateTime.utc(2024, 1, 15, 23, 59, 59, 999, 999);
          expect(DayPeriod(start: start, end: end), isNotNull);
        });
      });

      group('Validation errors', () {
        test('Throws AssertionError if end is on different day', () {
          final start = DateTime(2024, 1, 15);
          final end = DateTime(2024, 1, 16, 23, 59, 59, 999, 999);
          expect(
            () => DayPeriod(start: start, end: end),
            throwsA(isA<AssertionError>()),
          );
        });

        test('Throws ArgumentError if end is not last microsecond of day', () {
          final start = DateTime(2024, 1, 15);
          final end = DateTime(2024, 1, 15, 23, 59, 59, 999, 998);
          expect(
            () => DayPeriod(start: start, end: end),
            throwsArgumentError,
          );
        });

        test(
            'Throws AssertionError if duration is >= 1 day and 1h (daylight '
            'savings)', () {
          final start = DateTime(2024, 1, 15);
          final end = DateTime(2024, 1, 16, 1);
          expect(
            () => DayPeriod(start: start, end: end),
            throwsA(isA<AssertionError>()),
          );
        });
      });
    });

    group('Properties', () {
      test('Duration is exactly 24 hours', () {
        final start = DateTime(2024, 1, 15);
        final end = DateTime(2024, 1, 15, 23, 59, 59, 999, 999);
        final day = DayPeriod(start: start, end: end);
        expect(day.duration, equals(Duration(days: 1)));
      });

      test('Start and end are properly set', () {
        final start = DateTime(2024, 1, 15);
        final end = DateTime(2024, 1, 15, 23, 59, 59, 999, 999);
        final day = DayPeriod(start: start, end: end);
        expect(day.start, isSameDateTime(start));
        expect(day.end, isSameDateTime(end));
      });
    });

    group('Hours property', () {
      test('Returns 24 HourPeriod objects', () {
        final start = DateTime(2020);
        final end = DateTime(2020, 1, 1, 23, 59, 59, 999, 999);
        final day = DayPeriod(start: start, end: end);
        const oneHour = Duration(hours: 1);
        final hours = day.hours;
        expect(hours, isA<List<HourPeriod>>());
        expect(hours, hasLength(24));
        expect(hours.none((hour) => hour.duration != oneHour), isTrue);
      });

      test('First hour starts at day start', () {
        final start = DateTime(2020);
        final end = DateTime(2020, 1, 1, 23, 59, 59, 999, 999);
        final day = DayPeriod(start: start, end: end);
        final hours = day.hours;
        expect(
          hours.first,
          equals(
            Period(
              start: DateTime(2020),
              end: DateTime(2020, 1, 1, 0, 59, 59, 999, 999),
            ),
          ),
        );
      });

      test('Last hour ends at day end', () {
        final start = DateTime(2020);
        final end = DateTime(2020, 1, 1, 23, 59, 59, 999, 999);
        final day = DayPeriod(start: start, end: end);
        final hours = day.hours;
        expect(
          hours.last,
          equals(
            Period(
              start: DateTime(2020, 1, 1, 23),
              end: DateTime(2020, 1, 1, 23, 59, 59, 999, 999),
            ),
          ),
        );
      });

      test('All hours fit HourGenerator', () {
        const hourGenerator = HourGenerator();
        final start = DateTime(2020, 3, 15);
        final end = DateTime(2020, 3, 15, 23, 59, 59, 999, 999);
        final day = DayPeriod(start: start, end: end);
        final hours = day.hours;
        expect(
          hours.none((hour) => !hourGenerator.fitsGenerator(hour)),
          isTrue,
        );
      });

      test('Hours cover entire day with no gaps', () {
        final start = DateTime(2020, 7, 4);
        final end = DateTime(2020, 7, 4, 23, 59, 59, 999, 999);
        final day = DayPeriod(start: start, end: end);
        final hours = day.hours;

        // Check no gaps between consecutive hours.
        for (var i = 0; i < hours.length - 1; i++) {
          final currentEnd = hours[i].end;
          final nextStart = hours[i + 1].start;
          expect(
            nextStart.difference(currentEnd),
            equals(Duration(microseconds: 1)),
          );
        }
      });
    });

    group('Edge cases', () {
      test('Works with leap year February 29', () {
        // February 29, 2024 (leap year).
        final start = DateTime(2024, 2, 29);
        final end = DateTime(2024, 2, 29, 23, 59, 59, 999, 999);
        final day = DayPeriod(start: start, end: end);
        expect(day.hours, hasLength(24));
      });

      test('Works with daylight saving time changes', () {
        // March 10, 2024 (DST change in some regions).
        final start = DateTime(2024, 3, 10);
        final end = DateTime(2024, 3, 10, 23, 59, 59, 999, 999);
        final day = DayPeriod(start: start, end: end);
        expect(day.hours, hasLength(24));
      });

      test('Works with last day of year', () {
        final start = DateTime(2023, 12, 31);
        final end = DateTime(2023, 12, 31, 23, 59, 59, 999, 999);
        final day = DayPeriod(start: start, end: end);
        expect(day.hours, hasLength(24));
        expect(day.start.day, equals(31));
        expect(day.start.month, equals(12));
      });
    });

    group('Equality', () {
      final start1 = DateTime(2024, 1, 15);
      final end1 = DateTime(2024, 1, 15, 23, 59, 59, 999, 999);
      final day1 = DayPeriod(start: start1, end: end1);

      final start2 = DateTime(2024, 1, 16);
      final end2 = DateTime(2024, 1, 16, 23, 59, 59, 999, 999);
      final day2 = DayPeriod(start: start2, end: end2);

      final day3 = DayPeriod(start: start1, end: end1);

      test('Same instance equals itself', () {
        expect(day1, equals(day1));
      });

      test('Different days are not equal', () {
        expect(day1, isNot(equals(day2)));
      });

      test('Same start and end dates are equal', () {
        expect(day1, equals(day3));
      });

      test('HashCode is consistent', () {
        expect(day1.hashCode, equals(day3.hashCode));
        expect(day1.hashCode, isNot(equals(day2.hashCode)));
      });
    });
  });
}
