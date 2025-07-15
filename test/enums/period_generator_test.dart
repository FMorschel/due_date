import 'package:due_date/period.dart';
import 'package:test/test.dart';

import '../src/date_time_match.dart';

void main() {
  group('PeriodGenerator:', () {
    group('Values', () {
      test('Values are in correct order', () {
        expect(
          PeriodGenerator.values,
          equals([
            PeriodGenerator.second,
            PeriodGenerator.minute,
            PeriodGenerator.hour,
            PeriodGenerator.day,
            PeriodGenerator.week,
            PeriodGenerator.fortnight,
            PeriodGenerator.month,
            PeriodGenerator.trimester,
            PeriodGenerator.semester,
            PeriodGenerator.year,
          ]),
        );
      });
    });
    group('Methods', () {
      group('of method', () {
        final testDate = DateTime(2024, 7, 15, 14, 30, 45, 123);

        test('Second generator creates SecondPeriod', () {
          final period = PeriodGenerator.second.of(testDate);
          expect(period, isA<SecondPeriod>());
          expect(period.start.year, equals(2024));
          expect(period.start.month, equals(7));
          expect(period.start.day, equals(15));
          expect(period.start.hour, equals(14));
          expect(period.start.minute, equals(30));
          expect(period.start.second, equals(45));
          expect(period.start.millisecond, equals(0));
        });
        test('Minute generator creates MinutePeriod', () {
          final period = PeriodGenerator.minute.of(testDate);
          expect(period, isA<MinutePeriod>());
          expect(period.start.year, equals(2024));
          expect(period.start.month, equals(7));
          expect(period.start.day, equals(15));
          expect(period.start.hour, equals(14));
          expect(period.start.minute, equals(30));
          expect(period.start.second, equals(0));
        });
        test('Hour generator creates HourPeriod', () {
          final period = PeriodGenerator.hour.of(testDate);
          expect(period, isA<HourPeriod>());
          expect(period.start.year, equals(2024));
          expect(period.start.month, equals(7));
          expect(period.start.day, equals(15));
          expect(period.start.hour, equals(14));
          expect(period.start.minute, equals(0));
          expect(period.start.second, equals(0));
        });
        test('Day generator creates DayPeriod', () {
          final period = PeriodGenerator.day.of(testDate);
          expect(period, isA<DayPeriod>());
          expect(period.start.year, equals(2024));
          expect(period.start.month, equals(7));
          expect(period.start.day, equals(15));
          expect(period.start.hour, equals(0));
          expect(period.start.minute, equals(0));
          expect(period.start.second, equals(0));
        });
        test('Week generator creates WeekPeriod', () {
          final period = PeriodGenerator.week.of(testDate);
          expect(period, isA<WeekPeriod>());
          // July 15, 2024 is Monday, so week should start on Monday
          expect(period.start.year, equals(2024));
          expect(period.start.month, equals(7));
          expect(period.start.day, equals(15));
        });
        test('Fortnight generator creates FortnightPeriod', () {
          final period = PeriodGenerator.fortnight.of(testDate);
          expect(period, isA<FortnightPeriod>());
          expect(period.start.year, equals(2024));
          expect(period.start.month, equals(7));
        });
        test('Month generator creates MonthPeriod', () {
          final period = PeriodGenerator.month.of(testDate);
          expect(period, isA<MonthPeriod>());
          expect(period.start.year, equals(2024));
          expect(period.start.month, equals(7));
          expect(period.start.day, equals(1));
        });
        test('Trimester generator creates TrimesterPeriod', () {
          final period = PeriodGenerator.trimester.of(testDate);
          expect(period, isA<TrimesterPeriod>());
          expect(period.start.year, equals(2024));
          // July is in Q3, which starts in July
          expect(period.start.month, equals(7));
          expect(period.start.day, equals(1));
        });
        test('Semester generator creates SemesterPeriod', () {
          final period = PeriodGenerator.semester.of(testDate);
          expect(period, isA<SemesterPeriod>());
          expect(period.start.year, equals(2024));
          // July is in second semester, which starts in July
          expect(period.start.month, equals(7));
          expect(period.start.day, equals(1));
        });
        test('Year generator creates YearPeriod', () {
          final period = PeriodGenerator.year.of(testDate);
          expect(period, isA<YearPeriod>());
          expect(period.start.year, equals(2024));
          expect(period.start.month, equals(1));
          expect(period.start.day, equals(1));
        });
        test('Works with UTC dates', () {
          final utcDate = DateTime.utc(2024, 12, 25, 10, 30);
          final dayPeriod = PeriodGenerator.day.of(utcDate);
          expect(dayPeriod.start, isUtcDateTime);
          expect(dayPeriod.start.year, equals(2024));
          expect(dayPeriod.start.month, equals(12));
          expect(dayPeriod.start.day, equals(25));
        });
        test('Works with edge dates', () {
          // Test leap year
          final leapYearDate = DateTime(2020, 2, 29);
          final monthPeriod = PeriodGenerator.month.of(leapYearDate);
          expect(monthPeriod.start.year, equals(2020));
          expect(monthPeriod.start.month, equals(2));
          expect(monthPeriod.start.day, equals(1));

          // Test year boundary
          final yearEndDate = DateTime(2023, 12, 31, 23, 59, 59);
          final yearPeriod = PeriodGenerator.year.of(yearEndDate);
          expect(yearPeriod.start.year, equals(2023));
          expect(yearPeriod.start.month, equals(1));
          expect(yearPeriod.start.day, equals(1));
        });
      });
      group('fitsGenerator method', () {
        test('Second generator fits SecondPeriod', () {
          final secondPeriod = PeriodGenerator.second.of(
            DateTime(2024, 7, 15, 14, 30, 45),
          );
          expect(PeriodGenerator.second.fitsGenerator(secondPeriod), isTrue);
        });
        test('Second generator does not fit other periods', () {
          final minutePeriod = PeriodGenerator.minute.of(
            DateTime(2024, 7, 15, 14, 30),
          );
          final hourPeriod = PeriodGenerator.hour.of(DateTime(2024, 7, 15, 14));
          final dayPeriod = PeriodGenerator.day.of(DateTime(2024, 7, 15));
          expect(PeriodGenerator.second.fitsGenerator(minutePeriod), isFalse);
          expect(PeriodGenerator.second.fitsGenerator(hourPeriod), isFalse);
          expect(PeriodGenerator.second.fitsGenerator(dayPeriod), isFalse);
        });
        test('Minute generator fits MinutePeriod', () {
          final minutePeriod = PeriodGenerator.minute.of(
            DateTime(2024, 7, 15, 14, 30),
          );
          expect(PeriodGenerator.minute.fitsGenerator(minutePeriod), isTrue);
        });
        test('Minute generator does not fit other periods', () {
          final secondPeriod = PeriodGenerator.second.of(
            DateTime(2024, 7, 15, 14, 30, 45),
          );
          final hourPeriod = PeriodGenerator.hour.of(DateTime(2024, 7, 15, 14));
          final dayPeriod = PeriodGenerator.day.of(DateTime(2024, 7, 15));
          expect(PeriodGenerator.minute.fitsGenerator(secondPeriod), isFalse);
          expect(PeriodGenerator.minute.fitsGenerator(hourPeriod), isFalse);
          expect(PeriodGenerator.minute.fitsGenerator(dayPeriod), isFalse);
        });
        test('Hour generator fits HourPeriod', () {
          final hourPeriod = PeriodGenerator.hour.of(DateTime(2024, 7, 15, 14));
          expect(PeriodGenerator.hour.fitsGenerator(hourPeriod), isTrue);
        });
        test('Day generator fits DayPeriod', () {
          final dayPeriod = PeriodGenerator.day.of(DateTime(2024, 7, 15));
          expect(PeriodGenerator.day.fitsGenerator(dayPeriod), isTrue);
        });
        test('Week generator fits WeekPeriod', () {
          final weekPeriod = PeriodGenerator.week.of(DateTime(2024, 7, 15));
          expect(PeriodGenerator.week.fitsGenerator(weekPeriod), isTrue);
        });
        test('Fortnight generator fits FortnightPeriod', () {
          final fortnightPeriod =
              PeriodGenerator.fortnight.of(DateTime(2024, 7, 15));
          expect(
            PeriodGenerator.fortnight.fitsGenerator(fortnightPeriod),
            isTrue,
          );
        });
        test('Month generator fits MonthPeriod', () {
          final monthPeriod = PeriodGenerator.month.of(DateTime(2024, 7));
          expect(PeriodGenerator.month.fitsGenerator(monthPeriod), isTrue);
        });
        test('Trimester generator fits TrimesterPeriod', () {
          final trimesterPeriod =
              PeriodGenerator.trimester.of(DateTime(2024, 7));
          expect(
            PeriodGenerator.trimester.fitsGenerator(trimesterPeriod),
            isTrue,
          );
        });
        test('Semester generator fits SemesterPeriod', () {
          final semesterPeriod = PeriodGenerator.semester.of(DateTime(2024, 7));
          expect(
            PeriodGenerator.semester.fitsGenerator(semesterPeriod),
            isTrue,
          );
        });
        test('Year generator fits YearPeriod', () {
          final yearPeriod = PeriodGenerator.year.of(DateTime(2024));
          expect(PeriodGenerator.year.fitsGenerator(yearPeriod), isTrue);
        });
        test('Cross-generator compatibility returns false', () {
          final monthPeriod = PeriodGenerator.month.of(DateTime(2024, 7));
          final yearPeriod = PeriodGenerator.year.of(DateTime(2024));

          expect(PeriodGenerator.year.fitsGenerator(monthPeriod), isFalse);
          expect(PeriodGenerator.month.fitsGenerator(yearPeriod), isFalse);
          expect(PeriodGenerator.day.fitsGenerator(monthPeriod), isFalse);
          expect(PeriodGenerator.week.fitsGenerator(yearPeriod), isFalse);
        });
      });
    });
    group('Equality', () {
      test('Same values are equal', () {
        expect(PeriodGenerator.day, equals(PeriodGenerator.day));
        expect(PeriodGenerator.month, equals(PeriodGenerator.month));
        expect(PeriodGenerator.year, equals(PeriodGenerator.year));
      });
      test('Different values are not equal', () {
        expect(PeriodGenerator.day, isNot(equals(PeriodGenerator.month)));
        expect(PeriodGenerator.month, isNot(equals(PeriodGenerator.year)));
        expect(PeriodGenerator.second, isNot(equals(PeriodGenerator.minute)));
      });
    });
    group('Edge Cases', () {
      test('All generators are unique', () {
        final set = PeriodGenerator.values.toSet();
        expect(set.length, equals(PeriodGenerator.values.length));
      });
    });
  });
}
