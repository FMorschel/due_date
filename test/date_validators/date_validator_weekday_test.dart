// ignore_for_file: prefer_const_constructors

import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

import '../src/date_tostring.dart';
import '../src/date_validator_match.dart';

void main() {
  group('DateValidatorWeekday:', () {
    group('Constructor', () {
      group('Unnamed', () {
        test('Monday', () {
          expect(DateValidatorWeekday(Weekday.monday), isNotNull);
        });
        test('Sunday', () {
          expect(DateValidatorWeekday(Weekday.sunday), isNotNull);
        });
        test('Weekday property is set correctly', () {
          expect(
            DateValidatorWeekday(Weekday.tuesday).weekday,
            equals(Weekday.tuesday),
          );
        });
      });
      group('from', () {
        test('Valid basic case', () {
          // Monday.
          final date = DateTime(2024, 7);
          expect(DateValidatorWeekday.from(date), isNotNull);
        });
        test('Creates validator with correct weekday', () {
          // Tuesday.
          final date = DateTime(2024, 7, 2);
          final validator = DateValidatorWeekday.from(date);
          expect(validator.weekday, equals(Weekday.tuesday));
        });
      });
    });

    group('valid:', () {
      for (final weekday in Weekday.values) {
        group(weekday.name, () {
          final validator = DateValidatorWeekday(weekday);
          for (var i = 1; i <= 7; i++) {
            // July 1, 2024 is Monday.
            final date = DateTime(2024, 7, i);
            final valid = date.weekday == weekday.index + 1;
            test(
                '${DateToString.from(date)} is '
                '${valid ? '' : 'not '}valid', () {
              expect(validator, (valid ? isValid : isInvalid)(date));
            });
          }
        });
      }
    });

    group('Properties', () {
      test('weekday returns correct value', () {
        final validator = DateValidatorWeekday(Weekday.saturday);
        expect(validator.weekday, equals(Weekday.saturday));
      });
    });

    group('Methods', () {
      group('compareTo', () {
        test('Same weekday returns 0', () {
          final v1 = DateValidatorWeekday(Weekday.friday);
          final v2 = DateValidatorWeekday(Weekday.friday);
          expect(v1.compareTo(v2), equals(0));
        });
        test('Lower weekday returns negative', () {
          final v1 = DateValidatorWeekday(Weekday.monday);
          final v2 = DateValidatorWeekday(Weekday.wednesday);
          expect(v1.compareTo(v2), isNegative);
        });
        test('Higher weekday returns positive', () {
          final v1 = DateValidatorWeekday(Weekday.sunday);
          final v2 = DateValidatorWeekday(Weekday.friday);
          expect(v1.compareTo(v2), isPositive);
        });
      });
    });

    group('Edge Cases', () {
      test('Handles all weekdays', () {
        for (final weekday in Weekday.values) {
          final validator = DateValidatorWeekday(weekday);
          for (var i = 1; i <= 7; i++) {
            final date = DateTime(2024, 7, i);
            final valid = date.weekday == weekday.index + 1;
            expect(validator, (valid ? isValid : isInvalid)(date));
          }
        }
      });
    });

    group('Equality', () {
      final v1 = DateValidatorWeekday(Weekday.monday);
      final v2 = DateValidatorWeekday(Weekday.tuesday);
      final v3 = DateValidatorWeekday(Weekday.monday);

      test('Same instance', () {
        expect(v1, equals(v1));
      });
      test('Different weekday', () {
        expect(v1, isNot(equals(v2)));
      });
      test('Same weekday', () {
        expect(v1, equals(v3));
      });
      test('Hash code consistency', () {
        final v4 = DateValidatorWeekday(Weekday.monday);
        expect(v1.hashCode, equals(v4.hashCode));
      });
    });
  });
}
