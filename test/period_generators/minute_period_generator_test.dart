import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('MinutePeriodGenerator', () {
    const generator = MinuteGenerator();
    group('of', () {
      final period = Period(
        start: DateTime(2020),
        end: DateTime(2020, 1, 1, 0, 0, 59, 999, 999),
      );
      test('Start of minute', () {
        final minute = generator.of(DateTime(2020));
        expect(minute, equals(period));
      });
      test('End of minute', () {
        final minute = generator.of(DateTime(2020, 1, 1, 0, 0, 59, 999, 999));
        expect(minute, equals(period));
      });
    });
    group('before', () {
      test('Start of minute', () {
        final minute = generator.of(DateTime(2020));
        final previous = generator.before(minute);
        final expected = Period(
          start: DateTime(2019, 12, 31, 23, 59),
          end: DateTime(2019, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });
      test('End of minute', () {
        final minute = generator.of(DateTime(2020, 1, 1, 0, 0, 59, 999, 999));
        final previous = generator.before(minute);
        final expected = Period(
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
        final expected = Period(
          start: DateTime(2020, 1, 1, 0, 1),
          end: DateTime(2020, 1, 1, 0, 1, 59, 999, 999),
        );
        expect(next, equals(expected));
      });
      test('End of minute', () {
        final minute = generator.of(DateTime(2020, 1, 1, 0, 0, 59, 999, 999));
        final next = generator.after(minute);
        final expected = Period(
          start: DateTime(2020, 1, 1, 0, 1),
          end: DateTime(2020, 1, 1, 0, 1, 59, 999, 999),
        );
        expect(next, equals(expected));
      });
    });
    test('fits generator', () {
      final period = Period(
        start: DateTime(2020),
        end: DateTime(2020, 1, 1, 0, 0, 59, 999, 999),
      );
      expect(generator.fitsGenerator(period), isTrue);
    });
  });
}
