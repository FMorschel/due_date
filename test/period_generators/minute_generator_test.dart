import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('MinuteGenerator:', () {
    const generator = MinuteGenerator();

    group('Constructor', () {
      test('Creates generator instance', () {
        expect(const MinuteGenerator(), isNotNull);
      });
    });

    group('of', () {
      test('Start of minute', () {
        final minute = generator.of(DateTime(2020));
        final expected = MinutePeriod(
          start: DateTime(2020),
          end: DateTime(2020, 1, 1, 0, 0, 59, 999, 999),
        );
        expect(minute, equals(expected));
      });

      test('End of minute', () {
        final minute = generator.of(DateTime(2020, 1, 1, 0, 0, 59, 999, 999));
        final expected = MinutePeriod(
          start: DateTime(2020),
          end: DateTime(2020, 1, 1, 0, 0, 59, 999, 999),
        );
        expect(minute, equals(expected));
      });

      test('Middle of minute', () {
        final minute = generator.of(DateTime(2020, 1, 1, 0, 0, 30, 500, 123));
        final expected = MinutePeriod(
          start: DateTime(2020),
          end: DateTime(2020, 1, 1, 0, 0, 59, 999, 999),
        );
        expect(minute, equals(expected));
      });
    });

    group('before', () {
      test('Start of minute', () {
        final minute = generator.of(DateTime(2020));
        final previous = generator.before(minute);
        final expected = MinutePeriod(
          start: DateTime(2019, 12, 31, 23, 59),
          end: DateTime(2019, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });

      test('End of minute', () {
        final minute = generator.of(DateTime(2020, 1, 1, 0, 0, 59, 999, 999));
        final previous = generator.before(minute);
        final expected = MinutePeriod(
          start: DateTime(2019, 12, 31, 23, 59),
          end: DateTime(2019, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });
    });

    group('after', () {
      test('Start of minute', () {
        final minute = generator.of(DateTime(2020));
        final next = generator.after(minute);
        final expected = MinutePeriod(
          start: DateTime(2020, 1, 1, 0, 1),
          end: DateTime(2020, 1, 1, 0, 1, 59, 999, 999),
        );
        expect(next, equals(expected));
      });

      test('End of minute', () {
        final minute = generator.of(DateTime(2020, 1, 1, 0, 0, 59, 999, 999));
        final next = generator.after(minute);
        final expected = MinutePeriod(
          start: DateTime(2020, 1, 1, 0, 1),
          end: DateTime(2020, 1, 1, 0, 1, 59, 999, 999),
        );
        expect(next, equals(expected));
      });
    });

    group('sub-periods', () {
      const secondGenerator = SecondGenerator();
      final minute = generator.of(DateTime(2020));
      final seconds = minute.seconds;

      test('type', () {
        expect(seconds, isA<List<SecondPeriod>>());
      });

      test('length', () {
        expect(seconds.length, equals(60));
      });

      test('Start of minute', () {
        final firstSecond = secondGenerator.of(DateTime(2020));
        expect(seconds.first, equals(firstSecond));
      });

      test('End of minute', () {
        final lastSecond = secondGenerator.of(
          DateTime(2020, 1, 1, 0, 0, 59, 999, 999),
        );
        expect(seconds.last, equals(lastSecond));
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
      test('Hour boundary crossing', () {
        final period = generator.of(DateTime(2020, 1, 1, 0, 59));
        final next = generator.after(period);
        expect(next.start.hour, equals(1));
        expect(next.start.minute, equals(0));
      });

      test('Day boundary crossing', () {
        final period = generator.of(DateTime(2020, 1, 1, 23, 59));
        final next = generator.after(period);
        expect(next.start.hour, equals(0));
        expect(next.start.day, equals(2));
      });

      test('Month boundary crossing', () {
        final period = generator.of(DateTime(2020, 1, 31, 23, 59));
        final next = generator.after(period);
        expect(next.start.day, equals(1));
        expect(next.start.month, equals(2));
      });

      test('Year boundary crossing', () {
        final period = generator.of(DateTime(2019, 12, 31, 23, 59));
        final next = generator.after(period);
        expect(next.start.year, equals(2020));
        expect(next.start.month, equals(1));
        expect(next.start.day, equals(1));
      });
    });

    test('fits generator', () {
      final period = MinutePeriod(
        start: DateTime(2020),
        end: DateTime(2020, 1, 1, 0, 0, 59, 999, 999),
      );
      expect(generator.fitsGenerator(period), isTrue);
    });

    test('does not fit generator', () {
      final period = Period(
        start: DateTime(2020),
        end: DateTime(2020, 1, 1, 0, 1), // Wrong end time
      );
      expect(generator.fitsGenerator(period), isFalse);
    });

    group('Equality', () {
      final generator1 = MinuteGenerator();
      final generator2 = MinuteGenerator();

      test('Same instance', () {
        expect(generator1, equals(generator1));
      });

      test('Different instances with same parameters', () {
        expect(generator1, equals(generator2));
      });

      test('Different generator types are not equal', () {
        // MinuteGenerator should not equal other generator types
        expect(generator1, isNot(equals(DayGenerator())));
        expect(generator1, isNot(equals(WeekGenerator())));
        expect(generator1, isNot(equals(MonthGenerator())));
        expect(generator1, isNot(equals(HourGenerator())));
        expect(generator1, isNot(equals(SecondGenerator())));
        expect(generator1, isNot(equals(FortnightGenerator())));
        expect(generator1, isNot(equals(TrimesterGenerator())));
        expect(generator1, isNot(equals(SemesterGenerator())));
        expect(generator1, isNot(equals(YearGenerator())));

        // WeekGenerators with different parameters should not equal
        // MinuteGenerator
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
