// ignore_for_file: prefer_const_constructors

import 'package:due_date/period.dart';
import 'package:due_date/src/period_generators/semester_generator.dart';
import 'package:due_date/src/period_generators/year_generator.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

void main() {
  group('WeekGenerator:', () {
    const generator = WeekGenerator();

    group('Constructor', () {
      test('Creates generator instance', () {
        expect(const WeekGenerator(), isNotNull);
      });

      test('Constructor with custom week start', () {
        expect(const WeekGenerator(weekStart: DateTime.tuesday), isNotNull);
      });

      test('Default week start is Monday', () {
        expect(const WeekGenerator().weekStart, equals(DateTime.monday));
      });
    });

    group('of', () {
      // January 2, 2023 is Monday
      test('Start of week - Monday start', () {
        final week = generator.of(DateTime(2023, 1, 2));
        final expected = WeekPeriod(
          start: DateTime(2023, 1, 2),
          end: DateTime(2023, 1, 8, 23, 59, 59, 999, 999),
        );
        expect(week, equals(expected));
      });

      // January 8, 2023 is Sunday (end of week)
      test('End of week - Monday start', () {
        final week = generator.of(DateTime(2023, 1, 8, 23, 59, 59, 999, 999));
        final expected = WeekPeriod(
          start: DateTime(2023, 1, 2),
          end: DateTime(2023, 1, 8, 23, 59, 59, 999, 999),
        );
        expect(week, equals(expected));
      });

      // January 5, 2023 is Thursday (middle of week)
      test('Middle of week - Monday start', () {
        final week = generator.of(DateTime(2023, 1, 5, 12, 30));
        final expected = WeekPeriod(
          start: DateTime(2023, 1, 2),
          end: DateTime(2023, 1, 8, 23, 59, 59, 999, 999),
        );
        expect(week, equals(expected));
      });

      test('Custom week start - Tuesday', () {
        const tuesdayWeek = WeekGenerator(weekStart: DateTime.tuesday);
        // January 2, 2023 is Monday, so week starts on December 27, 2022
        // (Tuesday)
        final week = tuesdayWeek.of(DateTime(2023, 1, 2));
        final expected = WeekPeriod(
          start: DateTime(2022, 12, 27),
          end: DateTime(2023, 1, 2, 23, 59, 59, 999, 999),
        );
        expect(week, equals(expected));
      });

      test('Custom week start - Sunday', () {
        const sundayWeek = WeekGenerator(weekStart: DateTime.sunday);
        // January 2, 2023 is Monday, so week starts on January 1, 2023 (Sunday)
        final week = sundayWeek.of(DateTime(2023, 1, 2));
        final expected = WeekPeriod(
          start: DateTime(2023),
          end: DateTime(2023, 1, 7, 23, 59, 59, 999, 999),
        );
        expect(week, equals(expected));
      });
    });

    group('before', () {
      test('Start of week', () {
        final week = generator.of(DateTime(2020));
        final previous = generator.before(week);
        final expected = WeekPeriod(
          start: DateTime(2019, 12, 23),
          end: DateTime(2019, 12, 29, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });

      test('End of week', () {
        final week = generator.of(DateTime(2020, 1, 5));
        final previous = generator.before(week);
        final expected = WeekPeriod(
          start: DateTime(2019, 12, 23),
          end: DateTime(2019, 12, 29, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });
    });

    group('after', () {
      test('Start of week', () {
        final week = generator.of(DateTime(2020));
        final next = generator.after(week);
        final expected = WeekPeriod(
          start: DateTime(2020, 1, 6),
          end: DateTime(2020, 1, 12, 23, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });

      test('End of week', () {
        final week = generator.of(DateTime(2020, 1, 5));
        final next = generator.after(week);
        final expected = WeekPeriod(
          start: DateTime(2020, 1, 6),
          end: DateTime(2020, 1, 12, 23, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });
    });

    group('sub-periods', () {
      const dayGenerator = DayGenerator();
      final week = generator.of(DateTime(2023, 1, 2));
      final days = week.days;

      test('type', () {
        expect(days, isA<List<DayPeriod>>());
      });

      test('length', () {
        expect(days.length, equals(7));
      });

      test('Start of week', () {
        final firstDay = dayGenerator.of(DateTime(2023, 1, 2));
        expect(days.first, equals(firstDay));
      });

      test('End of week', () {
        final lastDay = dayGenerator.of(DateTime(2023, 1, 8));
        expect(days.last, equals(lastDay));
      });
    });

    group('Time component preservation', () {
      test('Maintains time components in local DateTime', () {
        final input = DateTime(2020, 1, 15, 10, 30, 45, 123, 456);
        final period = generator.of(input);
        expect(period.start.isUtc, isFalse);
        expect(period.end.isUtc, isFalse);
      });

      test('Maintains time components in UTC DateTime', () {
        final input = DateTime.utc(2020, 1, 15, 10, 30, 45, 123, 456);
        final period = generator.of(input);
        expect(period.start.isUtc, isTrue);
        expect(period.end.isUtc, isTrue);
      });
    });

    group('Edge cases', () {
      test('Month boundary crossing', () {
        // Week spans from January to February
        final period = generator.of(DateTime(2020, 1, 31));
        final next = generator.after(period);
        expect(next.start.month, equals(2));
      });

      test('Year boundary crossing', () {
        // Week spans from December to January
        final period = generator.of(DateTime(2019, 12, 30));
        final next = generator.after(period);
        expect(next.start.year, equals(2020));
      });

      test('Leap year February 29', () {
        // February 29, 2020 is a leap year Saturday
        final period = generator.of(DateTime(2020, 2, 29));
        expect(period.start.month, equals(2));
        expect(period.end.month, equals(3));
      });

      test('Week crossing month boundaries', () {
        // January 30, 2023 is Monday, week goes to February 5
        final week = generator.of(DateTime(2023, 1, 30));
        expect(week.start.month, equals(1));
        expect(week.start.day, equals(30));
        expect(week.end.month, equals(2));
        expect(week.end.day, equals(5));
      });
    });

    group('Week start variations', () {
      test('Tuesday week start', () {
        const tuesdayWeek = WeekGenerator(weekStart: DateTime.tuesday);
        // January 3, 2023 is Tuesday
        final week = tuesdayWeek.of(DateTime(2023, 1, 3));
        expect(week.start.day, equals(3));
        expect(week.end.day, equals(9));
      });

      test('Wednesday week start', () {
        const wednesdayWeek = WeekGenerator(weekStart: DateTime.wednesday);
        // January 4, 2023 is Wednesday
        final week = wednesdayWeek.of(DateTime(2023, 1, 4));
        expect(week.start.day, equals(4));
        expect(week.end.day, equals(10));
      });

      test('Saturday week start', () {
        const saturdayWeek = WeekGenerator(weekStart: DateTime.saturday);
        // January 7, 2023 is Saturday
        final week = saturdayWeek.of(DateTime(2023, 1, 7));
        expect(week.start.day, equals(7));
        expect(week.end.day, equals(13));
      });
    });

    test('fits generator', () {
      final period = WeekPeriod(
        start: DateTime(2019, 12, 23),
        end: DateTime(2019, 12, 29, 23, 59, 59, 999, 999),
      );
      expect(generator.fitsGenerator(period), isTrue);
    });

    test('does not fit generator', () {
      final period = Period(
        start: DateTime(2020),
        end: DateTime(2020, 1, 8), // Wrong end time (missing microseconds)
      );
      expect(generator.fitsGenerator(period), isFalse);
    });

    group('Equality', () {
      final generator1 = WeekGenerator();
      final generator2 = WeekGenerator();
      final generator3 = WeekGenerator(weekStart: DateTime.tuesday);

      test('Same instance', () {
        expect(generator1, equals(generator1));
      });

      test('Different instances with same parameters', () {
        expect(generator1, equals(generator2));
      });

      test('Different week start parameter', () {
        expect(generator1, isNot(equals(generator3)));
      });

      test('Different generator types are not equal', () {
        // WeekGenerator should not equal other generator types
        expect(generator1, isNot(equals(DayGenerator())));
        expect(generator1, isNot(equals(HourGenerator())));
        expect(generator1, isNot(equals(MonthGenerator())));
        expect(generator1, isNot(equals(MinuteGenerator())));
        expect(generator1, isNot(equals(SecondGenerator())));
        expect(generator1, isNot(equals(FortnightGenerator())));
        expect(generator1, isNot(equals(TrimesterGenerator())));
        expect(generator1, isNot(equals(SemesterGenerator())));
        expect(generator1, isNot(equals(YearGenerator())));
      });
    });
    group('Different week starts ->', () {
      final day = DateTime(2023, DateTime.january, 1, 23, 59, 59, 999, 999);
      test('Starts monday', () {
        const week = WeekGenerator();
        final period = Period(
          start: DateTime(2022, 12, 26),
          end: day,
        );
        expect(week.of(day), equals(period));
      });
      test('Starts tuesday', () {
        const week = WeekGenerator(weekStart: DateTime.tuesday);
        final period = Period(
          start: DateTime(2022, 12, 27),
          end: DateTime(2023, 1, 2, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts wednesday', () {
        const week = WeekGenerator(weekStart: DateTime.wednesday);
        final period = Period(
          start: DateTime(2022, 12, 28),
          end: DateTime(2023, 1, 3, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts thursday', () {
        const week = WeekGenerator(weekStart: DateTime.thursday);
        final period = Period(
          start: DateTime(2022, 12, 29),
          end: DateTime(2023, 1, 4, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts friday', () {
        const week = WeekGenerator(weekStart: DateTime.friday);
        final period = Period(
          start: DateTime(2022, 12, 30),
          end: DateTime(2023, 1, 5, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts saturday', () {
        const week = WeekGenerator(weekStart: DateTime.saturday);
        final period = Period(
          start: DateTime(2022, 12, 31),
          end: DateTime(2023, 1, 6, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts sunday', () {
        const week = WeekGenerator(weekStart: DateTime.sunday);
        final period = Period(
          start: day.date,
          end: DateTime(2023, 1, 7, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
    });
    group('Saturday as reference ->', () {
      final day = DateTime(2022, DateTime.december, 31, 23, 59, 59, 999, 999);
      test('Starts monday', () {
        const week = WeekGenerator();
        final period = Period(
          start: DateTime(2022, 12, 26),
          end: DateTime(2023, 1, 1, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts tuesday', () {
        const week = WeekGenerator(weekStart: DateTime.tuesday);
        final period = Period(
          start: DateTime(2022, 12, 27),
          end: DateTime(2023, 1, 2, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts wednesday', () {
        const week = WeekGenerator(weekStart: DateTime.wednesday);
        final period = Period(
          start: DateTime(2022, 12, 28),
          end: DateTime(2023, 1, 3, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts thursday', () {
        const week = WeekGenerator(weekStart: DateTime.thursday);
        final period = Period(
          start: DateTime(2022, 12, 29),
          end: DateTime(2023, 1, 4, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts friday', () {
        const week = WeekGenerator(weekStart: DateTime.friday);
        final period = Period(
          start: DateTime(2022, 12, 30),
          end: DateTime(2023, 1, 5, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts saturday', () {
        const week = WeekGenerator(weekStart: DateTime.saturday);
        final period = Period(
          start: day.date,
          end: DateTime(2023, 1, 6, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts sunday', () {
        const week = WeekGenerator(weekStart: DateTime.sunday);
        final period = Period(
          start: DateTime(2022, 12, 25),
          end: day,
        );
        expect(week.of(day), equals(period));
      });
    });
    group('Friday as reference ->', () {
      final day = DateTime(2022, DateTime.december, 30, 23, 59, 59, 999, 999);
      test('Starts monday', () {
        const week = WeekGenerator();
        final period = Period(
          start: DateTime(2022, 12, 26),
          end: DateTime(2023, 1, 1, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts tuesday', () {
        const week = WeekGenerator(weekStart: DateTime.tuesday);
        final period = Period(
          start: DateTime(2022, 12, 27),
          end: DateTime(2023, 1, 2, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts wednesday', () {
        const week = WeekGenerator(weekStart: DateTime.wednesday);
        final period = Period(
          start: DateTime(2022, 12, 28),
          end: DateTime(2023, 1, 3, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts thursday', () {
        const week = WeekGenerator(weekStart: DateTime.thursday);
        final period = Period(
          start: DateTime(2022, 12, 29),
          end: DateTime(2023, 1, 4, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts friday', () {
        const week = WeekGenerator(weekStart: DateTime.friday);
        final period = Period(
          start: day.date,
          end: DateTime(2023, 1, 5, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts saturday', () {
        const week = WeekGenerator(weekStart: DateTime.saturday);
        final period = Period(
          start: DateTime(2022, 12, 24),
          end: day,
        );
        expect(week.of(day), equals(period));
      });
      test('Starts sunday', () {
        const week = WeekGenerator(weekStart: DateTime.sunday);
        final period = Period(
          start: DateTime(2022, 12, 25),
          end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
    });
    group('Thursday as reference ->', () {
      final day = DateTime(2022, DateTime.december, 29, 23, 59, 59, 999, 999);
      test('Starts monday', () {
        const week = WeekGenerator();
        final period = Period(
          start: DateTime(2022, 12, 26),
          end: DateTime(2023, 1, 1, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts tuesday', () {
        const week = WeekGenerator(weekStart: DateTime.tuesday);
        final period = Period(
          start: DateTime(2022, 12, 27),
          end: DateTime(2023, 1, 2, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts wednesday', () {
        const week = WeekGenerator(weekStart: DateTime.wednesday);
        final period = Period(
          start: DateTime(2022, 12, 28),
          end: DateTime(2023, 1, 3, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts thursday', () {
        const week = WeekGenerator(weekStart: DateTime.thursday);
        final period = Period(
          start: day.date,
          end: DateTime(2023, 1, 4, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts friday', () {
        const week = WeekGenerator(weekStart: DateTime.friday);
        final period = Period(
          start: DateTime(2022, 12, 23),
          end: day,
        );
        expect(week.of(day), equals(period));
      });
      test('Starts saturday', () {
        const week = WeekGenerator(weekStart: DateTime.saturday);
        final period = Period(
          start: DateTime(2022, 12, 24),
          end: DateTime(2022, 12, 30, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts sunday', () {
        const week = WeekGenerator(weekStart: DateTime.sunday);
        final period = Period(
          start: DateTime(2022, 12, 25),
          end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
    });
    group('Wednesday as reference ->', () {
      final day = DateTime(2022, DateTime.december, 28, 23, 59, 59, 999, 999);
      test('Starts monday', () {
        const week = WeekGenerator();
        final period = Period(
          start: DateTime(2022, 12, 26),
          end: DateTime(2023, 1, 1, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts tuesday', () {
        const week = WeekGenerator(weekStart: DateTime.tuesday);
        final period = Period(
          start: DateTime(2022, 12, 27),
          end: DateTime(2023, 1, 2, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts wednesday', () {
        const week = WeekGenerator(weekStart: DateTime.wednesday);
        final period = Period(
          start: day.date,
          end: DateTime(2023, 1, 3, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts thursday', () {
        const week = WeekGenerator(weekStart: DateTime.thursday);
        final period = Period(
          start: DateTime(2022, 12, 22),
          end: day,
        );
        expect(week.of(day), equals(period));
      });
      test('Starts friday', () {
        const week = WeekGenerator(weekStart: DateTime.friday);
        final period = Period(
          start: DateTime(2022, 12, 23),
          end: DateTime(2022, 12, 29, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts saturday', () {
        const week = WeekGenerator(weekStart: DateTime.saturday);
        final period = Period(
          start: DateTime(2022, 12, 24),
          end: DateTime(2022, 12, 30, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts sunday', () {
        const week = WeekGenerator(weekStart: DateTime.sunday);
        final period = Period(
          start: DateTime(2022, 12, 25),
          end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
    });
    group('Tuesday as reference ->', () {
      final day = DateTime(2022, DateTime.december, 27, 23, 59, 59, 999, 999);
      test('Starts monday', () {
        const week = WeekGenerator();
        final period = Period(
          start: DateTime(2022, 12, 26),
          end: DateTime(2023, 1, 1, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts tuesday', () {
        const week = WeekGenerator(weekStart: DateTime.tuesday);
        final period = Period(
          start: day.date,
          end: DateTime(2023, 1, 2, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts wednesday', () {
        const week = WeekGenerator(weekStart: DateTime.wednesday);
        final period = Period(
          start: DateTime(2022, 12, 21),
          end: day,
        );
        expect(week.of(day), equals(period));
      });
      test('Starts thursday', () {
        const week = WeekGenerator(weekStart: DateTime.thursday);
        final period = Period(
          start: DateTime(2022, 12, 22),
          end: DateTime(2022, 12, 28, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts friday', () {
        const week = WeekGenerator(weekStart: DateTime.friday);
        final period = Period(
          start: DateTime(2022, 12, 23),
          end: DateTime(2022, 12, 29, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts saturday', () {
        const week = WeekGenerator(weekStart: DateTime.saturday);
        final period = Period(
          start: DateTime(2022, 12, 24),
          end: DateTime(2022, 12, 30, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts sunday', () {
        const week = WeekGenerator(weekStart: DateTime.sunday);
        final period = Period(
          start: DateTime(2022, 12, 25),
          end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      group('days', () {
        const dayGenerator = DayGenerator();
        const weekGenerator = WeekGenerator(weekStart: DateTime.sunday);
        final week = weekGenerator.of(day);
        final days = week.days;
        test('type', () {
          expect(days, isA<List<DayPeriod>>());
        });
        test('length', () {
          expect(days.length, equals(7));
        });
        test('first', () {
          expect(days.first, equals(dayGenerator.of(DateTime(2022, 12, 25))));
        });
        test('last', () {
          expect(days.last, equals(dayGenerator.of(DateTime(2022, 12, 31))));
        });
      });
    });
    group('before', () {
      const generator = WeekGenerator();
      test('Start of week', () {
        final week = generator.of(DateTime(2020));
        final previous = generator.before(week);
        final expected = Period(
          start: DateTime(2019, 12, 23),
          end: DateTime(2019, 12, 29, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });
      test('End of week', () {
        final week = generator.of(DateTime(2020, 1, 5));
        final previous = generator.before(week);
        final expected = Period(
          start: DateTime(2019, 12, 23),
          end: DateTime(2019, 12, 29, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });
    });
    group('after', () {
      const generator = WeekGenerator();
      test('Start of week', () {
        final week = generator.of(DateTime(2020));
        final next = generator.after(week);
        final expected = Period(
          start: DateTime(2020, 1, 6),
          end: DateTime(2020, 1, 12, 23, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });
      test('End of week', () {
        final week = generator.of(DateTime(2020, 1, 5));
        final next = generator.after(week);
        final expected = Period(
          start: DateTime(2020, 1, 6),
          end: DateTime(2020, 1, 12, 23, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });
    });
    test('fits generator', () {
      final generator = WeekGenerator();
      final period = Period(
        start: DateTime(2019, 12, 23),
        end: DateTime(2019, 12, 29, 23, 59, 59, 999, 999),
      );
      expect(generator.fitsGenerator(period), isTrue);
    });
  });
}
