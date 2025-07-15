import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('HourGenerator:', () {
    const generator = HourGenerator();

    group('Constructor', () {
      test('Creates generator instance', () {
        expect(const HourGenerator(), isNotNull);
      });
    });

    group('of', () {
      test('Start of hour', () {
        final hour = generator.of(DateTime(2020));
        final expected = HourPeriod(
          start: DateTime(2020),
          end: DateTime(2020, 1, 1, 0, 59, 59, 999, 999),
        );
        expect(hour, equals(expected));
      });

      test('End of hour', () {
        final hour = generator.of(DateTime(2020, 1, 1, 0, 59, 59, 999, 999));
        final expected = HourPeriod(
          start: DateTime(2020),
          end: DateTime(2020, 1, 1, 0, 59, 59, 999, 999),
        );
        expect(hour, equals(expected));
      });

      test('Middle of hour', () {
        final hour = generator.of(DateTime(2020, 1, 1, 0, 30, 45, 123, 456));
        final expected = HourPeriod(
          start: DateTime(2020),
          end: DateTime(2020, 1, 1, 0, 59, 59, 999, 999),
        );
        expect(hour, equals(expected));
      });
    });

    group('before', () {
      test('Start of hour', () {
        final hour = generator.of(DateTime(2020));
        final previous = generator.before(hour);
        final expected = HourPeriod(
          start: DateTime(2019, 12, 31, 23),
          end: DateTime(2019, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });

      test('End of hour', () {
        final hour = generator.of(DateTime(2020, 1, 1, 0, 59, 59, 999, 999));
        final previous = generator.before(hour);
        final expected = HourPeriod(
          start: DateTime(2019, 12, 31, 23),
          end: DateTime(2019, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });
    });

    group('after', () {
      test('Start of hour', () {
        final hour = generator.of(DateTime(2020));
        final next = generator.after(hour);
        final expected = HourPeriod(
          start: DateTime(2020, 1, 1, 1),
          end: DateTime(2020, 1, 1, 1, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });

      test('End of hour', () {
        final hour = generator.of(DateTime(2020, 1, 1, 0, 59, 59, 999, 999));
        final next = generator.after(hour);
        final expected = HourPeriod(
          start: DateTime(2020, 1, 1, 1),
          end: DateTime(2020, 1, 1, 1, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });
    });

    group('sub-periods', () {
      const minuteGenerator = MinuteGenerator();
      final hour = generator.of(DateTime(2020));
      final minutes = hour.minutes;

      test('type', () {
        expect(minutes, isA<List<MinutePeriod>>());
      });

      test('length', () {
        expect(minutes.length, equals(60));
      });

      test('Start of hour', () {
        final firstMinute = minuteGenerator.of(DateTime(2020));
        expect(minutes.first, equals(firstMinute));
      });

      test('End of hour', () {
        final lastMinute = minuteGenerator.of(
          DateTime(2020, 1, 1, 0, 59, 59, 999, 999),
        );
        expect(minutes.last, equals(lastMinute));
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
      test('Day boundary crossing', () {
        final period = generator.of(DateTime(2020, 1, 1, 23));
        final next = generator.after(period);
        expect(next.start.hour, equals(0));
        expect(next.start.day, equals(2));
      });

      test('Month boundary crossing', () {
        final period = generator.of(DateTime(2020, 1, 31, 23));
        final next = generator.after(period);
        expect(next.start.hour, equals(0));
        expect(next.start.day, equals(1));
        expect(next.start.month, equals(2));
      });

      test('Year boundary crossing', () {
        final period = generator.of(DateTime(2019, 12, 31, 23));
        final next = generator.after(period);
        expect(next.start.year, equals(2020));
        expect(next.start.month, equals(1));
        expect(next.start.day, equals(1));
        expect(next.start.hour, equals(0));
      });

      test('Leap year February 29', () {
        // February 29, 2020 is a leap year
        final period = generator.of(DateTime(2020, 2, 29, 12));
        expect(period.start.day, equals(29));
        expect(period.start.month, equals(2));
        expect(period.start.hour, equals(12));
      });
    });

    test('fits generator', () {
      final period = HourPeriod(
        start: DateTime(2020),
        end: DateTime(2020, 1, 1, 0, 59, 59, 999, 999),
      );
      expect(generator.fitsGenerator(period), isTrue);
    });

    test('does not fit generator', () {
      final period = Period(
        start: DateTime(2020),
        end: DateTime(2020, 1, 1, 1), // Wrong end time
      );
      expect(generator.fitsGenerator(period), isFalse);
    });

    group('Equality', () {
      final generator1 = HourGenerator();
      final generator2 = HourGenerator();

      test('Same instance', () {
        expect(generator1, equals(generator1));
      });

      test('Different instances with same parameters', () {
        expect(generator1, equals(generator2));
      });

      test('Different generator types are not equal', () {
        // HourGenerator should not equal other generator types
        expect(generator1, isNot(equals(DayGenerator())));
        expect(generator1, isNot(equals(WeekGenerator())));
        expect(generator1, isNot(equals(MonthGenerator())));
        expect(generator1, isNot(equals(MinuteGenerator())));
        expect(generator1, isNot(equals(SecondGenerator())));
        expect(generator1, isNot(equals(FortnightGenerator())));
        expect(generator1, isNot(equals(TrimesterGenerator())));
        expect(generator1, isNot(equals(SemesterGenerator())));
        expect(generator1, isNot(equals(YearGenerator())));

        // WeekGenerators with different parameters should not equal
        // HourGenerator
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
