// ignore_for_file: prefer_const_constructors

import 'package:due_date/period.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

void main() {
  group('MonthPeriodGenerator', () {
    const monthGenerator = MonthGenerator();

    group('Constructor', () {
      test('Creates generator instance', () {
        expect(const MonthGenerator(), isNotNull);
      });
    });

    group('of', () {
      test('Start of month', () {
        // January 1, 2022
        final period = monthGenerator.of(DateTime(2022));
        final expected = MonthPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 1, 31, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });

      test('End of month', () {
        // January 31, 2022
        final period = monthGenerator.of(DateTime(2022, 1, 31));
        final expected = MonthPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 1, 31, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });

      test('Middle of month', () {
        // January 15, 2022
        final period = monthGenerator.of(DateTime(2022, 1, 15));
        final expected = MonthPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 1, 31, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });
    });

    group('before', () {
      test('Start of month', () {
        final period = monthGenerator.of(DateTime(2022));
        final previous = monthGenerator.before(period);
        final expected = MonthPeriod(
          start: DateTime(2021, 12),
          end: DateTime(2021, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });

      test('End of month', () {
        final period = monthGenerator.of(DateTime(2022, 1, 31));
        final previous = monthGenerator.before(period);
        final expected = MonthPeriod(
          start: DateTime(2021, 12),
          end: DateTime(2021, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });

      test('Middle of month', () {
        final period = monthGenerator.of(DateTime(2022, 1, 15));
        final previous = monthGenerator.before(period);
        final expected = MonthPeriod(
          start: DateTime(2021, 12),
          end: DateTime(2021, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });
    });

    group('after', () {
      test('Start of month', () {
        final period = monthGenerator.of(DateTime(2022));
        final next = monthGenerator.after(period);
        final expected = MonthPeriod(
          start: DateTime(2022, 2),
          end: DateTime(2022, 2, 28, 23, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });

      test('End of month', () {
        final period = monthGenerator.of(DateTime(2022, 1, 31));
        final next = monthGenerator.after(period);
        final expected = MonthPeriod(
          start: DateTime(2022, 2),
          end: DateTime(2022, 2, 28, 23, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });

      test('Middle of month', () {
        final period = monthGenerator.of(DateTime(2022, 1, 15));
        final next = monthGenerator.after(period);
        final expected = MonthPeriod(
          start: DateTime(2022, 2),
          end: DateTime(2022, 2, 28, 23, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });
    });

    group('sub-periods', () {
      test('Type', () {
        final period = monthGenerator.of(DateTime(2022));
        final days = period.days;
        expect(days, isA<List<DayPeriod>>());
      });

      test('Length', () {
        final period = monthGenerator.of(DateTime(2022));
        final days = period.days;
        expect(days.length, equals(31));
      });

      test('Start of month', () {
        const dayGenerator = DayGenerator();
        final period = monthGenerator.of(DateTime(2022));
        final days = period.days;
        expect(days.first, equals(dayGenerator.of(DateTime(2022))));
      });

      test('End of month', () {
        const dayGenerator = DayGenerator();
        final period = monthGenerator.of(DateTime(2022));
        final days = period.days;
        expect(days.last, equals(dayGenerator.of(DateTime(2022, 1, 31))));
      });
    });

    group('Time component preservation', () {
      test('Maintains time components in local DateTime', () {
        final input = DateTime(2022, 1, 15, 10, 30, 45, 123, 456);
        final period = monthGenerator.of(input);
        expect(period.start.isUtc, isFalse);
        expect(period.end.isUtc, isFalse);
      });

      test('Maintains time components in UTC DateTime', () {
        final input = DateTime.utc(2022, 1, 15, 10, 30, 45, 123, 456);
        final period = monthGenerator.of(input);
        expect(period.start.isUtc, isTrue);
        expect(period.end.isUtc, isTrue);
      });
    });

    group('Edge cases', () {
      group('February leap year', () {
        // February 2020 is in a leap year
        final day = DateTime(2020, DateTime.february);
        final period = MonthPeriod(
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

      group('February non-leap year', () {
        // February 2022 is in a non-leap year
        final day = DateTime(2022, DateTime.february);
        final period = MonthPeriod(
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

      group('Month with 30 days', () {
        // April 2022 has 30 days
        final day = DateTime(2022, DateTime.april);
        final period = MonthPeriod(
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

      group('Month with 31 days', () {
        // January 2022 has 31 days
        final day = DateTime(2022);
        final period = MonthPeriod(
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

      test('Year boundary crossing', () {
        // December 2021 to January 2022
        final period = monthGenerator.of(DateTime(2021, 12, 31));
        final next = monthGenerator.after(period);
        expect(next.start.year, equals(2022));
        expect(next.start.month, equals(1));
        expect(next.start.day, equals(1));
      });
    });

    test('fits generator', () {
      final january = MonthPeriod(
        start: DateTime(2022),
        end: DateTime(2022, 1, 31, 23, 59, 59, 999, 999),
      );
      expect(monthGenerator.fitsGenerator(january), isTrue);

      final february28 = MonthPeriod(
        start: DateTime(2022, DateTime.february),
        end: DateTime(2022, 2, 28, 23, 59, 59, 999, 999),
      );
      expect(monthGenerator.fitsGenerator(february28), isTrue);

      final february29 = MonthPeriod(
        start: DateTime(2020, DateTime.february),
        end: DateTime(2020, 2, 29, 23, 59, 59, 999, 999),
      );
      expect(monthGenerator.fitsGenerator(february29), isTrue);

      final april30 = MonthPeriod(
        start: DateTime(2022, DateTime.april),
        end: DateTime(2022, 4, 30, 23, 59, 59, 999, 999),
      );
      expect(monthGenerator.fitsGenerator(april30), isTrue);
    });

    test('does not fit generator', () {
      final wrongStartDate = Period(
        start: DateTime(2022, 1, 2),
        end: DateTime(2022, 1, 31, 23, 59, 59, 999, 999),
      );
      expect(monthGenerator.fitsGenerator(wrongStartDate), isFalse);

      final wrongEndDate = Period(
        start: DateTime(2022),
        end: DateTime(2022, 1, 30, 23, 59, 59, 999, 999),
      );
      expect(monthGenerator.fitsGenerator(wrongEndDate), isFalse);

      final wrongMonth = Period(
        start: DateTime(2022),
        end: DateTime(2022, 2, 28, 23, 59, 59, 999, 999),
      );
      expect(monthGenerator.fitsGenerator(wrongMonth), isFalse);
    });

    group('Equality', () {
      final generator1 = MonthGenerator();
      final generator2 = MonthGenerator();

      test('Same instance', () {
        expect(generator1, equals(generator1));
      });

      test('Different instances', () {
        expect(generator1, equals(generator2));
      });

      test('Hash codes', () {
        expect(generator1.hashCode, equals(generator2.hashCode));
      });
    });
  });
}
