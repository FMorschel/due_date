import 'package:due_date/src/date_validators/built_in/date_validator_due_workday_month.dart';
import 'package:due_date/src/everies/workday_direction.dart';
import 'package:due_date/src/helpers/workday_helper.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

import '../src/date_validator_match.dart';
import '../src/month_in_year.dart';

void main() {
  group('DateValidatorDueWorkdayMonth:', () {
    group('Constructor', () {
      group('Unnamed', () {
        test('Due workday 1', () {
          expect(const DateValidatorDueWorkdayMonth(1), isNotNull);
        });
        test('Due workday 23', () {
          expect(const DateValidatorDueWorkdayMonth(23), isNotNull);
        });
        test('Exact true by default', () {
          expect(const DateValidatorDueWorkdayMonth(15).exact, isTrue);
        });
        test('Exact false when specified', () {
          expect(
            const DateValidatorDueWorkdayMonth(15, exact: false).exact,
            isFalse,
          );
        });
        test('DueWorkday property is set correctly', () {
          expect(const DateValidatorDueWorkdayMonth(12).dueWorkday, equals(12));
        });
        group('asserts limits', () {
          test('Less than 1', () {
            expect(
              () => DateValidatorDueWorkdayMonth(0),
              throwsA(isA<AssertionError>()),
            );
          });
          test('More than 23', () {
            expect(
              () => DateValidatorDueWorkdayMonth(24),
              throwsA(isA<AssertionError>()),
            );
          });
        });
      });
      group('from', () {
        test('Valid day', () {
          expect(
            DateValidatorDueWorkdayMonth.from(
              DateTime(2024, 1, 31),
            ),
            isNotNull,
          );
        });
        test('Throws an error for `WorkdayDirection.none` and weekend', () {
          expect(
            () => DateValidatorDueWorkdayMonth.from(
              DateTime(2024, 6, 2),
              direction: WorkdayDirection.none,
            ),
            throwsA(isA<ArgumentError>()),
          );
        });
        test('Direction forward', () {
          expect(
            DateValidatorDueWorkdayMonth.from(DateTime(2024, 6, 2)),
            isNotNull,
          );
        });
        test('Direction backward', () {
          expect(
            DateValidatorDueWorkdayMonth.from(
              DateTime(2024, 6),
              direction: WorkdayDirection.backward,
            ),
            isNotNull,
          );
        });
      });
    });
    group('valid:', () {
      const list = [
        MonthInYear(2024, DateTime.january), // 23 workdays.
        MonthInYear(2024, DateTime.december), // 22 workdays.
        MonthInYear(2022, DateTime.december), // 22 workdays, ends on a weekend.
        MonthInYear(2025, DateTime.march), // 21 workdays.
        MonthInYear(2024, DateTime.march), // 21 workdays, ends on a weekend.
        MonthInYear(2024, DateTime.february), // 20 workdays.
        MonthInYear(2026, DateTime.february), // 20 workdays, ends on a weekend.
      ];
      for (final month in list) {
        group('${month.year} ${month.month}', () {
          for (final exact in {true, false}) {
            for (var i = 1; i <= 23; i++) {
              final validator = DateValidatorDueWorkdayMonth(i, exact: exact);
              final lastDayOfMonth =
                  DateTime(month.year, month.month).lastDayOfMonth;
              DateTime lastWorkdayInMonth;
              if (WorkdayHelper.dateValidator.valid(lastDayOfMonth)) {
                lastWorkdayInMonth = lastDayOfMonth;
              } else {
                lastWorkdayInMonth = WorkdayHelper.every.previous(
                  lastDayOfMonth,
                );
              }
              final maxWorkdayInMonth = WorkdayHelper.getWorkdayNumberInMonth(
                lastWorkdayInMonth,
              );
              group('$validator', () {
                for (var day = 1; day <= lastDayOfMonth.day; day++) {
                  final date = month.date(day);
                  if (WorkdayHelper.getWorkdayNumberInMonth(date) ==
                      validator.dueWorkday) {
                    test('Day $day is valid', () {
                      expect(validator, isValid(date));
                    });
                  } else if (!WorkdayHelper.dateValidator.valid(date)) {
                    test('Day $day is not valid', () {
                      expect(validator, isInvalid(date));
                    });
                  } else if (!validator.exact &&
                      !date.isBefore(lastWorkdayInMonth) &&
                      maxWorkdayInMonth < validator.dueWorkday) {
                    test('Day $day is valid', () {
                      expect(validator, isValid(month.date(day)));
                    });
                  } else {
                    test('Day $day is not valid', () {
                      expect(validator, isInvalid(date));
                    });
                  }
                }
              });
            }
          }
        });
      }
    });
    group('Properties', () {
      test('dueWorkday returns correct value', () {
        final validator = DateValidatorDueWorkdayMonth(5);
        expect(validator.dueWorkday, equals(5));
      });

      test('exact property with false', () {
        final validator = DateValidatorDueWorkdayMonth(10, exact: false);
        expect(validator.exact, isFalse);
      });

      test('exact property with true', () {
        final validator = DateValidatorDueWorkdayMonth(10, exact: true);
        expect(validator.exact, isTrue);
      });

      test('inexact property when exact is false', () {
        final validator = DateValidatorDueWorkdayMonth(15, exact: false);
        expect(validator.inexact, isTrue);
      });

      test('inexact property when exact is true', () {
        final validator = DateValidatorDueWorkdayMonth(15, exact: true);
        expect(validator.inexact, isFalse);
      });
    });

    group('Methods', () {
      group('compareTo', () {
        test('Same dueWorkday returns 0', () {
          final validator1 = DateValidatorDueWorkdayMonth(10);
          final validator2 = DateValidatorDueWorkdayMonth(10);
          expect(validator1.compareTo(validator2), equals(0));
          final validator3 = DateValidatorDueWorkdayMonth(10, exact: true);
          final validator4 = DateValidatorDueWorkdayMonth(10, exact: true);
          expect(validator3.compareTo(validator4), equals(0));
        });

        test('Lower dueWorkday returns negative', () {
          final validator1 = DateValidatorDueWorkdayMonth(5);
          final validator2 = DateValidatorDueWorkdayMonth(15);
          expect(validator1.compareTo(validator2), isNegative);
        });

        test('Higher dueWorkday returns positive', () {
          final validator1 = DateValidatorDueWorkdayMonth(20);
          final validator2 = DateValidatorDueWorkdayMonth(10);
          expect(validator1.compareTo(validator2), isPositive);
        });

        test('Compare different exact values with same dueWorkday', () {
          final validator1 = DateValidatorDueWorkdayMonth(12);
          final validator2 = DateValidatorDueWorkdayMonth(12, exact: true);
          // According to the implementation, compareTo only compares
          // dueWorkday.
          expect(validator1.compareTo(validator2), equals(0));
        });

        test('Boundary values', () {
          final validator1 = DateValidatorDueWorkdayMonth(1);
          final validator23 = DateValidatorDueWorkdayMonth(23);
          expect(validator1.compareTo(validator23), isNegative);
          expect(validator23.compareTo(validator1), isPositive);
        });
      });
    });

    group('Edge Cases', () {
      group('Workday validation edge cases', () {
        test('First workday of month', () {
          final validator = DateValidatorDueWorkdayMonth(1);
          // Test with a month where first day is a workday.
          final firstWorkday = DateTime(2024);
          // January 1, 2024 is Monday.
          expect(validator, isValid(firstWorkday));
        });

        test('Last possible workday in month', () {
          final validator = DateValidatorDueWorkdayMonth(23);
          // Test with January 2024 which has 23 workdays.
          final lastWorkday = DateTime(2024, 1, 31);
          // Last workday of January 2024.
          expect(validator, isValid(lastWorkday));
        });

        test(
            'Non-exact mode falls back to last workday when dueWorkday exceeds '
            'month', () {
          final validator = DateValidatorDueWorkdayMonth(23, exact: false);
          // Test with February 2024 which has only 20 workdays.
          final lastWorkdayFeb = DateTime(2024, 2, 29);
          // Last workday of February 2024.
          expect(validator, isValid(lastWorkdayFeb));
        });

        test('Exact mode fails when dueWorkday exceeds month workdays', () {
          final validator = DateValidatorDueWorkdayMonth(23, exact: true);
          // Test with February 2024 which has only 20 workdays.
          final lastWorkdayFeb = DateTime(2024, 2, 29);
          // Last workday of February 2024.
          expect(validator, isInvalid(lastWorkdayFeb));
        });

        test('Weekend dates are always invalid', () {
          final validator = DateValidatorDueWorkdayMonth(1);
          // June 1, 2024 is Saturday.
          final saturday = DateTime(2024, 6);
          // June 2, 2024 is Sunday.
          final sunday = DateTime(2024, 6, 2);
          expect(validator, isInvalid(saturday));
          expect(validator, isInvalid(sunday));
        });
      });
    });

    group('Equality', () {
      final validator1 = DateValidatorDueWorkdayMonth(1, exact: false);
      final validator2 = DateValidatorDueWorkdayMonth(1, exact: true);
      final validator3 = DateValidatorDueWorkdayMonth(2, exact: false);
      final validator4 = DateValidatorDueWorkdayMonth(1, exact: false);

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
        final validator5 = DateValidatorDueWorkdayMonth(1);
        expect(validator2.hashCode, equals(validator5.hashCode));
      });
    });
  });
}
