import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('SecondPeriod:', () {
    group('Constructor', () {
      group('Valid cases', () {
        test('Creates SecondPeriod with valid start and end', () {
          final start = DateTime(2024, 1, 15, 14, 30, 45);
          final end = DateTime(2024, 1, 15, 14, 30, 45, 999, 999);
          expect(SecondPeriod(start: start, end: end), isNotNull);
        });

        test('Creates SecondPeriod with UTC dates', () {
          final start = DateTime.utc(2024, 1, 15, 14, 30, 45);
          final end = DateTime.utc(2024, 1, 15, 14, 30, 45, 999, 999);
          expect(SecondPeriod(start: start, end: end), isNotNull);
        });
      });

      group('Validation errors', () {
        test('Throws AssertionError if end is in different second', () {
          final start = DateTime(2024, 1, 15, 14, 30, 45);
          final end = DateTime(2024, 1, 15, 14, 30, 46, 999, 999);
          expect(
            () => SecondPeriod(start: start, end: end),
            throwsA(isA<AssertionError>()),
          );
        });

        test('Throws ArgumentError if end is not last microsecond of second',
            () {
          final start = DateTime(2024, 1, 15, 14, 30, 44, 999, 999);
          final end = DateTime(2024, 1, 15, 14, 30, 45, 999, 998);
          expect(
            () => SecondPeriod(start: start, end: end),
            throwsArgumentError,
          );
        });

        test('Throws ArgumentError if end is not in same second as start', () {
          final start = DateTime(2024, 7, 1, 14, 30, 44, 000, 001);
          final end = DateTime(2024, 7, 1, 14, 30, 45);
          expect(
            () => SecondPeriod(start: start, end: end),
            throwsArgumentError,
          );
        });

        test('Throws ArgumentError if end is before start', () {
          final start = DateTime(2024, 1, 15, 14, 30, 45, 999, 999);
          final end = DateTime(2024, 1, 15, 14, 30, 45);
          expect(
            () => SecondPeriod(start: start, end: end),
            throwsArgumentError,
          );
        });
      });
    });

    group('Properties', () {
      test('Duration is exactly 1 second', () {
        final start = DateTime(2024, 1, 15, 14, 30, 45);
        final end = DateTime(2024, 1, 15, 14, 30, 45, 999, 999);
        final period = SecondPeriod(start: start, end: end);
        expect(period.duration, equals(const Duration(seconds: 1)));
      });

      test('Start and end are preserved', () {
        final start = DateTime(2024, 1, 15, 14, 30, 45);
        final end = DateTime(2024, 1, 15, 14, 30, 45, 999, 999);
        final period = SecondPeriod(start: start, end: end);
        expect(period.start, equals(start));
        expect(period.end, equals(end));
      });

      test('Contains start datetime', () {
        final start = DateTime(2024, 1, 15, 14, 30, 45);
        final end = DateTime(2024, 1, 15, 14, 30, 45, 999, 999);
        final period = SecondPeriod(start: start, end: end);
        expect(period.contains(start), isTrue);
      });

      test('Contains end datetime', () {
        final start = DateTime(2024, 1, 15, 14, 30, 45);
        final end = DateTime(2024, 1, 15, 14, 30, 45, 999, 999);
        final period = SecondPeriod(start: start, end: end);
        expect(period.contains(end), isTrue);
      });

      test('Contains datetime within the second', () {
        final start = DateTime(2024, 1, 15, 14, 30, 45);
        final end = DateTime(2024, 1, 15, 14, 30, 45, 999, 999);
        final period = SecondPeriod(start: start, end: end);
        final middle = DateTime(2024, 1, 15, 14, 30, 45, 500);
        expect(period.contains(middle), isTrue);
      });

      test('Does not contain datetime outside the second', () {
        final start = DateTime(2024, 1, 15, 14, 30, 45);
        final end = DateTime(2024, 1, 15, 14, 30, 45, 999, 999);
        final period = SecondPeriod(start: start, end: end);
        final outside = DateTime(2024, 1, 15, 14, 30, 46);
        expect(period.contains(outside), isFalse);
      });
    });

    group('Comparison', () {
      test('Two SecondPeriods with same start and end are equal', () {
        final start = DateTime(2024, 1, 15, 14, 30, 45);
        final end = DateTime(2024, 1, 15, 14, 30, 45, 999, 999);
        final period1 = SecondPeriod(start: start, end: end);
        final period2 = SecondPeriod(start: start, end: end);
        expect(period1, equals(period2));
      });

      test('Two SecondPeriods with different start are not equal', () {
        final start1 = DateTime(2024, 1, 15, 14, 30, 45);
        final start2 = DateTime(2024, 1, 15, 14, 30, 46);
        final end1 = DateTime(2024, 1, 15, 14, 30, 45, 999, 999);
        final end2 = DateTime(2024, 1, 15, 14, 30, 46, 999, 999);
        final period1 = SecondPeriod(start: start1, end: end1);
        final period2 = SecondPeriod(start: start2, end: end2);
        expect(period1, isNot(equals(period2)));
      });
    });
  });
}
