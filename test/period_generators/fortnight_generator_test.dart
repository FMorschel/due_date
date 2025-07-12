// ignore_for_file: prefer_const_constructors

import 'package:due_date/period.dart';
import 'package:due_date/src/period_generators/semester_generator.dart';
import 'package:due_date/src/period_generators/year_generator.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

void main() {
  group('FortnightPeriodGenerator', () {
    const fortnightGenerator = FortnightGenerator();

    group('Constructor', () {
      test('Creates generator instance', () {
        expect(const FortnightGenerator(), isNotNull);
      });
    });

    group('of', () {
      test('Start of first fortnight', () {
        // January 1, 2022 is in the first fortnight
        final period = fortnightGenerator.of(DateTime(2022));
        final expected = FortnightPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 1, 15, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });

      test('End of first fortnight', () {
        // January 15, 2022 is the last day of the first fortnight
        final period = fortnightGenerator.of(DateTime(2022, 1, 15));
        final expected = FortnightPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 1, 15, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });

      test('Middle of first fortnight', () {
        // January 8, 2022 is in the middle of the first fortnight
        final period = fortnightGenerator.of(DateTime(2022, 1, 8));
        final expected = FortnightPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 1, 15, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });

      test('Start of second fortnight', () {
        // January 16, 2022 is the first day of the second fortnight
        final period = fortnightGenerator.of(DateTime(2022, 1, 16));
        final expected = FortnightPeriod(
          start: DateTime(2022, 1, 16),
          end: DateTime(2022, 1, 31, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });

      test('End of second fortnight', () {
        // January 31, 2022 is the last day of the second fortnight
        final period = fortnightGenerator.of(DateTime(2022, 1, 31));
        final expected = FortnightPeriod(
          start: DateTime(2022, 1, 16),
          end: DateTime(2022, 1, 31, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });

      test('Middle of second fortnight', () {
        // January 24, 2022 is in the middle of the second fortnight
        final period = fortnightGenerator.of(DateTime(2022, 1, 24));
        final expected = FortnightPeriod(
          start: DateTime(2022, 1, 16),
          end: DateTime(2022, 1, 31, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });
    });

    group('before', () {
      test('Start of first fortnight', () {
        final period = fortnightGenerator.of(DateTime(2022));
        final previous = fortnightGenerator.before(period);
        final expected = FortnightPeriod(
          start: DateTime(2021, 12, 16),
          end: DateTime(2021, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });

      test('End of first fortnight', () {
        final period = fortnightGenerator.of(DateTime(2022, 1, 15));
        final previous = fortnightGenerator.before(period);
        final expected = FortnightPeriod(
          start: DateTime(2021, 12, 16),
          end: DateTime(2021, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });

      test('Start of second fortnight', () {
        final period = fortnightGenerator.of(DateTime(2022, 1, 16));
        final previous = fortnightGenerator.before(period);
        final expected = FortnightPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 1, 15, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });

      test('End of second fortnight', () {
        final period = fortnightGenerator.of(DateTime(2022, 1, 31));
        final previous = fortnightGenerator.before(period);
        final expected = FortnightPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 1, 15, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });
    });

    group('after', () {
      test('Start of first fortnight', () {
        final period = fortnightGenerator.of(DateTime(2022));
        final next = fortnightGenerator.after(period);
        final expected = FortnightPeriod(
          start: DateTime(2022, 1, 16),
          end: DateTime(2022, 1, 31, 23, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });

      test('End of first fortnight', () {
        final period = fortnightGenerator.of(DateTime(2022, 1, 15));
        final next = fortnightGenerator.after(period);
        final expected = FortnightPeriod(
          start: DateTime(2022, 1, 16),
          end: DateTime(2022, 1, 31, 23, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });

      test('Start of second fortnight', () {
        final period = fortnightGenerator.of(DateTime(2022, 1, 16));
        final next = fortnightGenerator.after(period);
        final expected = FortnightPeriod(
          start: DateTime(2022, 2),
          end: DateTime(2022, 2, 15, 23, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });

      test('End of second fortnight', () {
        final period = fortnightGenerator.of(DateTime(2022, 1, 31));
        final next = fortnightGenerator.after(period);
        final expected = FortnightPeriod(
          start: DateTime(2022, 2),
          end: DateTime(2022, 2, 15, 23, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });
    });

    group('sub-periods', () {
      test('First fortnight type', () {
        final period = fortnightGenerator.of(DateTime(2022));
        final days = period.days;
        expect(days, isA<List<DayPeriod>>());
      });

      test('First fortnight length', () {
        final period = fortnightGenerator.of(DateTime(2022));
        final days = period.days;
        expect(days.length, equals(15));
      });

      test('First fortnight start', () {
        const dayGenerator = DayGenerator();
        final period = fortnightGenerator.of(DateTime(2022));
        final days = period.days;
        expect(days.first, equals(dayGenerator.of(DateTime(2022))));
      });

      test('First fortnight end', () {
        const dayGenerator = DayGenerator();
        final period = fortnightGenerator.of(DateTime(2022));
        final days = period.days;
        expect(days.last, equals(dayGenerator.of(DateTime(2022, 1, 15))));
      });

      test('Second fortnight type', () {
        final period = fortnightGenerator.of(DateTime(2022, 1, 16));
        final days = period.days;
        expect(days, isA<List<DayPeriod>>());
      });

      test('Second fortnight length', () {
        final period = fortnightGenerator.of(DateTime(2022, 1, 16));
        final days = period.days;
        expect(days.length, equals(16));
      });

      test('Second fortnight start', () {
        const dayGenerator = DayGenerator();
        final period = fortnightGenerator.of(DateTime(2022, 1, 16));
        final days = period.days;
        expect(days.first, equals(dayGenerator.of(DateTime(2022, 1, 16))));
      });

      test('Second fortnight end', () {
        const dayGenerator = DayGenerator();
        final period = fortnightGenerator.of(DateTime(2022, 1, 16));
        final days = period.days;
        expect(days.last, equals(dayGenerator.of(DateTime(2022, 1, 31))));
      });
    });

    group('Time component preservation', () {
      test('Maintains time components in local DateTime', () {
        final input = DateTime(2022, 1, 15, 10, 30, 45, 123, 456);
        final period = fortnightGenerator.of(input);
        expect(period.start.isUtc, isFalse);
        expect(period.end.isUtc, isFalse);
      });

      test('Maintains time components in UTC DateTime', () {
        final input = DateTime.utc(2022, 1, 15, 10, 30, 45, 123, 456);
        final period = fortnightGenerator.of(input);
        expect(period.start.isUtc, isTrue);
        expect(period.end.isUtc, isTrue);
      });
    });

    group('Edge cases', () {
      group('February leap year', () {
        // February 16, 2020 is in a leap year
        final day = DateTime(2020, DateTime.february, 16);
        final period = FortnightPeriod(
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

      group('February non-leap year', () {
        // February 16, 2022 is in a non-leap year
        final day = DateTime(2022, DateTime.february, 16);
        final period = FortnightPeriod(
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

      group('Month with 30 days', () {
        // April 16, 2022 is in a month with 30 days
        final day = DateTime(2022, DateTime.april, 16);
        final period = FortnightPeriod(
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

      group('Month with 31 days', () {
        // January 16, 2022 is in a month with 31 days
        final day = DateTime(2022, DateTime.january, 16);
        final period = FortnightPeriod(
          start: day.date,
          end: DateTime(2022, 1, 31, 23, 59, 59, 999, 999),
        );
        test('ends on 31st', () {
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

      test('Year boundary crossing', () {
        // December 31, 2021 second fortnight crosses into 2022
        final period = fortnightGenerator.of(DateTime(2021, 12, 31));
        final next = fortnightGenerator.after(period);
        expect(next.start.year, equals(2022));
        expect(next.start.month, equals(1));
        expect(next.start.day, equals(1));
      });
    });

    test('fits generator', () {
      final firstFortnight = FortnightPeriod(
        start: DateTime(2022),
        end: DateTime(2022, 1, 15, 23, 59, 59, 999, 999),
      );
      expect(fortnightGenerator.fitsGenerator(firstFortnight), isTrue);

      final secondFortnight = FortnightPeriod(
        start: DateTime(2022, 1, 16),
        end: DateTime(2022, 1, 31, 23, 59, 59, 999, 999),
      );
      expect(fortnightGenerator.fitsGenerator(secondFortnight), isTrue);

      final leapYearFortnight = FortnightPeriod(
        start: DateTime(2020, DateTime.february, 16),
        end: DateTime(2020, 2, 29, 23, 59, 59, 999, 999),
      );
      expect(fortnightGenerator.fitsGenerator(leapYearFortnight), isTrue);

      final nonLeapYearFortnight = FortnightPeriod(
        start: DateTime(2022, DateTime.february, 16),
        end: DateTime(2022, 2, 28, 23, 59, 59, 999, 999),
      );
      expect(fortnightGenerator.fitsGenerator(nonLeapYearFortnight), isTrue);

      final month30DaysFortnight = FortnightPeriod(
        start: DateTime(2022, DateTime.april, 16),
        end: DateTime(2022, 4, 30, 23, 59, 59, 999, 999),
      );
      expect(fortnightGenerator.fitsGenerator(month30DaysFortnight), isTrue);

      final month31DaysFortnight = FortnightPeriod(
        start: DateTime(2022, DateTime.january, 16),
        end: DateTime(2022, 1, 31, 23, 59, 59, 999, 999),
      );
      expect(fortnightGenerator.fitsGenerator(month31DaysFortnight), isTrue);
    });

    test('does not fit generator', () {
      final wrongStartDate = Period(
        start: DateTime(2022, 1, 2),
        end: DateTime(2022, 1, 15, 23, 59, 59, 999, 999),
      );
      expect(fortnightGenerator.fitsGenerator(wrongStartDate), isFalse);

      final wrongEndDate = Period(
        start: DateTime(2022),
        end: DateTime(2022, 1, 14, 23, 59, 59, 999, 999),
      );
      expect(fortnightGenerator.fitsGenerator(wrongEndDate), isFalse);

      final wrongBothDates = Period(
        start: DateTime(2022, 1, 3),
        end: DateTime(2022, 1, 17, 23, 59, 59, 999, 999),
      );
      expect(fortnightGenerator.fitsGenerator(wrongBothDates), isFalse);
    });

    group('Equality', () {
      final generator1 = FortnightGenerator();
      final generator2 = FortnightGenerator();

      test('Same instance', () {
        expect(generator1, equals(generator1));
      });

      test('Different instances', () {
        expect(generator1, equals(generator2));
      });

      test('Hash codes', () {
        expect(generator1.hashCode, equals(generator2.hashCode));
      });

      test('Different generator types are not equal', () {
        // FortnightGenerator should not equal other generator types
        expect(generator1, isNot(equals(DayGenerator())));
        expect(generator1, isNot(equals(WeekGenerator())));
        expect(generator1, isNot(equals(MonthGenerator())));
        expect(generator1, isNot(equals(HourGenerator())));
        expect(generator1, isNot(equals(MinuteGenerator())));
        expect(generator1, isNot(equals(SecondGenerator())));
        expect(generator1, isNot(equals(TrimesterGenerator())));
        expect(generator1, isNot(equals(SemesterGenerator())));
        expect(generator1, isNot(equals(YearGenerator())));

        // WeekGenerators with different parameters should not equal
        // FortnightGenerator
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
