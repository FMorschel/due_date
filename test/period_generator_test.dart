import 'package:due_date/period.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

void main() {
  group('SecondPeriodGenerator', () {
    const generator = SecondGenerator();
    group('of', () {
      final period = Period(
        start: DateTime(2020, 1, 1, 0, 0, 0),
        end: DateTime(2020, 1, 1, 0, 0, 0, 999, 999),
      );
      test('Start of second', () {
        final second = generator.of(DateTime(2020, 1, 1, 0, 0, 0));
        expect(second, equals(period));
      });
      test('End of second', () {
        final second = generator.of(DateTime(2020, 1, 1, 0, 0, 0, 999, 999));
        expect(second, equals(period));
      });
    });
    group('after', () {
      test('Start of second', () {
        final second = generator.of(DateTime(2020, 1, 1, 0, 0, 0));
        final next = generator.after(second);
        final expected = Period(
          start: DateTime(2020, 1, 1, 0, 0, 1),
          end: DateTime(2020, 1, 1, 0, 0, 1, 999, 999),
        );
        expect(next, equals(expected));
      });
      test('End of second', () {
        final second = generator.of(DateTime(2020, 1, 1, 0, 0, 0, 999, 999));
        final next = generator.after(second);
        final expected = Period(
          start: DateTime(2020, 1, 1, 0, 0, 1),
          end: DateTime(2020, 1, 1, 0, 0, 1, 999, 999),
        );
        expect(next, equals(expected));
      });
    });
    group('before', () {
      test('Start of second', () {
        final second = generator.of(DateTime(2020, 1, 1, 0, 0, 0));
        final previous = generator.before(second);
        final expected = Period(
          start: DateTime(2019, 12, 31, 23, 59, 59),
          end: DateTime(2019, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });
      test('End of second', () {
        final second = generator.of(DateTime(2020, 1, 1, 0, 0, 0, 999, 999));
        final previous = generator.before(second);
        final expected = Period(
          start: DateTime(2019, 12, 31, 23, 59, 59),
          end: DateTime(2019, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });
    });
    test('fits generator', () {
      final period = Period(
        start: DateTime(2020, 1, 1, 0, 0, 0),
        end: DateTime(2020, 1, 1, 0, 0, 0, 999, 999),
      );
      expect(generator.fitsGenerator(period), isTrue);
    });
  });
  group('MinutePeriodGenerator', () {
    const generator = MinuteGenerator();
    group('of', () {
      final period = Period(
        start: DateTime(2020, 1, 1, 0, 0, 0),
        end: DateTime(2020, 1, 1, 0, 0, 59, 999, 999),
      );
      test('Start of minute', () {
        final minute = generator.of(DateTime(2020, 1, 1, 0, 0, 0));
        expect(minute, equals(period));
      });
      test('End of minute', () {
        final minute = generator.of(DateTime(2020, 1, 1, 0, 0, 59, 999, 999));
        expect(minute, equals(period));
      });
    });
    group('before', () {
      test('Start of minute', () {
        final minute = generator.of(DateTime(2020, 1, 1, 0, 0, 0));
        final previous = generator.before(minute);
        final expected = Period(
          start: DateTime(2019, 12, 31, 23, 59, 0),
          end: DateTime(2019, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });
      test('End of minute', () {
        final minute = generator.of(DateTime(2020, 1, 1, 0, 0, 59, 999, 999));
        final previous = generator.before(minute);
        final expected = Period(
          start: DateTime(2019, 12, 31, 23, 59, 0),
          end: DateTime(2019, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });
    });
    group('after', () {
      test('Start of minute', () {
        final minute = generator.of(DateTime(2020, 1, 1, 0, 0, 0));
        final next = generator.after(minute);
        final expected = Period(
          start: DateTime(2020, 1, 1, 0, 1, 0),
          end: DateTime(2020, 1, 1, 0, 1, 59, 999, 999),
        );
        expect(next, equals(expected));
      });
      test('End of minute', () {
        final minute = generator.of(DateTime(2020, 1, 1, 0, 0, 59, 999, 999));
        final next = generator.after(minute);
        final expected = Period(
          start: DateTime(2020, 1, 1, 0, 1, 0),
          end: DateTime(2020, 1, 1, 0, 1, 59, 999, 999),
        );
        expect(next, equals(expected));
      });
    });
    test('fits generator', () {
      final period = Period(
        start: DateTime(2020, 1, 1, 0, 0, 0),
        end: DateTime(2020, 1, 1, 0, 0, 59, 999, 999),
      );
      expect(generator.fitsGenerator(period), isTrue);
    });
  });
  group('HourPeriodGenerator', () {
    const generator = HourGenerator();
    group('of', () {
      final period = Period(
        start: DateTime(2020, 1, 1, 0, 0, 0),
        end: DateTime(2020, 1, 1, 0, 59, 59, 999, 999),
      );
      test('Start of hour', () {
        final hour = generator.of(DateTime(2020, 1, 1, 0, 0, 0));
        expect(hour, equals(period));
      });
      test('End of hour', () {
        final hour = generator.of(DateTime(2020, 1, 1, 0, 59, 59, 999, 999));
        expect(hour, equals(period));
      });
    });
    group('minutes', () {
      const minuteGenerator = MinuteGenerator();
      final hour = generator.of(DateTime(2020, 1, 1, 0, 0, 0));
      final minutes = hour.minutes;
      test('type', () {
        expect(minutes, isA<List<MinutePeriod>>());
      });
      test('lenght', () {
        expect(minutes.length, equals(60));
      });
      test('Start of hour', () {
        final firstMinute = minuteGenerator.of(DateTime(2020, 1, 1, 0, 0, 0));
        expect(minutes.first, equals(firstMinute));
      });
      test('End of hour', () {
        final lastMinute = minuteGenerator.of(
          DateTime(2020, 1, 1, 0, 59, 59, 999, 999),
        );
        expect(minutes.last, equals(lastMinute));
      });
    });
    group('before', () {
      test('Start of hour', () {
        final hour = generator.of(DateTime(2020, 1, 1, 0, 0, 0));
        final previous = generator.before(hour);
        final expected = Period(
          start: DateTime(2019, 12, 31, 23, 0, 0),
          end: DateTime(2019, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });
      test('End of hour', () {
        final hour = generator.of(DateTime(2020, 1, 1, 0, 59, 59, 999, 999));
        final previous = generator.before(hour);
        final expected = Period(
          start: DateTime(2019, 12, 31, 23, 0, 0),
          end: DateTime(2019, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });
    });
    group('after', () {
      test('Start of hour', () {
        final hour = generator.of(DateTime(2020, 1, 1, 0, 0, 0));
        final next = generator.after(hour);
        final expected = Period(
          start: DateTime(2020, 1, 1, 1, 0, 0),
          end: DateTime(2020, 1, 1, 1, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });
      test('End of hour', () {
        final hour = generator.of(DateTime(2020, 1, 1, 0, 59, 59, 999, 999));
        final next = generator.after(hour);
        final expected = Period(
          start: DateTime(2020, 1, 1, 1, 0, 0),
          end: DateTime(2020, 1, 1, 1, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });
    });
    test('fits generator', () {
      final period = Period(
        start: DateTime(2020, 1, 1, 0, 0, 0),
        end: DateTime(2020, 1, 1, 0, 59, 59, 999, 999),
      );
      expect(generator.fitsGenerator(period), isTrue);
    });
  });
  group('DayPeriodGenerator', () {
    const generator = DayGenerator();
    group('of', () {
      final period = Period(
        start: DateTime(2020, 1, 1, 0, 0, 0),
        end: DateTime(2020, 1, 1, 23, 59, 59, 999, 999),
      );
      test('Start of day', () {
        final day = generator.of(DateTime(2020, 1, 1, 0, 0, 0));
        expect(day, equals(period));
      });
      test('End of day', () {
        final day = generator.of(DateTime(2020, 1, 1, 23, 59, 59, 999, 999));
        expect(day, equals(period));
      });
    });
    group('hours', () {
      const hourGenerator = HourGenerator();
      final day = generator.of(DateTime(2020, 1, 1, 0, 0, 0));
      final hours = day.hours;
      test('type', () {
        expect(hours, isA<List<HourPeriod>>());
      });
      test('lenght', () {
        expect(hours.length, equals(24));
      });
      test('Start of day', () {
        final firstHour = hourGenerator.of(DateTime(2020, 1, 1, 0, 0, 0));
        expect(hours.first, equals(firstHour));
      });
      test('End of day', () {
        final lastHour = hourGenerator.of(
          DateTime(2020, 1, 1, 23, 59, 59, 999, 999),
        );
        expect(hours.last, equals(lastHour));
      });
    });
    group('before', () {
      test('Start of day', () {
        final day = generator.of(DateTime(2020, 1, 1, 0, 0, 0));
        final previous = generator.before(day);
        final expected = Period(
          start: DateTime(2019, 12, 31, 0, 0, 0),
          end: DateTime(2019, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });
      test('End of day', () {
        final day = generator.of(DateTime(2020, 1, 1, 23, 59, 59, 999, 999));
        final previous = generator.before(day);
        final expected = Period(
          start: DateTime(2019, 12, 31, 0, 0, 0),
          end: DateTime(2019, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(previous, equals(expected));
      });
    });
    group('after', () {
      test('Start of day', () {
        final day = generator.of(DateTime(2020, 1, 1, 0, 0, 0));
        final next = generator.after(day);
        final expected = Period(
          start: DateTime(2020, 1, 2, 0, 0, 0),
          end: DateTime(2020, 1, 2, 23, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });
      test('End of day', () {
        final day = generator.of(DateTime(2020, 1, 1, 23, 59, 59, 999, 999));
        final next = generator.after(day);
        final expected = Period(
          start: DateTime(2020, 1, 2, 0, 0, 0),
          end: DateTime(2020, 1, 2, 23, 59, 59, 999, 999),
        );
        expect(next, equals(expected));
      });
    });
    test('fits generator', () {
      final period = Period(
        start: DateTime(2020, 1, 1, 0, 0, 0),
        end: DateTime(2020, 1, 1, 23, 59, 59, 999, 999),
      );
      expect(generator.fitsGenerator(period), isTrue);
    });
  });
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
          start: DateTime(2023, 1, 1),
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
      final generator = WeekGenerator();
      test('Start of week', () {
        final week = generator.of(DateTime(2020, 1, 1));
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
      final generator = WeekGenerator();
      test('Start of week', () {
        final week = generator.of(DateTime(2020, 1, 1));
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
  group('FortnightPeriodGenerator', () {
    const fortnightGenerator = FortnightGenerator();
    group('Start of month', () {
      final day = DateTime(2022, DateTime.january, 1);
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
      final day = DateTime(2022, DateTime.january, 1);
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
      final day = DateTime(2022, DateTime.january, 1);
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
          start: DateTime(2022, DateTime.january, 1),
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
  group('MonthPeriodGenerator', () {
    const monthGenerator = MonthGenerator();
    group('Start of month', () {
      final day = DateTime(2022, DateTime.january, 1);
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
        final day = DateTime(2022, DateTime.february, 1);
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
        final day = DateTime(2020, DateTime.february, 1);
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
        final day = DateTime(2022, DateTime.april, 1);
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
        final day = DateTime(2022, DateTime.january, 1);
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
        start: DateTime(2022, DateTime.january, 1),
        end: DateTime(2022, DateTime.january, 31, 23, 59, 59, 999, 999),
      );
      final expected = Period(
        start: DateTime(2021, DateTime.december, 1),
        end: DateTime(2021, DateTime.december, 31, 23, 59, 59, 999, 999),
      );
      test('before', () {
        expect(monthGenerator.before(period), equals(expected));
      });
    });
    group('after', () {
      final period = Period(
        start: DateTime(2022, DateTime.january, 1),
        end: DateTime(2022, 1, 31, 23, 59, 59, 999, 999),
      );
      final expected = Period(
        start: DateTime(2022, 2, 1),
        end: DateTime(2022, 2, 28, 23, 59, 59, 999, 999),
      );
      test('after', () {
        expect(monthGenerator.after(period), equals(expected));
      });
    });
    group('fits generator', () {
      test('28 days', () {
        final period = Period(
          start: DateTime(2022, DateTime.february, 1),
          end: DateTime(2022, 2, 28, 23, 59, 59, 999, 999),
        );
        expect(monthGenerator.fitsGenerator(period), isTrue);
      });
      test('29 days', () {
        final period = Period(
          start: DateTime(2020, DateTime.february, 1),
          end: DateTime(2020, 2, 29, 23, 59, 59, 999, 999),
        );
        expect(monthGenerator.fitsGenerator(period), isTrue);
      });
      test('30 days', () {
        final period = Period(
          start: DateTime(2022, DateTime.april, 1),
          end: DateTime(2022, 4, 30, 23, 59, 59, 999, 999),
        );
        expect(monthGenerator.fitsGenerator(period), isTrue);
      });
      test('31 days', () {
        final period = Period(
          start: DateTime(2022, DateTime.january, 1),
          end: DateTime(2022, 1, 31, 23, 59, 59, 999, 999),
        );
        expect(monthGenerator.fitsGenerator(period), isTrue);
      });
    });
  });
  group('TrimesterPeriodGenerator', () {
    const trimesterGenerator = TrimesterGenerator();
    group('First trimester of the year', () {
      final day = DateTime(2022, DateTime.january, 1);
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
      final day = DateTime(2022, DateTime.april, 1);
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
      final day = DateTime(2022, DateTime.july, 1);
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
      final day = DateTime(2022, DateTime.october, 1);
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
        start: DateTime(2022, DateTime.january, 1),
        end: DateTime(2022, 3, 31, 23, 59, 59, 999, 999),
      );
      final expected = Period(
        start: DateTime(2021, DateTime.october, 1),
        end: DateTime(2021, 12, 31, 23, 59, 59, 999, 999),
      );
      test('returns the previous trimester', () {
        expect(trimesterGenerator.before(period), equals(expected));
      });
    });
    group('after', () {
      final period = Period(
        start: DateTime(2022, DateTime.january, 1),
        end: DateTime(2022, 3, 31, 23, 59, 59, 999, 999),
      );
      final expected = Period(
        start: DateTime(2022, DateTime.april, 1),
        end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
      );
      test('returns the next trimester', () {
        expect(trimesterGenerator.after(period), equals(expected));
      });
    });
    group('fits generator', () {
      test('first trimester leap', () {
        final period = Period(
          start: DateTime(2020, DateTime.january, 1),
          end: DateTime(2020, 3, 31, 23, 59, 59, 999, 999),
        );
        expect(trimesterGenerator.fitsGenerator(period), isTrue);
      });
      test('first trimester non leap', () {
        final period = Period(
          start: DateTime(2022, DateTime.january, 1),
          end: DateTime(2022, 3, 31, 23, 59, 59, 999, 999),
        );
        expect(trimesterGenerator.fitsGenerator(period), isTrue);
      });
      test('second trimester', () {
        final period = Period(
          start: DateTime(2022, DateTime.april, 1),
          end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
        );
        expect(trimesterGenerator.fitsGenerator(period), isTrue);
      });
      test('third trimester', () {
        final period = Period(
          start: DateTime(2022, DateTime.july, 1),
          end: DateTime(2022, 9, 30, 23, 59, 59, 999, 999),
        );
        expect(trimesterGenerator.fitsGenerator(period), isTrue);
      });
      test('fourth trimester', () {
        final period = Period(
          start: DateTime(2022, DateTime.october, 1),
          end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(trimesterGenerator.fitsGenerator(period), isTrue);
      });
    });
  });
  group('SemesterPeriodGenerator', () {
    const semesterGenerator = SemesterGenerator();
    group('First semester of the year', () {
      final day = DateTime(2022, DateTime.january, 1);
      final period = Period(
        start: day.date,
        end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
      );
      test('ends on june 30th', () {
        expect(semesterGenerator.of(day), equals(period));
      });
      group('months', () {
        const monthGenerator = MonthGenerator();
        final semester = semesterGenerator.of(day);
        final months = semester.months;
        test('type', () {
          expect(months, isA<List<MonthPeriod>>());
        });
        test('length', () {
          expect(months.length, equals(6));
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
    group('Second semester of the year', () {
      final day = DateTime(2022, DateTime.july, 1);
      final period = Period(
        start: day.date,
        end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
      );
      test('ends on december 31st', () {
        expect(semesterGenerator.of(day), equals(period));
      });
      group('months', () {
        const monthGenerator = MonthGenerator();
        final semester = semesterGenerator.of(day);
        final months = semester.months;
        test('type', () {
          expect(months, isA<List<MonthPeriod>>());
        });
        test('length', () {
          expect(months.length, equals(6));
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
        start: DateTime(2022, DateTime.july, 1),
        end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
      );
      final expected = Period(
        start: DateTime(2022, DateTime.january, 1),
        end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
      );
      test('returns the previous semester', () {
        expect(semesterGenerator.before(period), equals(expected));
      });
    });
    group('after', () {
      final period = Period(
        start: DateTime(2022, DateTime.january, 1),
        end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
      );
      final expected = Period(
        start: DateTime(2022, DateTime.july, 1),
        end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
      );
      test('returns the next semester', () {
        expect(semesterGenerator.after(period), equals(expected));
      });
    });
    group('fits generator', () {
      test('first semester', () {
        final period = Period(
          start: DateTime(2022, DateTime.january, 1),
          end: DateTime(2022, 6, 30, 23, 59, 59, 999, 999),
        );
        expect(semesterGenerator.fitsGenerator(period), isTrue);
      });
      test('second semester', () {
        final period = Period(
          start: DateTime(2022, DateTime.july, 1),
          end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(semesterGenerator.fitsGenerator(period), isTrue);
      });
    });
  });
  group('YearPeriodGenerator', () {
    const yearGenerator = YearGenerator();
    group('Non leap year', () {
      final day = DateTime(2022, DateTime.january, 1);
      final period = Period(
        start: day.date,
        end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
      );
      test('ends on december 31st', () {
        expect(yearGenerator.of(day), equals(period));
      });
      group('months', () {
        const monthGenerator = MonthGenerator();
        final year = yearGenerator.of(day);
        final months = year.months;
        test('type', () {
          expect(months, isA<List<MonthPeriod>>());
        });
        test('length', () {
          expect(months.length, equals(12));
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
    group('Leap year', () {
      final day = DateTime(2020, DateTime.january, 1);
      final period = Period(
        start: day.date,
        end: DateTime(2020, 12, 31, 23, 59, 59, 999, 999),
      );
      test('ends on december 31st', () {
        expect(yearGenerator.of(day), equals(period));
      });
      group('months', () {
        const monthGenerator = MonthGenerator();
        final year = yearGenerator.of(day);
        final months = year.months;
        test('type', () {
          expect(months, isA<List<MonthPeriod>>());
        });
        test('length', () {
          expect(months.length, equals(12));
        });
        test('start', () {
          expect(months.first, equals(monthGenerator.of(day)));
        });
        test('end', () {
          expect(
            months.last,
            equals(monthGenerator.of(DateTime(2020, 12, 31))),
          );
        });
      });
    });
    group('before', () {
      final period = Period(
        start: DateTime(2022, DateTime.january, 1),
        end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
      );
      final expected = Period(
        start: DateTime(2021, DateTime.january, 1),
        end: DateTime(2021, 12, 31, 23, 59, 59, 999, 999),
      );
      test('returns the previous year', () {
        expect(yearGenerator.before(period), equals(expected));
      });
    });
    group('after', () {
      final period = Period(
        start: DateTime(2021, DateTime.january, 1),
        end: DateTime(2021, 12, 31, 23, 59, 59, 999, 999),
      );
      final expected = Period(
        start: DateTime(2022, DateTime.january, 1),
        end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
      );
      test('returns the next year', () {
        expect(yearGenerator.after(period), equals(expected));
      });
    });
    group('fits generator', () {
      test('leap year', () {
        final period = Period(
          start: DateTime(2020, DateTime.january, 1),
          end: DateTime(2020, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(yearGenerator.fitsGenerator(period), isTrue);
      });
      test('non leap year', () {
        final period = Period(
          start: DateTime(2022, DateTime.january, 1),
          end: DateTime(2022, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(yearGenerator.fitsGenerator(period), isTrue);
      });
    });
  });
}
