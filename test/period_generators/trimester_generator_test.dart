import 'package:due_date/src/period_generators/day_generator.dart';
import 'package:due_date/src/period_generators/fortnight_generator.dart';
import 'package:due_date/src/period_generators/hour_generator.dart';
import 'package:due_date/src/period_generators/minute_generator.dart';
import 'package:due_date/src/period_generators/month_generator.dart';
import 'package:due_date/src/period_generators/second_generator.dart';
import 'package:due_date/src/period_generators/semester_generator.dart';
import 'package:due_date/src/period_generators/trimester_generator.dart';
import 'package:due_date/src/period_generators/week_generator.dart';
import 'package:due_date/src/period_generators/year_generator.dart';
import 'package:due_date/src/periods/month_period.dart';
import 'package:due_date/src/periods/period.dart';
import 'package:due_date/src/periods/trimester_period.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

void main() {
  group('TrimesterPeriodGenerator', () {
    const trimesterGenerator = TrimesterGenerator();

    group('Constructor', () {
      test('Creates generator instance', () {
        expect(const TrimesterGenerator(), isNotNull);
      });
    });

    group('of', () {
      test('Start of first trimester', () {
        // January 1, 2022.
        final period = trimesterGenerator.of(DateTime(2022));
        final expected = TrimesterPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 3, 31, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });

      test('End of first trimester', () {
        // March 31, 2022.
        final period = trimesterGenerator.of(DateTime(2022, 3, 31));
        final expected = TrimesterPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 3, 31, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });

      test('Middle of first trimester', () {
        // February 15, 2022.
        final period = trimesterGenerator.of(DateTime(2022, 2, 15));
        final expected = TrimesterPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 3, 31, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });

      test('Start of second trimester', () {
        // April 1, 2022.
        final period = trimesterGenerator.of(DateTime(2022, 4));
        final expected = TrimesterPeriod(
          start: DateTime(2022, 4),
          end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });

      test('End of second trimester', () {
        // June 30, 2022.
        final period = trimesterGenerator.of(DateTime(2022, 6, 30));
        final expected = TrimesterPeriod(
          start: DateTime(2022, 4),
          end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });

      test('Middle of second trimester', () {
        // May 15, 2022.
        final period = trimesterGenerator.of(DateTime(2022, 5, 15));
        final expected = TrimesterPeriod(
          start: DateTime(2022, 4),
          end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
        );
        expect(period, equals(expected));
      });
    });

    group('before', () {
      test('Start of first trimester', () {
        final period = trimesterGenerator.of(DateTime(2022));
        final previous = trimesterGenerator.before(period);
        final expected = TrimesterPeriod(
          start: DateTime(2021, 10),
          end: DateTime(2021, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });

      test('End of first trimester', () {
        final period = trimesterGenerator.of(DateTime(2022, 3, 31));
        final previous = trimesterGenerator.before(period);
        final expected = TrimesterPeriod(
          start: DateTime(2021, 10),
          end: DateTime(2021, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });

      test('Start of second trimester', () {
        final period = trimesterGenerator.of(DateTime(2022, 4));
        final previous = trimesterGenerator.before(period);
        final expected = TrimesterPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 3, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });

      test('End of second trimester', () {
        final period = trimesterGenerator.of(DateTime(2022, 6, 30));
        final previous = trimesterGenerator.before(period);
        final expected = TrimesterPeriod(
          start: DateTime(2022),
          end: DateTime(2022, 3, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });
    });

    group('after', () {
      test('Start of first trimester', () {
        final period = trimesterGenerator.of(DateTime(2022));
        final next = trimesterGenerator.after(period);
        final expected = TrimesterPeriod(
          start: DateTime(2022, 4),
          end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });

      test('End of first trimester', () {
        final period = trimesterGenerator.of(DateTime(2022, 3, 31));
        final next = trimesterGenerator.after(period);
        final expected = TrimesterPeriod(
          start: DateTime(2022, 4),
          end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });

      test('Start of second trimester', () {
        final period = trimesterGenerator.of(DateTime(2022, 4));
        final next = trimesterGenerator.after(period);
        final expected = TrimesterPeriod(
          start: DateTime(2022, 7),
          end: DateTime(2022, 9, 30, 23, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });

      test('End of second trimester', () {
        final period = trimesterGenerator.of(DateTime(2022, 6, 30));
        final next = trimesterGenerator.after(period);
        final expected = TrimesterPeriod(
          start: DateTime(2022, 7),
          end: DateTime(2022, 9, 30, 23, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });
    });

    group('sub-periods', () {
      test('Type', () {
        final period = trimesterGenerator.of(DateTime(2022));
        final months = period.months;
        expect(months, isA<List<MonthPeriod>>());
      });

      test('Length', () {
        final period = trimesterGenerator.of(DateTime(2022));
        final months = period.months;
        expect(months.length, equals(3));
      });

      test('Start of first trimester', () {
        const monthGenerator = MonthGenerator();
        final period = trimesterGenerator.of(DateTime(2022));
        final months = period.months;
        expect(months.first, equals(monthGenerator.of(DateTime(2022))));
      });

      test('End of first trimester', () {
        const monthGenerator = MonthGenerator();
        final period = trimesterGenerator.of(DateTime(2022));
        final months = period.months;
        expect(months.last, equals(monthGenerator.of(DateTime(2022, 3, 31))));
      });
    });

    group('Time component preservation', () {
      test('Maintains time components in local DateTime', () {
        final input = DateTime(2022, 1, 15, 10, 30, 45, 123, 456);
        final period = trimesterGenerator.of(input);
        expect(period.start.isUtc, isFalse);
        expect(period.end.isUtc, isFalse);
      });

      test('Maintains time components in UTC DateTime', () {
        final input = DateTime.utc(2022, 1, 15, 10, 30, 45, 123, 456);
        final period = trimesterGenerator.of(input);
        expect(period.start.isUtc, isTrue);
        expect(period.end.isUtc, isTrue);
      });
    });

    group('Edge cases', () {
      group('First trimester (January-March)', () {
        // January 2022.
        final day = DateTime(2022);
        final period = TrimesterPeriod(
          start: day.date,
          end: DateTime(2022, 3, 31, 23, 59, 59, 999, 999),
        );
        test('ends on March 31st', () {
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

      group('Second trimester (April-June)', () {
        // April 2022.
        final day = DateTime(2022, DateTime.april);
        final period = TrimesterPeriod(
          start: day.date,
          end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
        );
        test('ends on June 30th', () {
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

      group('Third trimester (July-September)', () {
        // July 2022.
        final day = DateTime(2022, DateTime.july);
        final period = TrimesterPeriod(
          start: day.date,
          end: DateTime(2022, 9, 30, 23, 59, 59, 999, 999),
        );
        test('ends on September 30th', () {
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

      group('Fourth trimester (October-December)', () {
        // October 2022.
        final day = DateTime(2022, DateTime.october);
        final period = TrimesterPeriod(
          start: day.date,
          end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
        );
        test('ends on December 31st', () {
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

      test('Leap year first trimester', () {
        // 2020 is a leap year
        final period = trimesterGenerator.of(DateTime(2020, 2, 29));
        expect(period.start.year, equals(2020));
        expect(period.start.month, equals(1));
        expect(period.end.month, equals(3));
        expect(period.end.day, equals(31));
      });

      test('Year boundary crossing', () {
        // December 31, 2021 fourth trimester crosses into 2022.
        final period = trimesterGenerator.of(DateTime(2021, 12, 31));
        final next = trimesterGenerator.after(period);
        expect(next.start.year, equals(2022));
        expect(next.start.month, equals(1));
        expect(next.start.day, equals(1));
      });
    });

    test('fits generator', () {
      final firstTrimester = TrimesterPeriod(
        start: DateTime(2022),
        end: DateTime(2022, 3, 31, 23, 59, 59, 999, 999),
      );
      expect(trimesterGenerator.fitsGenerator(firstTrimester), isTrue);

      final secondTrimester = TrimesterPeriod(
        start: DateTime(2022, DateTime.april),
        end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
      );
      expect(trimesterGenerator.fitsGenerator(secondTrimester), isTrue);

      final thirdTrimester = TrimesterPeriod(
        start: DateTime(2022, DateTime.july),
        end: DateTime(2022, 9, 30, 23, 59, 59, 999, 999),
      );
      expect(trimesterGenerator.fitsGenerator(thirdTrimester), isTrue);

      final fourthTrimester = TrimesterPeriod(
        start: DateTime(2022, DateTime.october),
        end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
      );
      expect(trimesterGenerator.fitsGenerator(fourthTrimester), isTrue);

      final leapYearTrimester = TrimesterPeriod(
        start: DateTime(2020),
        end: DateTime(2020, 3, 31, 23, 59, 59, 999, 999),
      );
      expect(trimesterGenerator.fitsGenerator(leapYearTrimester), isTrue);
    });

    test('does not fit generator', () {
      final wrongStartDate = Period(
        start: DateTime(2022, 1, 2),
        end: DateTime(2022, 3, 31, 23, 59, 59, 999, 999),
      );
      expect(trimesterGenerator.fitsGenerator(wrongStartDate), isFalse);

      final wrongEndDate = Period(
        start: DateTime(2022),
        end: DateTime(2022, 3, 30, 23, 59, 59, 999, 999),
      );
      expect(trimesterGenerator.fitsGenerator(wrongEndDate), isFalse);

      final wrongTrimester = Period(
        start: DateTime(2022),
        end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
      );
      expect(trimesterGenerator.fitsGenerator(wrongTrimester), isFalse);
    });

    group('Equality', () {
      final generator1 = TrimesterGenerator();
      final generator2 = TrimesterGenerator();

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
        // TrimesterGenerator should not equal other generator types.
        expect(generator1, isNot(equals(DayGenerator())));
        expect(generator1, isNot(equals(WeekGenerator())));
        expect(generator1, isNot(equals(MonthGenerator())));
        expect(generator1, isNot(equals(HourGenerator())));
        expect(generator1, isNot(equals(MinuteGenerator())));
        expect(generator1, isNot(equals(SecondGenerator())));
        expect(generator1, isNot(equals(FortnightGenerator())));
        expect(generator1, isNot(equals(SemesterGenerator())));
        expect(generator1, isNot(equals(YearGenerator())));

        // WeekGenerators with different parameters should not equal
        // TrimesterGenerator.
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
