// ignore_for_file: prefer_const_constructors

import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('WeekdayOccurrence:', () {
    group('Values', () {
      test('Has all expected values', () {
        expect(WeekdayOccurrence.values.length, equals(35));
        expect(
          WeekdayOccurrence.values,
          containsAllInOrder([
            WeekdayOccurrence.firstMonday,
            WeekdayOccurrence.firstTuesday,
            WeekdayOccurrence.firstWednesday,
            WeekdayOccurrence.firstThursday,
            WeekdayOccurrence.firstFriday,
            WeekdayOccurrence.firstSaturday,
            WeekdayOccurrence.firstSunday,
            WeekdayOccurrence.secondMonday,
            WeekdayOccurrence.secondTuesday,
            WeekdayOccurrence.secondWednesday,
            WeekdayOccurrence.secondThursday,
            WeekdayOccurrence.secondFriday,
            WeekdayOccurrence.secondSaturday,
            WeekdayOccurrence.secondSunday,
            WeekdayOccurrence.thirdMonday,
            WeekdayOccurrence.thirdTuesday,
            WeekdayOccurrence.thirdWednesday,
            WeekdayOccurrence.thirdThursday,
            WeekdayOccurrence.thirdFriday,
            WeekdayOccurrence.thirdSaturday,
            WeekdayOccurrence.thirdSunday,
            WeekdayOccurrence.fourthMonday,
            WeekdayOccurrence.fourthTuesday,
            WeekdayOccurrence.fourthWednesday,
            WeekdayOccurrence.fourthThursday,
            WeekdayOccurrence.fourthFriday,
            WeekdayOccurrence.fourthSaturday,
            WeekdayOccurrence.fourthSunday,
            WeekdayOccurrence.lastMonday,
            WeekdayOccurrence.lastTuesday,
            WeekdayOccurrence.lastWednesday,
            WeekdayOccurrence.lastThursday,
            WeekdayOccurrence.lastFriday,
            WeekdayOccurrence.lastSaturday,
            WeekdayOccurrence.lastSunday,
          ]),
        );
      });
    });
    group('Equals', () {
      test('firstMonday equals EveryWeekdayCountInMonth', () {
        const weekdayOccurrence = WeekdayOccurrence.firstMonday;
        const everyWeekdayCountInMonth = EveryWeekdayCountInMonth(
          week: Week.first,
          day: Weekday.monday,
        );
        expect(
          weekdayOccurrence,
          equals(everyWeekdayCountInMonth),
        );
      });
    });
    group('String representation', () {
      test('All have correct string representation', () {
        expect(
          WeekdayOccurrence.firstMonday.toString(),
          equals('WeekdayOccurrence.firstMonday'),
        );
        expect(
          WeekdayOccurrence.firstTuesday.toString(),
          equals('WeekdayOccurrence.firstTuesday'),
        );
        expect(
          WeekdayOccurrence.firstWednesday.toString(),
          equals('WeekdayOccurrence.firstWednesday'),
        );
        expect(
          WeekdayOccurrence.firstThursday.toString(),
          equals('WeekdayOccurrence.firstThursday'),
        );
        expect(
          WeekdayOccurrence.firstFriday.toString(),
          equals('WeekdayOccurrence.firstFriday'),
        );
        expect(
          WeekdayOccurrence.firstSaturday.toString(),
          equals('WeekdayOccurrence.firstSaturday'),
        );
        expect(
          WeekdayOccurrence.firstSunday.toString(),
          equals('WeekdayOccurrence.firstSunday'),
        );
      });
    });
    group('Name property', () {
      test('All have correct name', () {
        expect(WeekdayOccurrence.firstMonday.name, equals('firstMonday'));
        expect(WeekdayOccurrence.firstTuesday.name, equals('firstTuesday'));
        expect(WeekdayOccurrence.firstWednesday.name, equals('firstWednesday'));
        expect(WeekdayOccurrence.firstThursday.name, equals('firstThursday'));
        expect(WeekdayOccurrence.firstFriday.name, equals('firstFriday'));
        expect(WeekdayOccurrence.firstSaturday.name, equals('firstSaturday'));
        expect(WeekdayOccurrence.firstSunday.name, equals('firstSunday'));
      });
    });
    group('Index property', () {
      test('All have correct index', () {
        for (var i = 0; i < WeekdayOccurrence.values.length; i++) {
          expect(WeekdayOccurrence.values[i].index, equals(i));
        }
      });
    });
    group('Equality', () {
      test('Same values are equal', () {
        expect(
          WeekdayOccurrence.firstMonday,
          equals(WeekdayOccurrence.firstMonday),
        );
        expect(
          WeekdayOccurrence.firstTuesday,
          equals(WeekdayOccurrence.firstTuesday),
        );
      });
      test('Different values are not equal', () {
        expect(
          WeekdayOccurrence.firstMonday,
          isNot(equals(WeekdayOccurrence.firstTuesday)),
        );
        expect(
          WeekdayOccurrence.firstWednesday,
          isNot(equals(WeekdayOccurrence.firstThursday)),
        );
      });
    });
    group('Edge Cases', () {
      test('All values are unique', () {
        final set = WeekdayOccurrence.values.toSet();
        expect(set.length, equals(WeekdayOccurrence.values.length));
      });
    });
  });
}
