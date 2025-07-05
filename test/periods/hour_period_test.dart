// ignore_for_file: prefer_const_constructors

import 'package:collection/collection.dart';
import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('HourPeriod:', () {
    group('Constructor', () {
      group('Valid cases', () {
        test('Creates HourPeriod with valid start and end', () {
          final start = DateTime(2024, 1, 15, 14);
          final end = DateTime(2024, 1, 15, 14, 59, 59, 999, 999);
          expect(HourPeriod(start: start, end: end), isNotNull);
        });

        test('Creates HourPeriod with UTC dates', () {
          final start = DateTime.utc(2024, 1, 15, 14);
          final end = DateTime.utc(2024, 1, 15, 14, 59, 59, 999, 999);
          expect(HourPeriod(start: start, end: end), isNotNull);
        });
      });

      group('Validation errors', () {
        test('Throws AssertionError if end is in different hour', () {
          final start = DateTime(2024, 1, 15, 14);
          final end = DateTime(2024, 1, 15, 15, 59, 59, 999, 999);
          expect(
            () => HourPeriod(start: start, end: end),
            throwsA(isA<AssertionError>()),
          );
        });

        test('Throws ArgumentError if end is not last microsecond of hour', () {
          final start = DateTime(2024, 1, 15, 13, 59, 59, 999, 999);
          final end = DateTime(2024, 1, 15, 14, 59, 59, 999, 998);
          expect(
            () => HourPeriod(start: start, end: end),
            throwsArgumentError,
          );
        });

        test(
            'Throws AssertionError if duration is not exactly 59m 59s 999ms '
            '999μs', () {
          final start = DateTime(2024, 1, 15, 14);
          final end = DateTime(2024, 1, 15, 14, 59, 59, 999, 998);
          expect(
            () => HourPeriod(start: start, end: end),
            throwsA(isA<AssertionError>()),
          );
        });
      });
    });

    group('Properties', () {
      test('Duration is exactly 1 hour', () {
        final start = DateTime(2024, 1, 15, 14);
        final end = DateTime(2024, 1, 15, 14, 59, 59, 999, 999);
        final hour = HourPeriod(start: start, end: end);
        expect(hour.duration, equals(Duration(hours: 1)));
      });

      test('Start and end are properly set', () {
        final start = DateTime(2024, 1, 15, 14);
        final end = DateTime(2024, 1, 15, 14, 59, 59, 999, 999);
        final hour = HourPeriod(start: start, end: end);
        expect(hour.start, equals(start));
        expect(hour.end, equals(end));
      });
    });

    group('Minutes property', () {
      test('Returns 60 MinutePeriod objects', () {
        final start = DateTime(2020);
        final end = DateTime(2020, 1, 1, 0, 59, 59, 999, 999);
        final hour = HourPeriod(start: start, end: end);
        const oneMinute = Duration(minutes: 1);
        final minutes = hour.minutes;
        expect(minutes, isA<List<MinutePeriod>>());
        expect(minutes, hasLength(60));
        expect(minutes.none((minute) => minute.duration != oneMinute), isTrue);
      });

      test('First minute starts at hour start', () {
        final start = DateTime(2020);
        final end = DateTime(2020, 1, 1, 0, 59, 59, 999, 999);
        final hour = HourPeriod(start: start, end: end);
        final minutes = hour.minutes;
        expect(
          minutes.first,
          equals(
            Period(
              start: DateTime(2020),
              end: DateTime(2020, 1, 1, 0, 0, 59, 999, 999),
            ),
          ),
        );
      });

      test('Last minute ends at hour end', () {
        final start = DateTime(2020);
        final end = DateTime(2020, 1, 1, 0, 59, 59, 999, 999);
        final hour = HourPeriod(start: start, end: end);
        final minutes = hour.minutes;
        expect(
          minutes.last,
          equals(
            Period(
              start: DateTime(2020, 1, 1, 0, 59),
              end: DateTime(2020, 1, 1, 0, 59, 59, 999, 999),
            ),
          ),
        );
      });

      test('All minutes fit MinuteGenerator', () {
        const minuteGenerator = MinuteGenerator();
        final start = DateTime(2020, 3, 15, 10);
        final end = DateTime(2020, 3, 15, 10, 59, 59, 999, 999);
        final hour = HourPeriod(start: start, end: end);
        final minutes = hour.minutes;
        expect(
          minutes.none((minute) => !minuteGenerator.fitsGenerator(minute)),
          isTrue,
        );
      });

      test('Minutes cover entire hour with no gaps', () {
        final start = DateTime(2020, 7, 4, 15);
        final end = DateTime(2020, 7, 4, 15, 59, 59, 999, 999);
        final hour = HourPeriod(start: start, end: end);
        final minutes = hour.minutes;

        // Check no gaps between consecutive minutes.
        for (var i = 0; i < minutes.length - 1; i++) {
          final currentEnd = minutes[i].end;
          final nextStart = minutes[i + 1].start;
          expect(
            nextStart.difference(currentEnd),
            equals(Duration(microseconds: 1)),
          );
        }
      });
    });

    group('Edge cases', () {
      test('Works with midnight hour', () {
        final start = DateTime(2024);
        final end = DateTime(2024, 1, 1, 0, 59, 59, 999, 999);
        final hour = HourPeriod(start: start, end: end);
        expect(hour.minutes, hasLength(60));
        expect(hour.start.hour, equals(0));
      });

      test('Works with last hour of day', () {
        final start = DateTime(2024, 1, 1, 23);
        final end = DateTime(2024, 1, 1, 23, 59, 59, 999, 999);
        final hour = HourPeriod(start: start, end: end);
        expect(hour.minutes, hasLength(60));
        expect(hour.start.hour, equals(23));
      });

      test('Works during daylight saving time transition', () {
        // 2 AM on DST change day (may vary by timezone).
        final start = DateTime(2024, 3, 10, 2);
        final end = DateTime(2024, 3, 10, 2, 59, 59, 999, 999);
        final hour = HourPeriod(start: start, end: end);
        expect(hour.minutes, hasLength(60));
      });
    });

    group('Equality', () {
      final start1 = DateTime(2024, 1, 15, 14);
      final end1 = DateTime(2024, 1, 15, 14, 59, 59, 999, 999);
      final hour1 = HourPeriod(start: start1, end: end1);

      final start2 = DateTime(2024, 1, 15, 15);
      final end2 = DateTime(2024, 1, 15, 15, 59, 59, 999, 999);
      final hour2 = HourPeriod(start: start2, end: end2);

      final hour3 = HourPeriod(start: start1, end: end1);

      test('Same instance equals itself', () {
        expect(hour1, equals(hour1));
      });

      test('Different hours are not equal', () {
        expect(hour1, isNot(equals(hour2)));
      });

      test('Same start and end dates are equal', () {
        expect(hour1, equals(hour3));
      });

      test('HashCode is consistent', () {
        expect(hour1.hashCode, equals(hour3.hashCode));
        expect(hour1.hashCode, isNot(equals(hour2.hashCode)));
      });
    });
  });
}
