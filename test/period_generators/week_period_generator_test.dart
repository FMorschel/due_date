import 'package:due_date/period.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

void main() {
  group('WeekPeriodGenerator ->', () {
    group('Monday as reference ->', () {
      final day = DateTime(2023, DateTime.january, 2, 23, 59, 59, 999, 999);
      test('Starts monday', () {
        const week = WeekGenerator();
        final period = Period(
          start: day.date,
          end: DateTime(2023, 1, 8, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
      test('Starts tuesday', () {
        const week = WeekGenerator(weekStart: DateTime.tuesday);
        final period = Period(
          start: DateTime(2022, 12, 27),
          end: day,
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
          start: DateTime(2023),
          end: DateTime(2023, 1, 7, 23, 59, 59, 999, 999),
        );
        expect(week.of(day), equals(period));
      });
    });
    group('Sunday as reference ->', () {
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
      const generator = WeekGenerator();
      final period = Period(
        start: DateTime(2019, 12, 23),
        end: DateTime(2019, 12, 29, 23, 59, 59, 999, 999),
      );
      expect(generator.fitsGenerator(period), isTrue);
    });
  });
}
