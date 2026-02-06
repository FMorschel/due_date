import 'package:due_date/src/date_validators/built_in/date_validator_day_in_year.dart';
import 'package:due_date/src/extensions/add_days.dart';
import 'package:test/test.dart';

import '../src/date_tostring.dart';
import '../src/date_validator_match.dart';

void main() {
  group('DateValidatorDayInYear', () {
    group('Constructor', () {
      group('Unnamed', () {
        test('Day 1', () {
          expect(const DateValidatorDayInYear(1), isNotNull);
        });
        test('Day 366', () {
          expect(const DateValidatorDayInYear(366), isNotNull);
        });
        test('Exact true by default', () {
          expect(const DateValidatorDayInYear(23).exact, isTrue);
        });
        test('Exact false when specified', () {
          expect(const DateValidatorDayInYear(23, exact: false).exact, isFalse);
        });
        test('DayInYear property is set correctly', () {
          expect(const DateValidatorDayInYear(150).dayInYear, equals(150));
        });
        group('asserts limits', () {
          test('Less than 1', () {
            expect(
              () => DateValidatorDayInYear(0),
              throwsA(isA<AssertionError>()),
            );
          });
          test('More than 366', () {
            expect(
              () => DateValidatorDayInYear(367),
              throwsA(isA<AssertionError>()),
            );
          });
        });
      });
      group('from', () {
        test('Valid basic case', () {
          // Day 75 of 2024 (leap year).
          final date = DateTime(2024, 3, 15);
          expect(DateValidatorDayInYear.from(date), isNotNull);
        });
        test('Creates validator with correct dayInYear', () {
          // Day 75 of 2024 (leap year).
          final date = DateTime(2024, 3, 15);
          final validator = DateValidatorDayInYear.from(date);
          expect(validator.dayInYear, equals(75));
        });
        test('Default exact is false', () {
          final date = DateTime(2024, 3, 15);
          final validator = DateValidatorDayInYear.from(date);
          expect(validator.exact, isFalse);
        });
        test('Exact parameter is respected', () {
          final date = DateTime(2024, 3, 15);
          final validator = DateValidatorDayInYear.from(date, exact: true);
          expect(validator.exact, isTrue);
        });
        test('Leap year day 366', () {
          // Day 366 of 2024 (leap year).
          final date = DateTime(2024, 12, 31);
          final validator = DateValidatorDayInYear.from(date);
          expect(validator.dayInYear, equals(366));
        });
        test('Non-leap year day 365', () {
          // Day 365 of 2023 (non-leap year).
          final date = DateTime(2023, 12, 31);
          final validator = DateValidatorDayInYear.from(date);
          expect(validator.dayInYear, equals(365));
        });
      });
    });
    for (final exact in [true, false]) {
      for (final year in [2020, 2021]) {
        for (var i = 1, day = DateToString(year, 1, i);
            (i <= 366) && (day.year == year);
            i++, day = DateToString(year, 1, i)) {
          group('Day $i in $year - $exact', () {
            final validator = DateValidatorDayInYear(i, exact: exact);
            test('Is valid $day for $i', () {
              expect(validator, isValid(day));
            });
            final other = DateToString.from(day.addDays(1));
            test('Is not valid $other for $i', () {
              expect(validator, isInvalid(other));
            });
          });
        }
        final d365 = DateToString(year, 1, 365);
        if (!exact && d365.addDays(1).year != year) {
          final validator = DateValidatorDayInYear(366, exact: exact);
          group('Day 365 in $year - $exact', () {
            test('Is valid $d365 for 366', () {
              expect(validator, isValid(d365));
            });
          });
        }
      }
    }
    group('Properties', () {
      test('dayInYear returns correct value', () {
        final validator = DateValidatorDayInYear(123);
        expect(validator.dayInYear, equals(123));
      });

      test('exact property with true', () {
        final validator = DateValidatorDayInYear(50, exact: true);
        expect(validator.exact, isTrue);
      });
    });

    group('Methods', () {
      group('compareTo', () {
        test('Same dayInYear returns 0', () {
          final validator1 = DateValidatorDayInYear(100);
          final validator2 = DateValidatorDayInYear(100);
          expect(validator1.compareTo(validator2), equals(0));

          final validator3 = DateValidatorDayInYear(100, exact: true);
          final validator4 = DateValidatorDayInYear(100, exact: true);
          expect(validator3.compareTo(validator4), equals(0));
        });

        test('Lower dayInYear returns negative', () {
          final validator1 = DateValidatorDayInYear(50);
          final validator2 = DateValidatorDayInYear(150);
          expect(validator1.compareTo(validator2), isNegative);
        });

        test('Higher dayInYear returns positive', () {
          final validator1 = DateValidatorDayInYear(250);
          final validator2 = DateValidatorDayInYear(100);
          expect(validator1.compareTo(validator2), isPositive);
        });

        test('Compare different exact values with same dayInYear', () {
          final validator1 = DateValidatorDayInYear(180, exact: false);
          final validator2 = DateValidatorDayInYear(180, exact: true);
          expect(validator1.compareTo(validator2), isNegative);
          expect(validator2.compareTo(validator1), isPositive);
        });

        test('Boundary values', () {
          final validator1 = DateValidatorDayInYear(1);
          final validator366 = DateValidatorDayInYear(366);
          expect(validator1.compareTo(validator366), isNegative);
          expect(validator366.compareTo(validator1), isPositive);
        });
      });
    });

    group('Edge Cases', () {
      group('Leap year handling', () {
        test('Day 366 in leap year', () {
          final validator = DateValidatorDayInYear(366);
          // Day 366 of 2024.
          final leapYearDate = DateTime(2024, 12, 31);
          expect(validator, isValid(leapYearDate));
        });

        test('Day 366 non-exact in non-leap year falls back to day 365', () {
          final validator = DateValidatorDayInYear(366, exact: false);
          // Day 365 of 2023.
          final nonLeapYearDate = DateTime(2023, 12, 31);
          expect(validator, isValid(nonLeapYearDate));
        });

        test('Day 366 exact in non-leap year is invalid', () {
          final validator = DateValidatorDayInYear(366, exact: true);
          // Day 365 of 2023.
          final nonLeapYearDate = DateTime(2023, 12, 31);
          expect(validator, isInvalid(nonLeapYearDate));
        });
      });

      group('Boundary conditions', () {
        test('First day of year', () {
          final validator = DateValidatorDayInYear(1);
          final firstDay = DateTime(2024);
          expect(validator, isValid(firstDay));
        });

        test('Last day of leap year', () {
          final validator = DateValidatorDayInYear(366);
          final lastDay = DateTime(2024, 12, 31);
          expect(validator, isValid(lastDay));
        });

        test('Last day of non-leap year', () {
          final validator = DateValidatorDayInYear(365);
          final lastDay = DateTime(2023, 12, 31);
          expect(validator, isValid(lastDay));
        });

        test('Day 365 exact in leap year when day 366 exists', () {
          final validator = DateValidatorDayInYear(365, exact: true);
          // Day 365 of 2024.
          final day365 = DateTime(2024, 12, 30);
          expect(validator, isValid(day365));
        });
      });
    });

    group('Equality', () {
      final validator1 = DateValidatorDayInYear(1, exact: false);
      final validator2 = DateValidatorDayInYear(1, exact: true);
      final validator3 = DateValidatorDayInYear(2, exact: false);
      final validator4 = DateValidatorDayInYear(1, exact: false);

      test('Same instance', () {
        expect(validator1, equals(validator1));
      });
      test('Same day, different exact', () {
        expect(validator1, isNot(equals(validator2)));
      });
      test('Different day, same exact', () {
        expect(validator1, isNot(equals(validator3)));
      });
      test('Same day, same exact', () {
        expect(validator1, equals(validator4));
      });
      test('Hash code consistency', () {
        final validator5 = DateValidatorDayInYear(1);
        expect(validator2.hashCode, equals(validator5.hashCode));
      });
    });
  });
}
