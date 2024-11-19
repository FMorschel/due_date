import 'package:due_date/period.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

void main() {
  group('MonthPeriodGenerator', () {
    const monthGenerator = MonthGenerator();
    group('Start of month', () {
      final day = DateTime(2022);
      final period = Period(
        start: day.date,
        end: DateTime(2022, 1, 31, 23, 59, 59, 999, 999),
      );
      test('ends on 31st', () {
        expect(monthGenerator.of(day), equals(period));
      });
      group('days', () {
        const dayGenerator = DayGenerator();
        final month = monthGenerator.of(day);
        final days = month.days;
        test('type', () {
          expect(days, isA<List<DayPeriod>>());
        });
        test('length', () {
          expect(days.length, equals(31));
        });
        test('start', () {
          expect(days.first, equals(dayGenerator.of(day)));
        });
        test('end', () {
          expect(
            days.last,
            equals(dayGenerator.of(DateTime(2022, 1, 31))),
          );
        });
      });
    });
    group('end of month', () {
      group('28th', () {
        final day = DateTime(2022, DateTime.february);
        final period = Period(
          start: day.date,
          end: DateTime(2022, 2, 28, 23, 59, 59, 999, 999),
        );
        test('ends on 28th', () {
          expect(monthGenerator.of(day), equals(period));
        });
        group('days', () {
          const dayGenerator = DayGenerator();
          final month = monthGenerator.of(day);
          final days = month.days;
          test('type', () {
            expect(days, isA<List<DayPeriod>>());
          });
          test('length', () {
            expect(days.length, equals(28));
          });
          test('start', () {
            expect(days.first, equals(dayGenerator.of(day)));
          });
          test('end', () {
            expect(
              days.last,
              equals(dayGenerator.of(DateTime(2022, 2, 28))),
            );
          });
        });
      });
      group('29th', () {
        final day = DateTime(2020, DateTime.february);
        final period = Period(
          start: day.date,
          end: DateTime(2020, 2, 29, 23, 59, 59, 999, 999),
        );
        test('ends on 29th', () {
          expect(monthGenerator.of(day), equals(period));
        });
        group('days', () {
          const dayGenerator = DayGenerator();
          final month = monthGenerator.of(day);
          final days = month.days;
          test('type', () {
            expect(days, isA<List<DayPeriod>>());
          });
          test('length', () {
            expect(days.length, equals(29));
          });
          test('start', () {
            expect(days.first, equals(dayGenerator.of(day)));
          });
          test('end', () {
            expect(
              days.last,
              equals(dayGenerator.of(DateTime(2020, 2, 29))),
            );
          });
        });
      });
      group('30th', () {
        final day = DateTime(2022, DateTime.april);
        final period = Period(
          start: day.date,
          end: DateTime(2022, 4, 30, 23, 59, 59, 999, 999),
        );
        test('ends on 30th', () {
          expect(monthGenerator.of(day), equals(period));
        });
        group('days', () {
          const dayGenerator = DayGenerator();
          final month = monthGenerator.of(day);
          final days = month.days;
          test('type', () {
            expect(days, isA<List<DayPeriod>>());
          });
          test('length', () {
            expect(days.length, equals(30));
          });
          test('start', () {
            expect(days.first, equals(dayGenerator.of(day)));
          });
          test('end', () {
            expect(
              days.last,
              equals(dayGenerator.of(DateTime(2022, 4, 30))),
            );
          });
        });
      });
      group('31th', () {
        final day = DateTime(2022);
        final period = Period(
          start: day.date,
          end: DateTime(2022, 1, 31, 23, 59, 59, 999, 999),
        );
        test('ends on 31th', () {
          expect(monthGenerator.of(day), equals(period));
        });
        group('days', () {
          const dayGenerator = DayGenerator();
          final month = monthGenerator.of(day);
          final days = month.days;
          test('type', () {
            expect(days, isA<List<DayPeriod>>());
          });
          test('length', () {
            expect(days.length, equals(31));
          });
          test('start', () {
            expect(days.first, equals(dayGenerator.of(day)));
          });
          test('end', () {
            expect(
              days.last,
              equals(dayGenerator.of(DateTime(2022, 1, 31))),
            );
          });
        });
      });
    });
    group('before', () {
      final period = Period(
        start: DateTime(2022),
        end: DateTime(2022, DateTime.january, 31, 23, 59, 59, 999, 999),
      );
      final expected = Period(
        start: DateTime(2021, DateTime.december),
        end: DateTime(2021, DateTime.december, 31, 23, 59, 59, 999, 999),
      );
      test('before', () {
        expect(monthGenerator.before(period), equals(expected));
      });
    });
    group('after', () {
      final period = Period(
        start: DateTime(2022),
        end: DateTime(2022, 1, 31, 23, 59, 59, 999, 999),
      );
      final expected = Period(
        start: DateTime(2022, 2),
        end: DateTime(2022, 2, 28, 23, 59, 59, 999, 999),
      );
      test('after', () {
        expect(monthGenerator.after(period), equals(expected));
      });
    });
    group('fits generator', () {
      test('28 days', () {
        final period = Period(
          start: DateTime(2022, DateTime.february),
          end: DateTime(2022, 2, 28, 23, 59, 59, 999, 999),
        );
        expect(monthGenerator.fitsGenerator(period), isTrue);
      });
      test('29 days', () {
        final period = Period(
          start: DateTime(2020, DateTime.february),
          end: DateTime(2020, 2, 29, 23, 59, 59, 999, 999),
        );
        expect(monthGenerator.fitsGenerator(period), isTrue);
      });
      test('30 days', () {
        final period = Period(
          start: DateTime(2022, DateTime.april),
          end: DateTime(2022, 4, 30, 23, 59, 59, 999, 999),
        );
        expect(monthGenerator.fitsGenerator(period), isTrue);
      });
      test('31 days', () {
        final period = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 31, 23, 59, 59, 999, 999),
        );
        expect(monthGenerator.fitsGenerator(period), isTrue);
      });
    });
  });
}
