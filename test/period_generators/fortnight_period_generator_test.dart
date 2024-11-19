import 'package:due_date/period.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

void main() {
  group('FortnightPeriodGenerator', () {
    const fortnightGenerator = FortnightGenerator();
    group('Start of month', () {
      final day = DateTime(2022);
      final period = Period(
        start: day.date,
        end: DateTime(2022, 1, 15, 23, 59, 59, 999, 999),
      );
      test('ends on 15th', () {
        expect(fortnightGenerator.of(day), equals(period));
      });
      group('days', () {
        const dayGenerator = DayGenerator();
        final fortnight = fortnightGenerator.of(day);
        final days = fortnight.days;
        test('type', () {
          expect(days, isA<List<DayPeriod>>());
        });
        test('length', () {
          expect(days.length, equals(15));
        });
        test('start', () {
          expect(days.first, equals(dayGenerator.of(day)));
        });
        test('end', () {
          expect(
            days.last,
            equals(dayGenerator.of(DateTime(2022, 1, 15))),
          );
        });
      });
    });
    group('end of month', () {
      group('28th', () {
        final day = DateTime(2022, DateTime.february, 16);
        final period = Period(
          start: day.date,
          end: DateTime(2022, 2, 28, 23, 59, 59, 999, 999),
        );
        test('ends on 28th', () {
          expect(fortnightGenerator.of(day), equals(period));
        });
        group('days', () {
          const dayGenerator = DayGenerator();
          final fortnight = fortnightGenerator.of(day);
          final days = fortnight.days;
          test('type', () {
            expect(days, isA<List<DayPeriod>>());
          });
          test('length', () {
            expect(days.length, equals(13));
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
        final day = DateTime(2020, DateTime.february, 16);
        final period = Period(
          start: day.date,
          end: DateTime(2020, 2, 29, 23, 59, 59, 999, 999),
        );
        test('ends on 29th', () {
          expect(fortnightGenerator.of(day), equals(period));
        });
        group('days', () {
          const dayGenerator = DayGenerator();
          final fortnight = fortnightGenerator.of(day);
          final days = fortnight.days;
          test('type', () {
            expect(days, isA<List<DayPeriod>>());
          });
          test('length', () {
            expect(days.length, equals(14));
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
        final day = DateTime(2022, DateTime.april, 16);
        final period = Period(
          start: day.date,
          end: DateTime(2022, 4, 30, 23, 59, 59, 999, 999),
        );
        test('ends on 30th', () {
          expect(fortnightGenerator.of(day), equals(period));
        });
        group('days', () {
          const dayGenerator = DayGenerator();
          final fortnight = fortnightGenerator.of(day);
          final days = fortnight.days;
          test('type', () {
            expect(days, isA<List<DayPeriod>>());
          });
          test('length', () {
            expect(days.length, equals(15));
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
        final day = DateTime(2022, DateTime.january, 16);
        final period = Period(
          start: day.date,
          end: DateTime(2022, 1, 31, 23, 59, 59, 999, 999),
        );
        test('ends on 31th', () {
          expect(fortnightGenerator.of(day), equals(period));
        });
        group('days', () {
          const dayGenerator = DayGenerator();
          final fortnight = fortnightGenerator.of(day);
          final days = fortnight.days;
          test('type', () {
            expect(days, isA<List<DayPeriod>>());
          });
          test('length', () {
            expect(days.length, equals(16));
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
    group('Before', () {
      const fortnightGenerator = FortnightGenerator();
      final day = DateTime(2022);
      final period = Period(
        start: day.date,
        end: DateTime(2022, 1, 15, 23, 59, 59, 999, 999),
      );
      final expected = Period(
        start: DateTime(2021, 12, 16),
        end: DateTime(2021, 12, 31, 23, 59, 59, 999, 999),
      );
      test('before', () {
        expect(fortnightGenerator.before(period), equals(expected));
      });
    });
    group('After', () {
      const fortnightGenerator = FortnightGenerator();
      final day = DateTime(2022);
      final period = Period(
        start: day.date,
        end: DateTime(2022, 1, 15, 23, 59, 59, 999, 999),
      );
      final expected = Period(
        start: DateTime(2022, 1, 16),
        end: DateTime(2022, 1, 31, 23, 59, 59, 999, 999),
      );
      test('after', () {
        expect(fortnightGenerator.after(period), equals(expected));
      });
    });
    group('fits generator', () {
      const fortnightGenerator = FortnightGenerator();
      test('start of month fits', () {
        final period = Period(
          start: DateTime(2022),
          end: DateTime(2022, 1, 15, 23, 59, 59, 999, 999),
        );
        expect(fortnightGenerator.fitsGenerator(period), isTrue);
      });
      test('end of month 28th', () {
        final period = Period(
          start: DateTime(2022, DateTime.february, 16),
          end: DateTime(2022, 2, 28, 23, 59, 59, 999, 999),
        );
        expect(fortnightGenerator.fitsGenerator(period), isTrue);
      });
      test('end of month 29th', () {
        final period = Period(
          start: DateTime(2020, DateTime.february, 16),
          end: DateTime(2020, 2, 29, 23, 59, 59, 999, 999),
        );
        expect(fortnightGenerator.fitsGenerator(period), isTrue);
      });
      test('end of month 30th', () {
        final period = Period(
          start: DateTime(2022, DateTime.april, 16),
          end: DateTime(2022, 4, 30, 23, 59, 59, 999, 999),
        );
        expect(fortnightGenerator.fitsGenerator(period), isTrue);
      });
      test('end of month 31th', () {
        final period = Period(
          start: DateTime(2022, DateTime.january, 16),
          end: DateTime(2022, 1, 31, 23, 59, 59, 999, 999),
        );
        expect(fortnightGenerator.fitsGenerator(period), isTrue);
      });
    });
  });
}
