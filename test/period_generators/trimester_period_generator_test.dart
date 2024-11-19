import 'package:due_date/period.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

void main() {
  group('TrimesterPeriodGenerator', () {
    const trimesterGenerator = TrimesterGenerator();
    group('First trimester of the year', () {
      final day = DateTime(2022);
      final period = Period(
        start: day.date,
        end: DateTime(2022, 3, 31, 23, 59, 59, 999, 999),
      );
      test('ends on march 31st', () {
        expect(trimesterGenerator.of(day), equals(period));
      });
      group('months', () {
        const monthGenerator = MonthGenerator();
        final trimester = trimesterGenerator.of(day);
        final months = trimester.months;
        test('type', () {
          expect(months, isA<List<MonthPeriod>>());
        });
        test('length', () {
          expect(months.length, equals(3));
        });
        test('start', () {
          expect(months.first, equals(monthGenerator.of(day)));
        });
        test('end', () {
          expect(
            months.last,
            equals(monthGenerator.of(DateTime(2022, 3, 31))),
          );
        });
      });
    });
    group('Second trimester of the year', () {
      final day = DateTime(2022, DateTime.april);
      final period = Period(
        start: day.date,
        end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
      );
      test('ends on june 30th', () {
        expect(trimesterGenerator.of(day), equals(period));
      });
      group('months', () {
        const monthGenerator = MonthGenerator();
        final trimester = trimesterGenerator.of(day);
        final months = trimester.months;
        test('type', () {
          expect(months, isA<List<MonthPeriod>>());
        });
        test('length', () {
          expect(months.length, equals(3));
        });
        test('start', () {
          expect(months.first, equals(monthGenerator.of(day)));
        });
        test('end', () {
          expect(
            months.last,
            equals(monthGenerator.of(DateTime(2022, 6, 30))),
          );
        });
      });
    });
    group('Third trimester of the year', () {
      final day = DateTime(2022, DateTime.july);
      final period = Period(
        start: day.date,
        end: DateTime(2022, 9, 30, 23, 59, 59, 999, 999),
      );
      test('ends on september 30th', () {
        expect(trimesterGenerator.of(day), equals(period));
      });
      group('months', () {
        const monthGenerator = MonthGenerator();
        final trimester = trimesterGenerator.of(day);
        final months = trimester.months;
        test('type', () {
          expect(months, isA<List<MonthPeriod>>());
        });
        test('length', () {
          expect(months.length, equals(3));
        });
        test('start', () {
          expect(months.first, equals(monthGenerator.of(day)));
        });
        test('end', () {
          expect(
            months.last,
            equals(monthGenerator.of(DateTime(2022, 9, 30))),
          );
        });
      });
    });
    group('Fourth trimester of the year', () {
      final day = DateTime(2022, DateTime.october);
      final period = Period(
        start: day.date,
        end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
      );
      test('ends on december 31st', () {
        expect(trimesterGenerator.of(day), equals(period));
      });
      group('months', () {
        const monthGenerator = MonthGenerator();
        final trimester = trimesterGenerator.of(day);
        final months = trimester.months;
        test('type', () {
          expect(months, isA<List<MonthPeriod>>());
        });
        test('length', () {
          expect(months.length, equals(3));
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
    group('before', () {
      final period = Period(
        start: DateTime(2022),
        end: DateTime(2022, 3, 31, 23, 59, 59, 999, 999),
      );
      final expected = Period(
        start: DateTime(2021, DateTime.october),
        end: DateTime(2021, 12, 31, 23, 59, 59, 999, 999),
      );
      test('returns the previous trimester', () {
        expect(trimesterGenerator.before(period), equals(expected));
      });
    });
    group('after', () {
      final period = Period(
        start: DateTime(2022),
        end: DateTime(2022, 3, 31, 23, 59, 59, 999, 999),
      );
      final expected = Period(
        start: DateTime(2022, DateTime.april),
        end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
      );
      test('returns the next trimester', () {
        expect(trimesterGenerator.after(period), equals(expected));
      });
    });
    group('fits generator', () {
      test('first trimester leap', () {
        final period = Period(
          start: DateTime(2020),
          end: DateTime(2020, 3, 31, 23, 59, 59, 999, 999),
        );
        expect(trimesterGenerator.fitsGenerator(period), isTrue);
      });
      test('first trimester non leap', () {
        final period = Period(
          start: DateTime(2022),
          end: DateTime(2022, 3, 31, 23, 59, 59, 999, 999),
        );
        expect(trimesterGenerator.fitsGenerator(period), isTrue);
      });
      test('second trimester', () {
        final period = Period(
          start: DateTime(2022, DateTime.april),
          end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
        );
        expect(trimesterGenerator.fitsGenerator(period), isTrue);
      });
      test('third trimester', () {
        final period = Period(
          start: DateTime(2022, DateTime.july),
          end: DateTime(2022, 9, 30, 23, 59, 59, 999, 999),
        );
        expect(trimesterGenerator.fitsGenerator(period), isTrue);
      });
      test('fourth trimester', () {
        final period = Period(
          start: DateTime(2022, DateTime.october),
          end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(trimesterGenerator.fitsGenerator(period), isTrue);
      });
    });
  });
}
