import 'package:due_date/due_date.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Weekday:', () {
    group('Throw on factory outside of range:', () {
      test('Value below 1', () {
        expect(() => Weekday.fromDateTime(0), throwsRangeError);
      });
      test('Value above 7', () {
        expect(() => Weekday.fromDateTime(8), throwsRangeError);
      });
    });
    group('Previous:', () {
      for (final weekday in Weekday.values) {
        test(weekday.name, () {
          if (weekday != Weekday.monday) {
            expect(weekday.previous, Weekday.fromDateTime(weekday.weekday - 1));
          } else {
            expect(weekday.previous, Weekday.sunday);
          }
        });
      }
    });
    group('Next:', () {
      for (final weekday in Weekday.values) {
        test(weekday.name, () {
          if (weekday != Weekday.sunday) {
            expect(weekday.next, Weekday.fromDateTime(weekday.weekday + 1));
          } else {
            expect(weekday.next, Weekday.monday);
          }
        });
      }
    });
    group('WeekendDays:', () {
      final set = {Weekday.saturday, Weekday.sunday};
      test('Contains $set', () {
        expect(
          Weekday.weekendDays,
          containsAllInOrder(set),
        );
      });
      test('Is ${set.runtimeType}', () {
        expect(
          Weekday.weekendDays,
          isA<Set<Weekday>>(),
        );
      });
    });
  });
  group('Month:', () {
    group('Throw on factory outside of range:', () {
      test('Value below 1', () {
        expect(() => Month.fromDateTime(0), throwsRangeError);
      });
      test('Value above 12', () {
        expect(() => Month.fromDateTime(13), throwsRangeError);
      });
    });
    group('Previous:', () {
      for (final month in Month.values) {
        test(month.name, () {
          if (month != Month.january) {
            expect(month.previous, Month.fromDateTime(month.month - 1));
          } else {
            expect(month.previous, Month.december);
          }
        });
      }
    });
    group('Next:', () {
      for (final month in Month.values) {
        test(month.name, () {
          if (month != Month.december) {
            expect(month.next, Month.fromDateTime(month.month + 1));
          } else {
            expect(month.next, Month.january);
          }
        });
      }
    });
  });
}
