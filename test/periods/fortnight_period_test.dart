import 'package:collection/collection.dart';
import 'package:due_date/period.dart';
import 'package:test/test.dart';

import '../src/date_time_match.dart';

void main() {
  group('FortnightPeriod:', () {
    group('Constructor', () {
      group('Valid cases', () {
        test('Creates FortnightPeriod with valid start and end', () {
          final start = DateTime(2024);
          // First half of January (1st-15th).
          final end = DateTime(2024, 1, 15, 23, 59, 59, 999, 999);
          expect(FortnightPeriod(start: start, end: end), isNotNull);
        });

        test('Creates FortnightPeriod with UTC dates', () {
          final start = DateTime.utc(2024, 1, 16);
          // Second half of January (16th-31st).
          final end = DateTime.utc(2024, 1, 31, 23, 59, 59, 999, 999);
          expect(FortnightPeriod(start: start, end: end), isNotNull);
        });
      });

      group('Validation errors', () {
        test('Throws ArgumentError if duration is not exactly 15 days', () {
          final start = DateTime(2024);
          // Invalid: trying to end on 16th instead of 15th.
          final end = DateTime(2024, 1, 16, 23, 59, 59, 999, 999);
          expect(
            () => FortnightPeriod(start: start, end: end),
            throwsArgumentError,
          );
        });

        test('Throws ArgumentError if duration is less than 15 days', () {
          final start = DateTime(2024);
          // Invalid: trying to end on 14th instead of 15th.
          final end = DateTime(2024, 1, 14, 23, 59, 59, 999, 999);
          expect(
            () => FortnightPeriod(start: start, end: end),
            throwsArgumentError,
          );
        });

        test('Throws ArgumentError if end is not last microsecond of 15th day',
            () {
          final start = DateTime(2024);
          final end = DateTime(2024, 1, 15, 23, 59, 59, 999, 998);
          expect(
            () => FortnightPeriod(start: start, end: end),
            throwsArgumentError,
          );
        });
      });
    });

    group('Properties', () {
      test('Duration is calculated correctly', () {
        final start = DateTime(2024);
        final end = DateTime(2024, 1, 15, 23, 59, 59, 999, 999);
        final fortnight = FortnightPeriod(start: start, end: end);
        expect(fortnight.duration, equals(const Duration(days: 15)));
      });

      test('Start and end are properly set', () {
        final start = DateTime(2024);
        final end = DateTime(2024, 1, 15, 23, 59, 59, 999, 999);
        final fortnight = FortnightPeriod(start: start, end: end);
        expect(fortnight.start, isSameDateTime(start));
        expect(fortnight.end, isSameDateTime(end));
      });

      test('Duration varies correctly for different periods', () {
        // First half of January: 15 days.
        final jan1To15 = FortnightPeriod(
          start: DateTime(2024),
          end: DateTime(2024, 1, 15, 23, 59, 59, 999, 999),
        );
        expect(jan1To15.duration, equals(const Duration(days: 15)));

        // Second half of January: 16 days.
        final jan16To31 = FortnightPeriod(
          start: DateTime(2024, 1, 16),
          end: DateTime(2024, 1, 31, 23, 59, 59, 999, 999),
        );
        expect(jan16To31.duration, equals(const Duration(days: 16)));

        // Second half of February (leap year): 14 days.
        final feb16To29 = FortnightPeriod(
          start: DateTime(2024, 2, 16),
          end: DateTime(2024, 2, 29, 23, 59, 59, 999, 999),
        );
        expect(feb16To29.duration, equals(const Duration(days: 14)));
      });
    });

    group('Days property', () {
      test('Returns correct number of DayPeriod objects', () {
        const dayGenerator = DayGenerator();

        // First half of January: 15 days.
        final jan1To15 = FortnightPeriod(
          start: DateTime(2024),
          end: DateTime(2024, 1, 15, 23, 59, 59, 999, 999),
        );
        final days1 = jan1To15.days;
        expect(days1, isA<List<DayPeriod>>());
        expect(days1, hasLength(15));
        expect(days1.none((day) => !dayGenerator.fitsGenerator(day)), isTrue);

        // Second half of January: 16 days.
        final jan16To31 = FortnightPeriod(
          start: DateTime(2024, 1, 16),
          end: DateTime(2024, 1, 31, 23, 59, 59, 999, 999),
        );
        final days2 = jan16To31.days;
        expect(days2, isA<List<DayPeriod>>());
        expect(days2, hasLength(16));
        expect(days2.none((day) => !dayGenerator.fitsGenerator(day)), isTrue);
      });

      test('First day starts at fortnight start', () {
        final fortnight = FortnightPeriod(
          start: DateTime(2024),
          end: DateTime(2024, 1, 15, 23, 59, 59, 999, 999),
        );
        final days = fortnight.days;
        expect(
          days.first,
          equals(
            Period(
              start: DateTime(2024),
              end: DateTime(2024, 1, 1, 23, 59, 59, 999, 999),
            ),
          ),
        );
      });

      test('Last day ends at fortnight end', () {
        final fortnight = FortnightPeriod(
          start: DateTime(2024),
          end: DateTime(2024, 1, 15, 23, 59, 59, 999, 999),
        );
        final days = fortnight.days;
        expect(
          days.last,
          equals(
            Period(
              start: DateTime(2024, 1, 15),
              end: DateTime(2024, 1, 15, 23, 59, 59, 999, 999),
            ),
          ),
        );
      });

      test('Days progress sequentially', () {
        final fortnight = FortnightPeriod(
          start: DateTime(2024, 3),
          end: DateTime(2024, 3, 15, 23, 59, 59, 999, 999),
        );
        final days = fortnight.days;

        expect(days, hasLength(15));
        for (var i = 0; i < days.length; i++) {
          final expectedDate = DateTime(2024, 3).add(Duration(days: i));
          expect(days[i].start.year, equals(expectedDate.year));
          expect(days[i].start.month, equals(expectedDate.month));
          expect(days[i].start.day, equals(expectedDate.day));
        }
      });

      test('Days cover entire fortnight with no gaps', () {
        final fortnight = FortnightPeriod(
          start: DateTime(2024, 2),
          end: DateTime(2024, 2, 15, 23, 59, 59, 999, 999),
        );
        final days = fortnight.days;

        // Check no gaps between consecutive days.
        for (var i = 0; i < days.length - 1; i++) {
          final currentEnd = days[i].end;
          final nextStart = days[i + 1].start;
          expect(
            nextStart.difference(currentEnd),
            equals(const Duration(microseconds: 1)),
          );
        }
      });
    });

    group('Edge cases', () {
      test('Works with different fortnight lengths', () {
        // First half of January: 15 days.
        final jan1To15 = FortnightPeriod(
          start: DateTime(2024),
          end: DateTime(2024, 1, 15, 23, 59, 59, 999, 999),
        );
        expect(jan1To15.days, hasLength(15));

        // Second half of January: 16 days.
        final jan16To31 = FortnightPeriod(
          start: DateTime(2024, 1, 16),
          end: DateTime(2024, 1, 31, 23, 59, 59, 999, 999),
        );
        expect(jan16To31.days, hasLength(16));

        // Second half of February (leap year): 14 days.
        final feb16To29 = FortnightPeriod(
          start: DateTime(2024, 2, 16),
          end: DateTime(2024, 2, 29, 23, 59, 59, 999, 999),
        );
        expect(feb16To29.days, hasLength(14));
      });

      test('Handles leap year February correctly', () {
        // Second half of February 2024 (leap year).
        final feb16To29 = FortnightPeriod(
          start: DateTime(2024, 2, 16),
          end: DateTime(2024, 2, 29, 23, 59, 59, 999, 999),
        );
        final days = feb16To29.days;
        expect(days, hasLength(14));

        // Should include February 29.
        final feb29Day = days.firstWhereOrNull(
          (day) => day.start.month == 2 && day.start.day == 29,
        );
        expect(feb29Day, isNotNull);
      });

      test('Works with different months', () {
        // Test first half of different months (all should be 15 days).

        // January: 15 days (1st-15th).
        final jan1To15 = FortnightPeriod(
          start: DateTime(2024),
          end: DateTime(2024, 1, 15, 23, 59, 59, 999, 999),
        );
        expect(jan1To15.days, hasLength(15));

        // March: 15 days (1st-15th).
        final mar1To15 = FortnightPeriod(
          start: DateTime(2024, 3),
          end: DateTime(2024, 3, 15, 23, 59, 59, 999, 999),
        );
        expect(mar1To15.days, hasLength(15));

        // June: 15 days (1st-15th).
        final jun1To15 = FortnightPeriod(
          start: DateTime(2024, 6),
          end: DateTime(2024, 6, 15, 23, 59, 59, 999, 999),
        );
        expect(jun1To15.days, hasLength(15));

        // September: 15 days (1st-15th).
        final sep1To15 = FortnightPeriod(
          start: DateTime(2024, 9),
          end: DateTime(2024, 9, 15, 23, 59, 59, 999, 999),
        );
        expect(sep1To15.days, hasLength(15));

        // Test second half of different months (variable lengths).

        // January: 16 days (16th-31st).
        final jan16To31 = FortnightPeriod(
          start: DateTime(2024, 1, 16),
          end: DateTime(2024, 1, 31, 23, 59, 59, 999, 999),
        );
        expect(jan16To31.days, hasLength(16));

        // February (leap year): 14 days (16th-29th).
        final feb16To29 = FortnightPeriod(
          start: DateTime(2024, 2, 16),
          end: DateTime(2024, 2, 29, 23, 59, 59, 999, 999),
        );
        expect(feb16To29.days, hasLength(14));

        // April: 15 days (16th-30th).
        final apr16To30 = FortnightPeriod(
          start: DateTime(2024, 4, 16),
          end: DateTime(2024, 4, 30, 23, 59, 59, 999, 999),
        );
        expect(apr16To30.days, hasLength(15));

        // December: 16 days (16th-31st).
        final dec16To31 = FortnightPeriod(
          start: DateTime(2024, 12, 16),
          end: DateTime(2024, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(dec16To31.days, hasLength(16));
      });
    });

    group('Equality', () {
      final start1 = DateTime(2024);
      final end1 = DateTime(2024, 1, 15, 23, 59, 59, 999, 999);
      final fortnight1 = FortnightPeriod(start: start1, end: end1);

      final start2 = DateTime(2024, 1, 16);
      final end2 = DateTime(2024, 1, 31, 23, 59, 59, 999, 999);
      final fortnight2 = FortnightPeriod(start: start2, end: end2);

      final fortnight3 = FortnightPeriod(start: start1, end: end1);

      test('Same instance equals itself', () {
        expect(fortnight1, equals(fortnight1));
      });

      test('Different fortnights are not equal', () {
        expect(fortnight1, isNot(equals(fortnight2)));
      });

      test('Same start and end dates are equal', () {
        expect(fortnight1, equals(fortnight3));
      });

      test('HashCode is consistent', () {
        expect(fortnight1.hashCode, equals(fortnight3.hashCode));
        expect(fortnight1.hashCode, isNot(equals(fortnight2.hashCode)));
      });
    });
  });
}
