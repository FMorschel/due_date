// ignore_for_file: prefer_const_constructors

import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('Weekday:', () {
    group('Values', () {
      test('Has all expected values', () {
        expect(Weekday.values.length, equals(7));
        expect(
          Weekday.values,
          containsAllInOrder([
            Weekday.monday,
            Weekday.tuesday,
            Weekday.wednesday,
            Weekday.thursday,
            Weekday.friday,
            Weekday.saturday,
            Weekday.sunday,
          ]),
        );
      });
    });
    group('Factory methods', () {
      group('Throw on factory outside of range:', () {
        test('Value below 1', () {
          expect(() => Weekday.fromDateTimeValue(0), throwsRangeError);
        });
        test('Value above 7', () {
          expect(() => Weekday.fromDateTimeValue(8), throwsRangeError);
        });
      });
    });
    group('Navigation methods', () {
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
    });
    group('Collections', () {
      group('WeekendDays:', () {
        final set = {Weekday.saturday, Weekday.sunday};
        test('Contains all weekend days', () {
          expect(
            Weekday.weekend,
            containsAllInOrder(set),
          );
        });
        test('Is Set<Weekday>', () {
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
        test('Contains all workdays', () {
          expect(
            Weekday.workdays,
            containsAllInOrder(set),
          );
        });
        test('Is Set<Weekday>', () {
          expect(
            Weekday.workdays,
            isA<Set<Weekday>>(),
          );
        });
      });
    });
    group('Properties for all values:', () {
      for (final weekday in Weekday.values) {
        group(weekday.name, () {
          test('dateTimeValue is correct', () {
            expect(weekday.dateTimeValue, equals(weekday.index + 1));
          });
        });
      }
    });
    group('fromThisWeek:', () {
      final date = DateTime.utc(2022, DateTime.august, 8);
      for (final weekday in Weekday.values) {
        test(weekday.name, () {
          final result = weekday.fromWeekOf(date);
          expect(result.weekday, equals(weekday.dateTimeValue));
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
    group('String representation', () {
      test('All weekdays have correct string representation', () {
        expect(Weekday.monday.toString(), equals('Weekday.monday'));
        expect(Weekday.tuesday.toString(), equals('Weekday.tuesday'));
        expect(Weekday.wednesday.toString(), equals('Weekday.wednesday'));
        expect(Weekday.thursday.toString(), equals('Weekday.thursday'));
        expect(Weekday.friday.toString(), equals('Weekday.friday'));
        expect(Weekday.saturday.toString(), equals('Weekday.saturday'));
        expect(Weekday.sunday.toString(), equals('Weekday.sunday'));
      });
    });
    group('Name property', () {
      test('All weekdays have correct name', () {
        expect(Weekday.monday.name, equals('monday'));
        expect(Weekday.tuesday.name, equals('tuesday'));
        expect(Weekday.wednesday.name, equals('wednesday'));
        expect(Weekday.thursday.name, equals('thursday'));
        expect(Weekday.friday.name, equals('friday'));
        expect(Weekday.saturday.name, equals('saturday'));
        expect(Weekday.sunday.name, equals('sunday'));
      });
    });
    group('Index property', () {
      test('All weekdays have correct index', () {
        for (var i = 0; i < Weekday.values.length; i++) {
          expect(Weekday.values[i].index, equals(i));
        }
      });
    });
    group('Equality', () {
      test('Same values are equal', () {
        expect(Weekday.monday, equals(Weekday.monday));
        expect(Weekday.sunday, equals(Weekday.sunday));
      });
      test('Different values are not equal', () {
        expect(Weekday.monday, isNot(equals(Weekday.tuesday)));
        expect(Weekday.friday, isNot(equals(Weekday.saturday)));
      });
    });
    group('Edge Cases', () {
      test('All weekdays are unique', () {
        final set = Weekday.values.toSet();
        expect(set.length, equals(Weekday.values.length));
      });
    });
  });
}
