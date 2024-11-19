import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('SecondPeriodGenerator', () {
    const generator = SecondGenerator();
    group('of', () {
      final period = Period(
        start: DateTime(2020),
        end: DateTime(2020, 1, 1, 0, 0, 0, 999, 999),
      );
      test('Start of second', () {
        final second = generator.of(DateTime(2020));
        expect(second, equals(period));
      });
      test('End of second', () {
        final second = generator.of(DateTime(2020, 1, 1, 0, 0, 0, 999, 999));
        expect(second, equals(period));
      });
    });
    group('after', () {
      test('Start of second', () {
        final second = generator.of(DateTime(2020));
        final next = generator.after(second);
        final expected = Period(
          start: DateTime(2020, 1, 1, 0, 0, 1),
          end: DateTime(2020, 1, 1, 0, 0, 1, 999, 999),
        );
        expect(next, equals(expected));
      });
      test('End of second', () {
        final second = generator.of(DateTime(2020, 1, 1, 0, 0, 0, 999, 999));
        final next = generator.after(second);
        final expected = Period(
          start: DateTime(2020, 1, 1, 0, 0, 1),
          end: DateTime(2020, 1, 1, 0, 0, 1, 999, 999),
        );
        expect(next, equals(expected));
      });
    });
    group('before', () {
      test('Start of second', () {
        final second = generator.of(DateTime(2020));
        final previous = generator.before(second);
        final expected = Period(
          start: DateTime(2019, 12, 31, 23, 59, 59),
          end: DateTime(2019, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });
      test('End of second', () {
        final second = generator.of(DateTime(2020, 1, 1, 0, 0, 0, 999, 999));
        final previous = generator.before(second);
        final expected = Period(
          start: DateTime(2019, 12, 31, 23, 59, 59),
          end: DateTime(2019, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });
    });
    test('fits generator', () {
      final period = Period(
        start: DateTime(2020),
        end: DateTime(2020, 1, 1, 0, 0, 0, 999, 999),
      );
      expect(generator.fitsGenerator(period), isTrue);
    });
  });
}
