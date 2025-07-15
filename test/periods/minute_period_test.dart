import 'package:collection/collection.dart';
import 'package:due_date/period.dart';
import 'package:test/test.dart';

import '../src/date_time_match.dart';

void main() {
  group('MinutePeriod:', () {
    group('Constructor', () {
      group('Valid cases', () {
        test('Creates MinutePeriod with valid start and end', () {
          final start = DateTime(2024, 1, 15, 14, 30);
          final end = DateTime(2024, 1, 15, 14, 30, 59, 999, 999);
          expect(MinutePeriod(start: start, end: end), isNotNull);
        });

        test('Creates MinutePeriod with UTC dates', () {
          final start = DateTime.utc(2024, 1, 15, 14, 30);
          final end = DateTime.utc(2024, 1, 15, 14, 30, 59, 999, 999);
          expect(MinutePeriod(start: start, end: end), isNotNull);
        });
      });

      group('Validation errors', () {
        test('Throws AssertionError if end is in different minute', () {
          final start = DateTime(2024, 1, 15, 14, 30);
          final end = DateTime(2024, 1, 15, 14, 31, 59, 999, 999);
          expect(
            () => MinutePeriod(start: start, end: end),
            throwsA(isA<AssertionError>()),
          );
        });

        test('Throws ArgumentError if end is not last microsecond of minute',
            () {
          final start = DateTime(2024, 1, 15, 14, 29, 59, 999, 999);
          final end = DateTime(2024, 1, 15, 14, 30, 59, 999, 998);
          expect(
            () => MinutePeriod(start: start, end: end),
            throwsArgumentError,
          );
        });
      });
    });

    group('Properties', () {
      test('Duration is exactly 1 minute', () {
        final start = DateTime(2024, 1, 15, 14, 30);
        final end = DateTime(2024, 1, 15, 14, 30, 59, 999, 999);
        final minute = MinutePeriod(start: start, end: end);
        expect(minute.duration, equals(const Duration(minutes: 1)));
      });

      test('Start and end are properly set', () {
        final start = DateTime(2024, 1, 15, 14, 30);
        final end = DateTime(2024, 1, 15, 14, 30, 59, 999, 999);
        final minute = MinutePeriod(start: start, end: end);
        expect(minute.start, isSameDateTime(start));
        expect(minute.end, isSameDateTime(end));
      });
    });

    group('Seconds property', () {
      test('Returns 60 SecondPeriod objects', () {
        final start = DateTime(2020);
        final end = DateTime(2020, 1, 1, 0, 0, 59, 999, 999);
        final minute = MinutePeriod(start: start, end: end);
        const oneSecond = Duration(seconds: 1);
        final seconds = minute.seconds;
        expect(seconds, isA<List<SecondPeriod>>());
        expect(seconds, hasLength(60));
        expect(seconds.none((second) => second.duration != oneSecond), isTrue);
      });

      test('First second starts at minute start', () {
        final start = DateTime(2020);
        final end = DateTime(2020, 1, 1, 0, 0, 59, 999, 999);
        final minute = MinutePeriod(start: start, end: end);
        final seconds = minute.seconds;
        expect(
          seconds.first,
          equals(
            Period(
              start: DateTime(2020),
              end: DateTime(2020, 1, 1, 0, 0, 0, 999, 999),
            ),
          ),
        );
      });

      test('Last second ends at minute end', () {
        final start = DateTime(2020);
        final end = DateTime(2020, 1, 1, 0, 0, 59, 999, 999);
        final minute = MinutePeriod(start: start, end: end);
        final seconds = minute.seconds;
        expect(
          seconds.last,
          equals(
            Period(
              start: DateTime(2020, 1, 1, 0, 0, 59),
              end: DateTime(2020, 1, 1, 0, 0, 59, 999, 999),
            ),
          ),
        );
      });

      test('All seconds fit SecondGenerator', () {
        const secondGenerator = SecondGenerator();
        final start = DateTime(2020, 3, 15, 10, 45);
        final end = DateTime(2020, 3, 15, 10, 45, 59, 999, 999);
        final minute = MinutePeriod(start: start, end: end);
        final seconds = minute.seconds;
        expect(
          seconds.none((second) => !secondGenerator.fitsGenerator(second)),
          isTrue,
        );
      });

      test('Seconds cover entire minute with no gaps', () {
        final start = DateTime(2020, 7, 4, 15, 32);
        final end = DateTime(2020, 7, 4, 15, 32, 59, 999, 999);
        final minute = MinutePeriod(start: start, end: end);
        final seconds = minute.seconds;

        // Check no gaps between consecutive seconds.
        for (var i = 0; i < seconds.length - 1; i++) {
          final currentEnd = seconds[i].end;
          final nextStart = seconds[i + 1].start;
          expect(
            nextStart.difference(currentEnd),
            equals(const Duration(microseconds: 1)),
          );
        }
      });
    });

    group('Edge cases', () {
      test('Works with first minute of hour', () {
        final start = DateTime(2024);
        final end = DateTime(2024, 1, 1, 0, 0, 59, 999, 999);
        final minute = MinutePeriod(start: start, end: end);
        expect(minute.seconds, hasLength(60));
        expect(minute.start.minute, equals(0));
      });

      test('Works with last minute of hour', () {
        final start = DateTime(2024, 1, 1, 23, 59);
        final end = DateTime(2024, 1, 1, 23, 59, 59, 999, 999);
        final minute = MinutePeriod(start: start, end: end);
        expect(minute.seconds, hasLength(60));
        expect(minute.start.minute, equals(59));
      });

      test('Works at leap second boundary', () {
        // December 31, 2016 23:59 (leap second year).
        final start = DateTime(2016, 12, 31, 23, 59);
        final end = DateTime(2016, 12, 31, 23, 59, 59, 999, 999);
        final minute = MinutePeriod(start: start, end: end);
        expect(minute.seconds, hasLength(60));
      });
    });

    group('Equality', () {
      final start1 = DateTime(2024, 1, 15, 14, 30);
      final end1 = DateTime(2024, 1, 15, 14, 30, 59, 999, 999);
      final minute1 = MinutePeriod(start: start1, end: end1);

      final start2 = DateTime(2024, 1, 15, 14, 31);
      final end2 = DateTime(2024, 1, 15, 14, 31, 59, 999, 999);
      final minute2 = MinutePeriod(start: start2, end: end2);

      final minute3 = MinutePeriod(start: start1, end: end1);

      test('Same instance equals itself', () {
        expect(minute1, equals(minute1));
      });

      test('Different minutes are not equal', () {
        expect(minute1, isNot(equals(minute2)));
      });

      test('Same start and end dates are equal', () {
        expect(minute1, equals(minute3));
      });

      test('HashCode is consistent', () {
        expect(minute1.hashCode, equals(minute3.hashCode));
        expect(minute1.hashCode, isNot(equals(minute2.hashCode)));
      });
    });
  });
}
