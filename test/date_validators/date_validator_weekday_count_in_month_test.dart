// ignore_for_file: prefer_const_constructors

import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('DateValidatorWeekdayCountInMonth', () {
    group('Constructor', () {
      group('Unnamed', () {
        test('First Monday', () {
          expect(
            DateValidatorWeekdayCountInMonth(
              week: Week.first,
              day: Weekday.monday,
            ),
            isNotNull,
          );
        });
        test('Last Friday', () {
          expect(
            DateValidatorWeekdayCountInMonth(
              week: Week.last,
              day: Weekday.friday,
            ),
            isNotNull,
          );
        });
        test('Properties are set correctly', () {
          final validator = DateValidatorWeekdayCountInMonth(
            week: Week.second,
            day: Weekday.tuesday,
          );
          expect(validator.week, equals(Week.second));
          expect(validator.day, equals(Weekday.tuesday));
        });
        group('asserts limits', () {
          // Removed null tests due to null safety.
        });
      });
      group('from', () {
        test('Valid basic case', () {
          // 3rd Tuesday of September 2022 is 13th.
          final date = DateTime(2022, 9, 13);
          expect(DateValidatorWeekdayCountInMonth.from(date), isNotNull);
        });
        test('Creates validator with correct week and day', () {
          final date = DateTime(2022, 9, 13);
          final validator = DateValidatorWeekdayCountInMonth.from(date);
          expect(validator.week, equals(Week.third));
          expect(validator.day, equals(Weekday.tuesday));
        });
      });
    });

    group('Properties', () {
      test('week returns correct value', () {
        final validator = DateValidatorWeekdayCountInMonth(
          week: Week.third,
          day: Weekday.wednesday,
        );
        expect(validator.week, equals(Week.third));
      });
      test('day returns correct value', () {
        final validator = DateValidatorWeekdayCountInMonth(
          week: Week.third,
          day: Weekday.wednesday,
        );
        expect(validator.day, equals(Weekday.wednesday));
      });
    });

    group('Methods', () {
      group('compareTo', () {
        test('Same week and day returns 0', () {
          final v1 = DateValidatorWeekdayCountInMonth(
            week: Week.first,
            day: Weekday.monday,
          );
          final v2 = DateValidatorWeekdayCountInMonth(
            week: Week.first,
            day: Weekday.monday,
          );
          expect(v1.compareTo(v2), equals(0));
        });
        test('Lower week returns negative', () {
          final v1 = DateValidatorWeekdayCountInMonth(
            week: Week.first,
            day: Weekday.monday,
          );
          final v2 = DateValidatorWeekdayCountInMonth(
            week: Week.second,
            day: Weekday.monday,
          );
          expect(v1.compareTo(v2), isNegative);
        });
        test('Higher week returns positive', () {
          final v1 = DateValidatorWeekdayCountInMonth(
            week: Week.last,
            day: Weekday.monday,
          );
          final v2 = DateValidatorWeekdayCountInMonth(
            week: Week.third,
            day: Weekday.monday,
          );
          expect(v1.compareTo(v2), isPositive);
        });
        test('Different day returns nonzero', () {
          final v1 = DateValidatorWeekdayCountInMonth(
            week: Week.first,
            day: Weekday.monday,
          );
          final v2 = DateValidatorWeekdayCountInMonth(
            week: Week.first,
            day: Weekday.tuesday,
          );
          expect(v1.compareTo(v2), isNot(0));
        });
      });
    });

    group('Edge Cases', () {
      test('Handles all WeekdayOccurrence values', () {
        for (final occurrence in WeekdayOccurrence.values) {
          final validator = DateValidatorWeekdayCountInMonth(
            week: occurrence.week,
            day: occurrence.day,
          );
          final date = occurrence.startDate(DateTime(2022, 9));
          expect(
            validator.valid(date),
            isTrue,
            reason: 'Should be valid for $date',
          );
        }
      });
    });

    group('Equality', () {
      final v1 = DateValidatorWeekdayCountInMonth(
        week: Week.first,
        day: Weekday.monday,
      );
      final v2 = DateValidatorWeekdayCountInMonth(
        week: Week.first,
        day: Weekday.tuesday,
      );
      final v3 = DateValidatorWeekdayCountInMonth(
        week: Week.first,
        day: Weekday.monday,
      );

      test('Same instance', () {
        expect(v1, equals(v1));
      });
      test('Different day', () {
        expect(v1, isNot(equals(v2)));
      });
      test('Same week and day', () {
        expect(v1, equals(v3));
      });
      test('Hash code consistency', () {
        final v4 = DateValidatorWeekdayCountInMonth(
          week: Week.first,
          day: Weekday.monday,
        );
        expect(v1.hashCode, equals(v4.hashCode));
      });
    });

    // Comprehensive validation using WeekdayOccurrence.
    group('valid:', () {
      for (final occurrence in WeekdayOccurrence.values) {
        group(occurrence.name, () {
          final validator = DateValidatorWeekdayCountInMonth(
            day: occurrence.day,
            week: occurrence.week,
          );
          test('Is valid for canonical date', () {
            final date = occurrence.startDate(
              DateTime(2022, DateTime.september),
            );
            expect(
              validator.valid(date),
              isTrue,
              reason: 'Should be valid for $date',
            );
          });
          test('Is not valid for a different weekday in same week', () {
            final week = occurrence.week;
            final otherDay = Weekday.values.firstWhere(
              (d) => d != occurrence.day,
            );
            final otherOccurrence = WeekdayOccurrence.values.firstWhere(
              (o) => o.week == week && o.day == otherDay,
            );
            final otherDate = otherOccurrence.startDate(
              DateTime(2022, DateTime.september),
            );
            expect(
              validator.valid(otherDate),
              isFalse,
              reason: 'Should not be valid for $otherDate',
            );
          });
        });
      }
    });
  });
}
