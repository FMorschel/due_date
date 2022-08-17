import 'package:due_date/due_date.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:time/time.dart';

void main() {
  group('AddDays on DateTime:', () {
    group('Is weekend:', () {
      test('Saturday', () {
        expect(DateTime(2022, DateTime.july, 23).isWeekend, isTrue);
      });
      test('Sunday', () {
        expect(DateTime(2022, DateTime.july, 24).isWeekend, isTrue);
      });
    });
    group('Is workday:', () {
      final monday = DateTime.utc(2022, DateTime.july, 18);
      final friday = DateTime.utc(2022, DateTime.july, 22);
      for (final weekday in monday.to(friday, by: const Duration(days: 1))) {
        test(Weekday.fromDateTime(weekday.weekday).name, () {
          expect(weekday.isWorkDay, isTrue);
        });
      }
    });
    group('Add/Subtract Days:', () {
      final monday = DateTime.utc(2022, DateTime.july, 18);
      group('Assert won\'t skip all days', () {
        final allWeek = Weekday.values;
        test('Add ignoring all weekdays', () {
          expect(
            () => monday.addDays(1, ignoring: allWeek),
            throwsA(isA<AssertionError>()),
          );
        });
        test('Subtract ignoring all weekdays', () {
          expect(
            () => monday.subtractDays(1, ignoring: allWeek),
            throwsA(isA<AssertionError>()),
          );
        });
      });
      group('Add Days:', () {
        final matcher = DateTime.utc(2022, DateTime.july, 25);
        test('Ignoring Tuesdays', () {
          final result = monday.addDays(6, ignoring: [Weekday.tuesday]);
          expect(result, equals(matcher));
        });
        test('Ignoring weekend', () {
          final result = monday.addWorkDays(5);
          expect(result, equals(matcher));
        });
      });
      group('Subtract Days:', () {
        final matcher = DateTime.utc(2022, DateTime.july, 11);
        test('Ignoring Tuesdays', () {
          final result = monday.subtractDays(6, ignoring: [Weekday.tuesday]);
          expect(result, equals(matcher));
        });
        test('Ignoring weekend', () {
          final result = monday.subtractWorkDays(5);
          expect(result, equals(matcher));
        });
      });
    });
  });
  group('WeekCalc on DateTime:', () {
    group('Start of week:', () {
      final august = DateTime.utc(2022, DateTime.august);
      test('First week', () {
        expect(
          august.startOfWeek(Week.first),
          equals(DateTime.utc(2022, DateTime.august)),
        );
      });
      test('Second week', () {
        expect(
          august.startOfWeek(Week.second),
          equals(DateTime.utc(2022, DateTime.august, 8)),
        );
      });
      test('Third week', () {
        expect(
          august.startOfWeek(Week.third),
          equals(DateTime.utc(2022, DateTime.august, 15)),
        );
      });
      test('Fourth week', () {
        expect(
          august.startOfWeek(Week.fourth),
          equals(DateTime.utc(2022, DateTime.august, 22)),
        );
      });
      test('Last week', () {
        expect(
          august.startOfWeek(Week.last),
          equals(DateTime.utc(2022, DateTime.august, 29)),
        );
      });
    });
    group('Next Weekday', () {
      final august = DateTime.utc(2022, DateTime.august);
      test('Monday', () {
        expect(
          august.nextWeekday(Weekday.monday),
          equals(DateTime.utc(2022, DateTime.august, 1)),
        );
      });
      test('Tuesday', () {
        expect(
          august.nextWeekday(Weekday.tuesday),
          equals(DateTime.utc(2022, DateTime.august, 2)),
        );
      });
      test('Wednesday', () {
        expect(
          august.nextWeekday(Weekday.wednesday),
          equals(DateTime.utc(2022, DateTime.august, 3)),
        );
      });
      test('Thursday', () {
        expect(
          august.nextWeekday(Weekday.thursday),
          equals(DateTime.utc(2022, DateTime.august, 4)),
        );
      });
      test('Friday', () {
        expect(
          august.nextWeekday(Weekday.friday),
          equals(DateTime.utc(2022, DateTime.august, 5)),
        );
      });
      test('Saturday', () {
        expect(
          august.nextWeekday(Weekday.saturday),
          equals(DateTime.utc(2022, DateTime.august, 6)),
        );
      });
      test('Sunday', () {
        expect(
          august.nextWeekday(Weekday.sunday),
          equals(DateTime.utc(2022, DateTime.august, 7)),
        );
      });
    });
    group('Previous Weekday', () {
      final august = DateTime.utc(2022, DateTime.august);
      test('Monday', () {
        expect(
          august.previousWeekday(Weekday.monday),
          equals(DateTime.utc(2022, DateTime.august, 1)),
        );
      });
      test('Tuesday', () {
        expect(
          august.previousWeekday(Weekday.tuesday),
          equals(DateTime.utc(2022, DateTime.july, 26)),
        );
      });
      test('Wednesday', () {
        expect(
          august.previousWeekday(Weekday.wednesday),
          equals(DateTime.utc(2022, DateTime.july, 27)),
        );
      });
      test('Thursday', () {
        expect(
          august.previousWeekday(Weekday.thursday),
          equals(DateTime.utc(2022, DateTime.july, 28)),
        );
      });
      test('Friday', () {
        expect(
          august.previousWeekday(Weekday.friday),
          equals(DateTime.utc(2022, DateTime.july, 29)),
        );
      });
      test('Saturday', () {
        expect(
          august.previousWeekday(Weekday.saturday),
          equals(DateTime.utc(2022, DateTime.july, 30)),
        );
      });
      test('Sunday', () {
        expect(
          august.previousWeekday(Weekday.sunday),
          equals(DateTime.utc(2022, DateTime.july, 31)),
        );
      });
    });
  });
  group('ClampInMonth on DateTime:', () {
    final date = DateTime.utc(2022, DateTime.july, 11);
    final july = DateTime.utc(2022, DateTime.july);
    test('PreviousMonth', () {
      expect(july.previousMonth, equals(DateTime.utc(2022, DateTime.june)));
    });
    test('NextMonth', () {
      expect(july.nextMonth, equals(DateTime.utc(2022, DateTime.august)));
    });
    group('Clamp in month', () {
      test('Previous month', () {
        final june = july.previousMonth;
        expect(date.clampInMonth(june), equals(june.lastDayOfMonth));
      });
      test('Current month', () {
        expect(date.clampInMonth(july), equals(date));
      });
      test('Next month', () {
        final august = july.nextMonth;
        expect(date.clampInMonth(august), equals(august));
      });
    });
  });
  group('PreviousNext on Iterable of Weekday:', () {
    final entireWeek = <Weekday>[...Weekday.values];
    group('daysBefore:', () {
      group('single:', () {
        for (final weekday in Weekday.values) {
          final macther = [weekday.previous];
          final result = [weekday].daysBefore;
          test(
            weekday.name,
            () => expect(result, containsAll(macther)),
          );
        }
      });
      group('multiple:', () {
        for (final weekday in Weekday.values) {
          final macther = {...entireWeek}..remove(weekday.previous);
          final iterable = [...entireWeek];
          iterable.remove(weekday);
          test(
            'all but ${weekday.name}',
            () => expect(iterable.daysBefore, containsAll(macther)),
          );
        }
      });
    });
    group('daysAfter:', () {
      group('single:', () {
        for (final weekday in Weekday.values) {
          final macther = {weekday.next};
          test(
            weekday.next,
            () => expect([weekday].daysAfter, equals(macther)),
          );
        }
      });
      group('multiple:', () {
        for (final weekday in Weekday.values) {
          final macther = {...entireWeek}..remove(weekday.next);
          final iterable = [...entireWeek];
          iterable.remove(weekday);
          test(
            'all but ${weekday.name}',
            () => expect(iterable.daysAfter, containsAll(macther)),
          );
        }
      });
    });
  });
}
