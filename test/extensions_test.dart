import 'package:due_date/due_date.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:time/time.dart';

void main() {
  group('DayInYear on DateTime', () {
    test('January 1st', () {
      expect(DateTime(2022, DateTime.january, 1).dayInYear, 1);
    });
    test('December 31st 2022', () {
      expect(DateTime(2022, DateTime.december, 31).dayInYear, 365);
    });
    test('December 31st 2020', () {
      expect(DateTime(2020, DateTime.december, 31).dayInYear, 366);
    });
  });
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
      test(Weekday.fromDateTimeValue(monday.weekday).name, () {
        expect(monday.isWorkday, isTrue);
      });
      for (final weekday in monday.to(friday, by: const Duration(days: 1))) {
        test(Weekday.fromDateTimeValue(weekday.weekday).name, () {
          expect(weekday.isWorkday, isTrue);
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
    test('Current month', () {
      expect(date.clampInMonth(july), equals(date));
    });
  });
  group('PreviousNext on Iterable of Weekday:', () {
    final entireWeek = <Weekday>[...Weekday.values];
    group('daysBefore:', () {
      group('single:', () {
        for (final weekday in Weekday.values) {
          final macther = [weekday.previous];
          final result = [weekday].previousWeekdays;
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
            () => expect(iterable.previousWeekdays, containsAll(macther)),
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
            () => expect([weekday].nextWeekdays, equals(macther)),
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
            () => expect(iterable.nextWeekdays, containsAll(macther)),
          );
        }
      });
    });
  });
  group('DateValidatorListExt on List<DateValidator>', () {
    const tuesday = DateValidatorWeekday(Weekday.tuesday);
    const thursday = DateValidatorWeekday(Weekday.thursday);
    final list = [tuesday, thursday];
    test('Intersection', () {
      final result = DateValidatorIntersection(list);
      expect(list.intersection, equals(result));
    });
    test('Union', () {
      final result = DateValidatorUnion(list);
      expect(list.union, equals(result));
    });
    test('Difference', () {
      final result = DateValidatorDifference(list);
      expect(list.difference, equals(result));
    });
  });
  group('EveryDateValidatorListExt on List<EveryDateValidator>', () {
    const tuesday = EveryWeekday(Weekday.tuesday);
    const thursday = EveryWeekday(Weekday.thursday);
    final list = [tuesday, thursday];
    test('Intersection', () {
      final result = EveryDateValidatorIntersection(list);
      expect(list.intersection, equals(result));
    });
    test('Union', () {
      final result = EveryDateValidatorUnion(list);
      expect(list.union, equals(result));
    });
    test('Difference', () {
      final result = EveryDateValidatorDifference(list);
      expect(list.difference, equals(result));
    });
  });
}
