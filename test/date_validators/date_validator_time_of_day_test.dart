import 'package:due_date/src/date_validators/built_in/date_validator_time_of_day.dart';
import 'package:test/test.dart';

import '../src/date_validator_match.dart';

void main() {
  group('DateValidatorTimeOfDay:', () {
    group('Constructor', () {
      group('Unnamed', () {
        test('Valid basic case', () {
          expect(DateValidatorTimeOfDay(const Duration(hours: 12)), isNotNull);
        });
        test('last microsecond of day', () {
          expect(
            DateValidatorTimeOfDay(
              const Duration(days: 1) - const Duration(microseconds: 1),
            ),
            isNotNull,
          );
        });
        test('timeOfDay property is set correctly', () {
          final validator =
              DateValidatorTimeOfDay(const Duration(hours: 8, minutes: 15));
          expect(
            validator.timeOfDay,
            equals(const Duration(hours: 8, minutes: 15)),
          );
        });
      });
      group('from', () {
        test('creates instance with correct timeOfDay', () {
          final dateTime = DateTime(2022, 1, 1, 13, 30);
          final validator = DateValidatorTimeOfDay.from(dateTime);
          expect(
            validator.timeOfDay,
            equals(const Duration(hours: 13, minutes: 30)),
          );
        });
      });
    });

    group('Properties', () {
      test('timeOfDay returns correct value', () {
        final validator =
            DateValidatorTimeOfDay(const Duration(hours: 5, minutes: 45));
        expect(
          validator.timeOfDay,
          equals(const Duration(hours: 5, minutes: 45)),
        );
      });
    });

    group('Methods', () {
      group('compareTo', () {
        test('Same timeOfDay returns 0', () {
          final v1 = DateValidatorTimeOfDay(const Duration(hours: 10));
          final v2 = DateValidatorTimeOfDay(const Duration(hours: 10));
          expect(v1.compareTo(v2), equals(0));
        });
        test('Lower timeOfDay returns negative', () {
          final v1 = DateValidatorTimeOfDay(const Duration(hours: 8));
          final v2 = DateValidatorTimeOfDay(const Duration(hours: 12));
          expect(v1.compareTo(v2), isNegative);
        });
        test('Higher timeOfDay returns positive', () {
          final v1 = DateValidatorTimeOfDay(const Duration(hours: 18));
          final v2 = DateValidatorTimeOfDay(const Duration(hours: 12));
          expect(v1.compareTo(v2), isPositive);
        });
      });
    });

    group('Edge Cases', () {
      test('Midnight is valid', () {
        final validator = DateValidatorTimeOfDay(Duration.zero);
        final date = DateTime(2022);
        expect(validator, isValid(date));
      });
      test('Last microsecond of day is valid', () {
        final validator = DateValidatorTimeOfDay(
          const Duration(days: 1) - const Duration(microseconds: 1),
        );
        final date = DateTime(2022, 1, 1, 23, 59, 59, 999, 999);
        expect(validator, isValid(date));
      });
      test('One microsecond after last valid time is invalid', () {
        final validator = DateValidatorTimeOfDay(
          const Duration(days: 1) - const Duration(microseconds: 1),
        );
        final date = DateTime(2022, 1, 2);
        expect(validator, isInvalid(date));
      });
    });

    group('Equality', () {
      final v1 = DateValidatorTimeOfDay(const Duration(hours: 10));
      final v2 = DateValidatorTimeOfDay(const Duration(hours: 11));
      final v3 = DateValidatorTimeOfDay(const Duration(hours: 10));

      test('Same instance', () {
        expect(v1, equals(v1));
      });
      test('Different timeOfDay', () {
        expect(v1, isNot(equals(v2)));
      });
      test('Same timeOfDay', () {
        expect(v1, equals(v3));
      });
      test('Hash code consistency', () {
        final v4 = DateValidatorTimeOfDay(const Duration(hours: 10));
        expect(v1.hashCode, equals(v4.hashCode));
      });
    });

    group('valid:', () {
      // Test a few representative times for brevity (full loop is possible but
      // slow).
      final validator =
          DateValidatorTimeOfDay(const Duration(hours: 23, minutes: 30));
      test('valid time', () {
        final date = DateTime(2022, 1, 1, 23, 30);
        expect(validator, isValid(date));
      });
      test('invalid time', () {
        final date = DateTime(2022, 1, 1, 23, 31);
        expect(validator, isInvalid(date));
      });
      // Loop for every hour.
      for (var h = 0; h < 24; h++) {
        final d = Duration(hours: h);
        final v = DateValidatorTimeOfDay(d);
        test('valid at $d', () {
          final date = DateTime(2022, 1, 1, h);
          expect(v, isValid(date));
        });
        test('invalid at $d + 1 minute', () {
          final date = DateTime(2022, 1, 1, h, 1);
          expect(v, isInvalid(date));
        });
      }
      // Loop for every 10th minute in a specific hour.
      for (var m = 0; m < 60; m += 10) {
        final d = Duration(hours: 12, minutes: m);
        final v = DateValidatorTimeOfDay(d);
        test('valid at $d', () {
          final date = DateTime(2022, 1, 1, 12, m);
          expect(v, isValid(date));
        });
        test('invalid at $d + 1 second', () {
          final date = DateTime(2022, 1, 1, 12, m, 1);
          expect(v, isInvalid(date));
        });
      }
      // Loop for every 15th second in a specific hour/minute.
      for (var s = 0; s < 60; s += 15) {
        final d = Duration(hours: 8, minutes: 20, seconds: s);
        final v = DateValidatorTimeOfDay(d);
        test('valid at $d', () {
          final date = DateTime(2022, 1, 1, 8, 20, s);
          expect(v, isValid(date));
        });
        test('invalid at $d + 1 millisecond', () {
          final date = DateTime(2022, 1, 1, 8, 20, s, 1);
          expect(v, isInvalid(date));
        });
      }
      // Loop for every 100th millisecond in a specific hour/minute/second.
      for (var ms = 0; ms < 1000; ms += 100) {
        final d =
            Duration(hours: 6, minutes: 42, seconds: 17, milliseconds: ms);
        final v = DateValidatorTimeOfDay(d);
        test('valid at $d', () {
          final date = DateTime(2022, 1, 1, 6, 42, 17, ms);
          expect(v, isValid(date));
        });
        test('invalid at $d + 1 microsecond', () {
          final date = DateTime(2022, 1, 1, 6, 42, 17, ms, 1);
          expect(v, isInvalid(date));
        });
      }
      // Loop for every 250th microsecond in a specific hour/minute/second/ms.
      for (var us = 0; us < 1000; us += 250) {
        final d = Duration(
          hours: 6,
          minutes: 42,
          seconds: 17,
          milliseconds: 123,
          microseconds: us,
        );
        final v = DateValidatorTimeOfDay(d);
        test('valid at $d', () {
          final date = DateTime(2022, 1, 1, 6, 42, 17, 123, us);
          expect(v, isValid(date));
        });
        test('invalid at $d + 1 microsecond', () {
          final date = DateTime(2022, 1, 1, 6, 42, 17, 123, us + 1);
          expect(v, isInvalid(date));
        });
      }
    });
  });
}
