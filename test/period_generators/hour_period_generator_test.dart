import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('HourPeriodGenerator', () {
    const generator = HourGenerator();
    group('of', () {
      final period = Period(
        start: DateTime(2020),
        end: DateTime(2020, 1, 1, 0, 59, 59, 999, 999),
      );
      test('Start of hour', () {
        final hour = generator.of(DateTime(2020));
        expect(hour, equals(period));
      });
      test('End of hour', () {
        final hour = generator.of(DateTime(2020, 1, 1, 0, 59, 59, 999, 999));
        expect(hour, equals(period));
      });
    });
    group('minutes', () {
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
    group('before', () {
      test('Start of hour', () {
        final hour = generator.of(DateTime(2020));
        final previous = generator.before(hour);
        final expected = Period(
          start: DateTime(2019, 12, 31, 23),
          end: DateTime(2019, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });
      test('End of hour', () {
        final hour = generator.of(DateTime(2020, 1, 1, 0, 59, 59, 999, 999));
        final previous = generator.before(hour);
        final expected = Period(
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
        final expected = Period(
          start: DateTime(2020, 1, 1, 1),
          end: DateTime(2020, 1, 1, 1, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });
      test('End of hour', () {
        final hour = generator.of(DateTime(2020, 1, 1, 0, 59, 59, 999, 999));
        final next = generator.after(hour);
        final expected = Period(
          start: DateTime(2020, 1, 1, 1),
          end: DateTime(2020, 1, 1, 1, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });
    });
    test('fits generator', () {
      final period = Period(
        start: DateTime(2020),
        end: DateTime(2020, 1, 1, 0, 59, 59, 999, 999),
      );
      expect(generator.fitsGenerator(period), isTrue);
    });
  });
}
