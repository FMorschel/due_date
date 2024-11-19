import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('Weekday:', () {
    group('Throw on factory outside of range:', () {
      test('Value below 1', () {
        expect(() => Weekday.fromDateTimeValue(0), throwsRangeError);
      });
      test('Value above 7', () {
        expect(() => Weekday.fromDateTimeValue(8), throwsRangeError);
      });
    });
    group('Previous:', () {
      for (final weekday in Weekday.values) {
        test(weekday.name, () {
          if (weekday != Weekday.monday) {
            expect(
              weekday.previous,
              equals(Weekday.fromDateTimeValue(weekday.dateTimeValue - 1)),
            );
          } else {
            expect(weekday.previous, equals(Weekday.sunday));
          }
        });
      }
    });
    group('Next:', () {
      for (final weekday in Weekday.values) {
        test(weekday.name, () {
          if (weekday != Weekday.sunday) {
            expect(
              weekday.next,
              equals(Weekday.fromDateTimeValue(weekday.dateTimeValue + 1)),
            );
          } else {
            expect(weekday.next, equals(Weekday.monday));
          }
        });
      }
    });
    group('WeekendDays:', () {
      final set = {Weekday.saturday, Weekday.sunday};
      test('Contains $set', () {
        expect(
          Weekday.weekend,
          containsAllInOrder(set),
        );
      });
      test('Is ${set.runtimeType}', () {
        expect(
          Weekday.weekend,
          isA<Set<Weekday>>(),
        );
      });
    });
    group('Workdays:', () {
      final set = {
        Weekday.monday,
        Weekday.tuesday,
        Weekday.wednesday,
        Weekday.thursday,
        Weekday.friday,
      };
      test('Contains $set', () {
        expect(
          Weekday.workdays,
          containsAllInOrder(set),
        );
      });
      test('Is ${set.runtimeType}', () {
        expect(
          Weekday.workdays,
          isA<Set<Weekday>>(),
        );
      });
    });
    group('fromThisWeek:', () {
      final date = DateTime.utc(2022, DateTime.august, 8);
      for (final weekday in Weekday.values) {
        test(weekday.name, () {
          expect(
            weekday.fromWeekOf(date),
            equals(DateTime.utc(2022, DateTime.august, 8 + weekday.index)),
          );
        });
      }
    });
    group('occurrencesIn august 2022', () {
      final month = DateTime.utc(2022, DateTime.august);
      test('monday', () {
        const monday = Weekday.monday;
        expect(
          monday.occurrencesIn(month.year, month.month),
          equals(5),
        );
      });
      test('tuesday', () {
        const tuesday = Weekday.tuesday;
        expect(
          tuesday.occurrencesIn(month.year, month.month),
          equals(5),
        );
      });
      test('wednesday', () {
        const wednesday = Weekday.wednesday;
        expect(
          wednesday.occurrencesIn(month.year, month.month),
          equals(5),
        );
      });
      test('thursday', () {
        const thursday = Weekday.thursday;
        expect(
          thursday.occurrencesIn(month.year, month.month),
          equals(4),
        );
      });
      test('friday', () {
        const friday = Weekday.friday;
        expect(
          friday.occurrencesIn(month.year, month.month),
          equals(4),
        );
      });
      test('saturday', () {
        const saturday = Weekday.saturday;
        expect(
          saturday.occurrencesIn(month.year, month.month),
          equals(4),
        );
      });
      test('sunday', () {
        const sunday = Weekday.sunday;
        expect(
          sunday.occurrencesIn(month.year, month.month),
          equals(4),
        );
      });
    });
  });
}
