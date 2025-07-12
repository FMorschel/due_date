// ignore_for_file: prefer_const_constructors

import 'package:due_date/period.dart';
import 'package:due_date/src/period_generators/year_generator.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

import '../src/date_time_match.dart';

void main() {
  group('YearPeriodGenerator', () {
    const yearGenerator = YearGenerator();

    group('Constructor', () {
      test('Creates generator instance', () {
        expect(const YearGenerator(), isNotNull);
      });
    });

    group('of', () {
      test('Start of year', () {
        // January 1, 2022
        final period = yearGenerator.of(DateTime(2022));
        final expected = YearPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });

      test('End of year', () {
        // December 31, 2022
        final period = yearGenerator.of(DateTime(2022, 12, 31));
        final expected = YearPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });

      test('Middle of year', () {
        // June 15, 2022
        final period = yearGenerator.of(DateTime(2022, 6, 15));
        final expected = YearPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });

      test('Date with time components', () {
        // March 15, 2022 at 10:30:45
        final period = yearGenerator.of(DateTime(2022, 3, 15, 10, 30, 45));
        final expected = YearPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });

      group('Leap year', () {
        test('Start of leap year', () {
          // January 1, 2020
          final period = yearGenerator.of(DateTime(2020));
          final expected = YearPeriod(
            start: DateTime(2020),
            end: DateTime(2020, 12, 31, 23, 59, 59, 999, 999),
          );
          expect(period, equals(expected));
        });

        test('End of leap year', () {
          // December 31, 2020
          final period = yearGenerator.of(DateTime(2020, 12, 31));
          final expected = YearPeriod(
            start: DateTime(2020),
            end: DateTime(2020, 12, 31, 23, 59, 59, 999, 999),
          );
          expect(period, equals(expected));
        });

        test('Leap day', () {
          // February 29, 2020
          final period = yearGenerator.of(DateTime(2020, 2, 29));
          final expected = YearPeriod(
            start: DateTime(2020),
            end: DateTime(2020, 12, 31, 23, 59, 59, 999, 999),
          );
          expect(period, equals(expected));
        });
      });
    });

    group('before', () {
      test('Returns the previous year', () {
        final period = YearPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
        );
        final expected = YearPeriod(
          start: DateTime(2021),
          end: DateTime(2021, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(yearGenerator.before(period), equals(expected));
      });

      test('Handles leap year to non-leap year', () {
        final period = YearPeriod(
          start: DateTime(2021),
          end: DateTime(2021, 12, 31, 23, 59, 59, 999, 999),
        );
        final expected = YearPeriod(
          start: DateTime(2020),
          end: DateTime(2020, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(yearGenerator.before(period), equals(expected));
      });
    });

    group('after', () {
      test('Returns the next year', () {
        final period = YearPeriod(
          start: DateTime(2021),
          end: DateTime(2021, 12, 31, 23, 59, 59, 999, 999),
        );
        final expected = YearPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(yearGenerator.after(period), equals(expected));
      });

      test('Handles non-leap year to leap year', () {
        final period = YearPeriod(
          start: DateTime(2023),
          end: DateTime(2023, 12, 31, 23, 59, 59, 999, 999),
        );
        final expected = YearPeriod(
          start: DateTime(2024).date,
          end: DateTime(2024, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(yearGenerator.after(period), equals(expected));
      });
    });

    group('months', () {
      test('Non-leap year has 12 months', () {
        final year = yearGenerator.of(DateTime(2022));
        final months = year.months;
        expect(months, isA<List<MonthPeriod>>());
        expect(months.length, equals(12));
      });

      test('Leap year has 12 months', () {
        final year = yearGenerator.of(DateTime(2020));
        final months = year.months;
        expect(months, isA<List<MonthPeriod>>());
        expect(months.length, equals(12));
      });

      test('First month is January', () {
        const monthGenerator = MonthGenerator();
        final year = yearGenerator.of(DateTime(2022));
        final months = year.months;
        expect(months.first, equals(monthGenerator.of(DateTime(2022))));
      });

      test('Last month is December', () {
        const monthGenerator = MonthGenerator();
        final year = yearGenerator.of(DateTime(2022));
        final months = year.months;
        expect(
          months.last,
          equals(monthGenerator.of(DateTime(2022, 12, 31))),
        );
      });

      test('February in leap year', () {
        const monthGenerator = MonthGenerator();
        final year = yearGenerator.of(DateTime(2020));
        final months = year.months;
        final february = months[1]; // February is index 1
        expect(
          february,
          equals(monthGenerator.of(DateTime(2020, 2))),
        );
        // February 2020 should end on February 29
        expect(
          february.end,
          isSameDateTime(DateTime(2020, 2, 29, 23, 59, 59, 999, 999)),
        );
      });

      test('February in non-leap year', () {
        const monthGenerator = MonthGenerator();
        final year = yearGenerator.of(DateTime(2022));
        final months = year.months;
        final february = months[1]; // February is index 1
        expect(
          february,
          equals(monthGenerator.of(DateTime(2022, 2))),
        );
        // February 2022 should end on February 28
        expect(
          february.end,
          isSameDateTime(DateTime(2022, 2, 28, 23, 59, 59, 999, 999)),
        );
      });
    });

    group('fitsGenerator', () {
      test('Accepts valid year period', () {
        final period = YearPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(yearGenerator.fitsGenerator(period), isTrue);
      });

      test('Accepts leap year period', () {
        final period = YearPeriod(
          start: DateTime(2020),
          end: DateTime(2020, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(yearGenerator.fitsGenerator(period), isTrue);
      });

      test('Rejects partial year period', () {
        final period = Period(
          start: DateTime(2022, 6),
          end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(yearGenerator.fitsGenerator(period), isFalse);
      });

      test('Rejects extended year period', () {
        final period = Period(
          start: DateTime(2022),
          end: DateTime(2023, 1, 1, 23, 59, 59, 999, 999),
        );
        expect(yearGenerator.fitsGenerator(period), isFalse);
      });
    });

    group('does not fit', () {
      test('Month period', () {
        final period = MonthPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 1, 31, 23, 59, 59, 999, 999),
        );
        expect(yearGenerator.fitsGenerator(period), isFalse);
      });

      test('Day period', () {
        final period = DayPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 1, 1, 23, 59, 59, 999, 999),
        );
        expect(yearGenerator.fitsGenerator(period), isFalse);
      });

      test('Multi-year period', () {
        final period = Period(
          start: DateTime(2022),
          end: DateTime(2024, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(yearGenerator.fitsGenerator(period), isFalse);
      });
    });

    group('Time component preservation', () {
      test('Generated period starts at midnight', () {
        final period = yearGenerator.of(DateTime(2022, 6, 15, 14, 30, 45));
        expect(period.start.hour, equals(0));
        expect(period.start.minute, equals(0));
        expect(period.start.second, equals(0));
        expect(period.start.millisecond, equals(0));
        expect(period.start.microsecond, equals(0));
      });

      test('Generated period ends at end of day', () {
        final period = yearGenerator.of(DateTime(2022, 6, 15, 14, 30, 45));
        expect(period.end.hour, equals(23));
        expect(period.end.minute, equals(59));
        expect(period.end.second, equals(59));
        expect(period.end.millisecond, equals(999));
        expect(period.end.microsecond, equals(999));
      });
    });

    group('Equality', () {
      test('Same generator instances are equal', () {
        const generator1 = YearGenerator();
        const generator2 = YearGenerator();
        expect(generator1, equals(generator2));
      });

      test('Hash codes are equal for same generators', () {
        const generator1 = YearGenerator();
        const generator2 = YearGenerator();
        expect(generator1.hashCode, equals(generator2.hashCode));
      });
    });

    group('Edge cases', () {
      test('Century years - non-leap year', () {
        // 1900 is not a leap year (divisible by 100 but not 400)
        final period = yearGenerator.of(DateTime(1900));
        final expected = YearPeriod(
          start: DateTime(1900),
          end: DateTime(1900, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });

      test('Century years - leap year', () {
        // 2000 is a leap year (divisible by 400)
        final period = yearGenerator.of(DateTime(2000));
        final expected = YearPeriod(
          start: DateTime(2000),
          end: DateTime(2000, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });

      test('Year 1 AD', () {
        final period = yearGenerator.of(DateTime(1));
        final expected = YearPeriod(
          start: DateTime(1),
          end: DateTime(1, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });
    });
  });
}
