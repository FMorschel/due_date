import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('DayPeriodGenerator', () {
    const generator = DayGenerator();
    group('of', () {
      final period = Period(
        start: DateTime(2020),
        end: DateTime(2020, 1, 1, 23, 59, 59, 999, 999),
      );
      test('Start of day', () {
        final day = generator.of(DateTime(2020));
        expect(day, equals(period));
      });
      test('End of day', () {
        final day = generator.of(DateTime(2020, 1, 1, 23, 59, 59, 999, 999));
        expect(day, equals(period));
      });
    });
    group('hours', () {
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
    group('before', () {
      test('Start of day', () {
        final day = generator.of(DateTime(2020));
        final previous = generator.before(day);
        final expected = Period(
          start: DateTime(2019, 12, 31),
          end: DateTime(2019, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });
      test('End of day', () {
        final day = generator.of(DateTime(2020, 1, 1, 23, 59, 59, 999, 999));
        final previous = generator.before(day);
        final expected = Period(
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
        final expected = Period(
          start: DateTime(2020, 1, 2),
          end: DateTime(2020, 1, 2, 23, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });
      test('End of day', () {
        final day = generator.of(DateTime(2020, 1, 1, 23, 59, 59, 999, 999));
        final next = generator.after(day);
        final expected = Period(
          start: DateTime(2020, 1, 2),
          end: DateTime(2020, 1, 2, 23, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });
    });
    test('fits generator', () {
      final period = Period(
        start: DateTime(2020),
        end: DateTime(2020, 1, 1, 23, 59, 59, 999, 999),
      );
      expect(generator.fitsGenerator(period), isTrue);
    });
  });
}
