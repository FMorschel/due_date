import 'package:due_date/period.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

void main() {
  group('YearPeriodGenerator', () {
    const yearGenerator = YearGenerator();
    group('Non leap year', () {
      final day = DateTime(2022);
      final period = Period(
        start: day.date,
        end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
      );
      test('ends on december 31st', () {
        expect(yearGenerator.of(day), equals(period));
      });
      group('months', () {
        const monthGenerator = MonthGenerator();
        final year = yearGenerator.of(day);
        final months = year.months;
        test('type', () {
          expect(months, isA<List<MonthPeriod>>());
        });
        test('length', () {
          expect(months.length, equals(12));
        });
        test('start', () {
          expect(months.first, equals(monthGenerator.of(day)));
        });
        test('end', () {
          expect(
            months.last,
            equals(monthGenerator.of(DateTime(2022, 12, 31))),
          );
        });
      });
    });
    group('Leap year', () {
      final day = DateTime(2020);
      final period = Period(
        start: day.date,
        end: DateTime(2020, 12, 31, 23, 59, 59, 999, 999),
      );
      test('ends on december 31st', () {
        expect(yearGenerator.of(day), equals(period));
      });
      group('months', () {
        const monthGenerator = MonthGenerator();
        final year = yearGenerator.of(day);
        final months = year.months;
        test('type', () {
          expect(months, isA<List<MonthPeriod>>());
        });
        test('length', () {
          expect(months.length, equals(12));
        });
        test('start', () {
          expect(months.first, equals(monthGenerator.of(day)));
        });
        test('end', () {
          expect(
            months.last,
            equals(monthGenerator.of(DateTime(2020, 12, 31))),
          );
        });
      });
    });
    group('before', () {
      final period = Period(
        start: DateTime(2022),
        end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
      );
      final expected = Period(
        start: DateTime(2021),
        end: DateTime(2021, 12, 31, 23, 59, 59, 999, 999),
      );
      test('returns the previous year', () {
        expect(yearGenerator.before(period), equals(expected));
      });
    });
    group('after', () {
      final period = Period(
        start: DateTime(2021),
        end: DateTime(2021, 12, 31, 23, 59, 59, 999, 999),
      );
      final expected = Period(
        start: DateTime(2022),
        end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
      );
      test('returns the next year', () {
        expect(yearGenerator.after(period), equals(expected));
      });
    });
    group('fits generator', () {
      test('leap year', () {
        final period = Period(
          start: DateTime(2020),
          end: DateTime(2020, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(yearGenerator.fitsGenerator(period), isTrue);
      });
      test('non leap year', () {
        final period = Period(
          start: DateTime(2022),
          end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(yearGenerator.fitsGenerator(period), isTrue);
      });
    });
  });
}
