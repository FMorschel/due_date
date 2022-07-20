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
