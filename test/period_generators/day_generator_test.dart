// ignore_for_file: prefer_const_constructors

import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('DayGenerator:', () {
    const generator = DayGenerator();

    group('Constructor', () {
      test('Creates generator instance', () {
        expect(const DayGenerator(), isNotNull);
      });
    });

    group('of', () {
      test('Start of day', () {
        final day = generator.of(DateTime(2020));
        final expected = DayPeriod(
          start: DateTime(2020),
          end: DateTime(2020, 1, 1, 23, 59, 59, 999, 999),
        );
        expect(day, equals(expected));
      });

      test('End of day', () {
        final day = generator.of(DateTime(2020, 1, 1, 23, 59, 59, 999, 999));
        final expected = DayPeriod(
          start: DateTime(2020),
          end: DateTime(2020, 1, 1, 23, 59, 59, 999, 999),
        );
        expect(day, equals(expected));
      });

      test('Middle of day', () {
        final day = generator.of(DateTime(2020, 1, 1, 12, 30));
        final expected = DayPeriod(
          start: DateTime(2020),
          end: DateTime(2020, 1, 1, 23, 59, 59, 999, 999),
        );
        expect(day, equals(expected));
      });
    });

    group('before', () {
      test('Start of day', () {
        final day = generator.of(DateTime(2020));
        final previous = generator.before(day);
        final expected = DayPeriod(
          start: DateTime(2019, 12, 31),
          end: DateTime(2019, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });

      test('End of day', () {
        final day = generator.of(DateTime(2020, 1, 1, 23, 59, 59, 999, 999));
        final previous = generator.before(day);
        final expected = DayPeriod(
          start: DateTime(2019, 12, 31),
          end: DateTime(2019, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });
    });

    group('after', () {
      test('Start of day', () {
        final day = generator.of(DateTime(2020));
        final next = generator.after(day);
        final expected = DayPeriod(
          start: DateTime(2020, 1, 2),
          end: DateTime(2020, 1, 2, 23, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });

      test('End of day', () {
        final day = generator.of(DateTime(2020, 1, 1, 23, 59, 59, 999, 999));
        final next = generator.after(day);
        final expected = DayPeriod(
          start: DateTime(2020, 1, 2),
          end: DateTime(2020, 1, 2, 23, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });
    });

    group('sub-periods', () {
      const hourGenerator = HourGenerator();
      final day = generator.of(DateTime(2020));
      final hours = day.hours;

      test('type', () {
        expect(hours, isA<List<HourPeriod>>());
      });

      test('length', () {
        expect(hours.length, equals(24));
      });

      test('Start of day', () {
        final firstHour = hourGenerator.of(DateTime(2020));
        expect(hours.first, equals(firstHour));
      });

      test('End of day', () {
        final lastHour = hourGenerator.of(
          DateTime(2020, 1, 1, 23, 59, 59, 999, 999),
        );
        expect(hours.last, equals(lastHour));
      });
    });

    group('Time component preservation', () {
      test('Maintains time components in local DateTime', () {
        final input = DateTime(2020, 1, 15, 10, 30, 45, 123, 456);
        final period = generator.of(input);
        expect(period.start.isUtc, isFalse);
        expect(period.end.isUtc, isFalse);
      });

      test('Maintains time components in UTC DateTime', () {
        final input = DateTime.utc(2020, 1, 15, 10, 30, 45, 123, 456);
        final period = generator.of(input);
        expect(period.start.isUtc, isTrue);
        expect(period.end.isUtc, isTrue);
      });
    });

    group('Edge cases', () {
      test('Leap year February 29', () {
        // February 29, 2020 is a leap year
        final period = generator.of(DateTime(2020, 2, 29));
        expect(period.start.day, equals(29));
        expect(period.end.day, equals(29));
      });

      test('Year boundary crossing', () {
        final period = generator.of(DateTime(2019, 12, 31));
        final next = generator.after(period);
        expect(next.start.year, equals(2020));
        expect(next.start.month, equals(1));
        expect(next.start.day, equals(1));
      });
    });

    test('fits generator', () {
      final period = DayPeriod(
        start: DateTime(2020),
        end: DateTime(2020, 1, 1, 23, 59, 59, 999, 999),
      );
      expect(generator.fitsGenerator(period), isTrue);
    });

    test('does not fit generator', () {
      final period = Period(
        start: DateTime(2020),
        end: DateTime(2020, 1, 2), // Wrong end date
      );
      expect(generator.fitsGenerator(period), isFalse);
    });

    group('Equality', () {
      const generator1 = DayGenerator();
      const generator2 = DayGenerator();

      test('Same instance', () {
        expect(generator1, equals(generator1));
      });

      test('Different instances with same parameters', () {
        expect(generator1, equals(generator2));
      });
    });
  });
}
