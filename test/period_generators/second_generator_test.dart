// ignore_for_file: prefer_const_constructors

import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('SecondGenerator:', () {
    const generator = SecondGenerator();

    group('Constructor', () {
      test('Creates generator instance', () {
        expect(const SecondGenerator(), isNotNull);
      });
    });

    group('of', () {
      test('Start of second', () {
        final second = generator.of(DateTime(2020));
        final expected = SecondPeriod(
          start: DateTime(2020),
          end: DateTime(2020, 1, 1, 0, 0, 0, 999, 999),
        );
        expect(second, equals(expected));
      });

      test('End of second', () {
        final second = generator.of(DateTime(2020, 1, 1, 0, 0, 0, 999, 999));
        final expected = SecondPeriod(
          start: DateTime(2020),
          end: DateTime(2020, 1, 1, 0, 0, 0, 999, 999),
        );
        expect(second, equals(expected));
      });

      test('Middle of second', () {
        final second = generator.of(DateTime(2020, 1, 1, 0, 0, 0, 500, 123));
        final expected = SecondPeriod(
          start: DateTime(2020),
          end: DateTime(2020, 1, 1, 0, 0, 0, 999, 999),
        );
        expect(second, equals(expected));
      });
    });

    group('before', () {
      test('Start of second', () {
        final second = generator.of(DateTime(2020));
        final previous = generator.before(second);
        final expected = SecondPeriod(
          start: DateTime(2019, 12, 31, 23, 59, 59),
          end: DateTime(2019, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });

      test('End of second', () {
        final second = generator.of(DateTime(2020, 1, 1, 0, 0, 0, 999, 999));
        final previous = generator.before(second);
        final expected = SecondPeriod(
          start: DateTime(2019, 12, 31, 23, 59, 59),
          end: DateTime(2019, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });
    });

    group('after', () {
      test('Start of second', () {
        final second = generator.of(DateTime(2020));
        final next = generator.after(second);
        final expected = SecondPeriod(
          start: DateTime(2020, 1, 1, 0, 0, 1),
          end: DateTime(2020, 1, 1, 0, 0, 1, 999, 999),
        );
        expect(next, equals(expected));
      });

      test('End of second', () {
        final second = generator.of(DateTime(2020, 1, 1, 0, 0, 0, 999, 999));
        final next = generator.after(second);
        final expected = SecondPeriod(
          start: DateTime(2020, 1, 1, 0, 0, 1),
          end: DateTime(2020, 1, 1, 0, 0, 1, 999, 999),
        );
        expect(next, equals(expected));
      });
    });

    group('sub-periods', () {
      // Seconds don't have sub-periods in this library
      test('No sub-periods available', () {
        final second = generator.of(DateTime(2020));
        // SecondPeriod doesn't have sub-periods like milliseconds
        expect(second.duration, equals(Duration(seconds: 1)));
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
      test('Minute boundary crossing', () {
        final period = generator.of(DateTime(2020, 1, 1, 0, 0, 59));
        final next = generator.after(period);
        expect(next.start.minute, equals(1));
        expect(next.start.second, equals(0));
      });

      test('Hour boundary crossing', () {
        final period = generator.of(DateTime(2020, 1, 1, 23, 59, 59));
        final next = generator.after(period);
        expect(next.start.hour, equals(0));
        expect(next.start.day, equals(2));
      });

      test('Day boundary crossing', () {
        final period = generator.of(DateTime(2020, 1, 31, 23, 59, 59));
        final next = generator.after(period);
        expect(next.start.day, equals(1));
        expect(next.start.month, equals(2));
      });

      test('Year boundary crossing', () {
        final period = generator.of(DateTime(2019, 12, 31, 23, 59, 59));
        final next = generator.after(period);
        expect(next.start.year, equals(2020));
        expect(next.start.month, equals(1));
        expect(next.start.day, equals(1));
      });
    });

    test('fits generator', () {
      final period = SecondPeriod(
        start: DateTime(2020),
        end: DateTime(2020, 1, 1, 0, 0, 0, 999, 999),
      );
      expect(generator.fitsGenerator(period), isTrue);
    });

    test('does not fit generator', () {
      final period = Period(
        start: DateTime(2020),
        end: DateTime(2020, 1, 1, 0, 0, 1), // Wrong end time
      );
      expect(generator.fitsGenerator(period), isFalse);
    });

    group('Equality', () {
      final generator1 = SecondGenerator();
      final generator2 = SecondGenerator();

      test('Same instance', () {
        expect(generator1, equals(generator1));
      });

      test('Different instances with same parameters', () {
        expect(generator1, equals(generator2));
      });

      test('Different generator types are not equal', () {
        // SecondGenerator should not equal other generator types
        expect(generator1, isNot(equals(DayGenerator())));
        expect(generator1, isNot(equals(WeekGenerator())));
        expect(generator1, isNot(equals(MonthGenerator())));
        expect(generator1, isNot(equals(HourGenerator())));
        expect(generator1, isNot(equals(MinuteGenerator())));
        expect(generator1, isNot(equals(FortnightGenerator())));
        expect(generator1, isNot(equals(TrimesterGenerator())));
        expect(generator1, isNot(equals(SemesterGenerator())));
        expect(generator1, isNot(equals(YearGenerator())));

        // WeekGenerators with different parameters should not equal
        // SecondGenerator
        expect(
          generator1,
          isNot(equals(WeekGenerator(weekStart: DateTime.tuesday))),
        );
        expect(
          generator1,
          isNot(equals(WeekGenerator(weekStart: DateTime.sunday))),
        );
      });
    });
  });
}
