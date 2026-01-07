import 'package:due_date/src/date_validators/date_validator_due_day_month.dart';
import 'package:test/test.dart';

import '../src/date_validator_match.dart';

void main() {
  group('DateValidatorDueDayMonth:', () {
    group('Constructor', () {
      group('Unnamed', () {
        test('Day 1', () {
          expect(const DateValidatorDueDayMonth(1), isNotNull);
        });
        test('Day 31', () {
          expect(const DateValidatorDueDayMonth(31), isNotNull);
        });
        test('Exact true by default', () {
          expect(const DateValidatorDueDayMonth(15).exact, isTrue);
        });
        test('Exact false when specified', () {
          expect(
            const DateValidatorDueDayMonth(15, exact: false).exact,
            isFalse,
          );
        });
        test('DueDay property is set correctly', () {
          expect(const DateValidatorDueDayMonth(23).dueDay, equals(23));
        });
        group('asserts limits', () {
          test('Less than 1', () {
            expect(
              () => DateValidatorDueDayMonth(0),
              throwsA(isA<AssertionError>()),
            );
          });
          test('More than 31', () {
            expect(
              () => DateValidatorDueDayMonth(32),
              throwsA(isA<AssertionError>()),
            );
          });
        });
      });
      group('from', () {
        test('Valid basic case', () {
          final date = DateTime(2024, 5, 15);
          expect(DateValidatorDueDayMonth.from(date), isNotNull);
        });
        test('Creates validator with correct dueDay', () {
          final date = DateTime(2024, 7, 23);
          final validator = DateValidatorDueDayMonth.from(date);
          expect(validator.dueDay, equals(23));
        });
        test('Default exact is false', () {
          final date = DateTime(2024, 3, 15);
          final validator = DateValidatorDueDayMonth.from(date);
          expect(validator.exact, isFalse);
        });
        test('Exact parameter is respected', () {
          final date = DateTime(2024, 3, 15);
          final validator = DateValidatorDueDayMonth.from(date, exact: true);
          expect(validator.exact, isTrue);
        });
        test('Day 31', () {
          final date = DateTime(2024, 1, 31);
          final validator = DateValidatorDueDayMonth.from(date);
          expect(validator.dueDay, equals(31));
        });
        test('Day 1', () {
          final date = DateTime(2024, 6);
          final validator = DateValidatorDueDayMonth.from(date);
          expect(validator.dueDay, equals(1));
        });
      });
    });

    group('valid:', () {
      group('Exact mode', () {
        for (var day = 1; day <= 31; day++) {
          group('Day $day exact', () {
            final validator = DateValidatorDueDayMonth(day, exact: true);

            // Test valid case for months that have the day.
            test('Valid in January', () {
              final date = DateTime(2024, DateTime.january, day);
              expect(validator, isValid(date));
            });

            // Test invalid cases for months that don't have the day.
            if (day > 28) {
              test('Invalid in February (non-leap)', () {
                // February 2023 only has 28 days.
                final lastDayFeb = DateTime(2023, DateTime.february, 28);
                expect(
                  validator,
                  (day == 28 ? isValid : isInvalid)(lastDayFeb),
                );
              });
            }

            if (day > 29) {
              test('Invalid in February (leap year)', () {
                // February 2024 has 29 days (leap year).
                final lastDayFeb = DateTime(2024, DateTime.february, 29);
                expect(
                  validator,
                  (day == 29 ? isValid : isInvalid)(lastDayFeb),
                );
              });
            }

            if (day > 30) {
              test('Invalid in April', () {
                // April only has 30 days.
                final lastDayApril = DateTime(2024, DateTime.april, 30);
                expect(validator, isInvalid(lastDayApril));
              });
            }
          });
        }
      });

      group('Non-exact mode', () {
        for (var day = 1; day <= 31; day++) {
          group('Day $day non-exact', () {
            final validator = DateValidatorDueDayMonth(day, exact: false);

            // Test valid case for exact day.
            test('Valid on exact day', () {
              final date = DateTime(2024, DateTime.january, day);
              expect(validator, isValid(date));
            });

            // Test invalid for other day.
            test('Invalid on other day', () {
              final date = DateTime(2024, DateTime.january, day == 1 ? 2 : 1);
              expect(validator, isInvalid(date));
            });

            // Test fallback to last day of month when day doesn't exist.
            if (day > 28) {
              test('Valid on last day of February (non-leap)', () {
                final lastDayFeb = DateTime(2023, DateTime.february, 28);
                expect(validator, isValid(lastDayFeb));
              });

              test('Invalid on non-last day of February', () {
                final date = DateTime(2023, DateTime.february, 27);
                expect(validator, isInvalid(date));
              });
            }

            if (day > 29) {
              test('Valid on last day of February (leap year)', () {
                final lastDayFeb = DateTime(2024, DateTime.february, 29);
                expect(validator, isValid(lastDayFeb));
              });
            }

            if (day > 30) {
              test('Valid on last day of April', () {
                final lastDayApril = DateTime(2024, DateTime.april, 30);
                expect(validator, isValid(lastDayApril));
              });

              test('Invalid on non-last day of April', () {
                final date = DateTime(2024, DateTime.april, 29);
                expect(validator, isInvalid(date));
              });
            }
          });
        }
      });
    });

    group('Properties', () {
      test('dueDay returns correct value', () {
        final validator = DateValidatorDueDayMonth(15);
        expect(validator.dueDay, equals(15));
      });

      test('exact property with true', () {
        final validator = DateValidatorDueDayMonth(10, exact: true);
        expect(validator.exact, isTrue);
      });

      test('inexact property when exact is false', () {
        final validator = DateValidatorDueDayMonth(31, exact: false);
        expect(validator.inexact, isTrue);
      });

      test('inexact property when exact is true', () {
        final validator = DateValidatorDueDayMonth(31, exact: true);
        expect(validator.inexact, isFalse);
      });
    });

    group('Methods', () {
      group('compareTo', () {
        test('Same dueDay and exact returns 0', () {
          final validator1 = DateValidatorDueDayMonth(15);
          final validator2 = DateValidatorDueDayMonth(15);
          expect(validator1.compareTo(validator2), equals(0));
          final validator3 = DateValidatorDueDayMonth(15, exact: true);
          final validator4 = DateValidatorDueDayMonth(15, exact: true);
          expect(validator3.compareTo(validator4), equals(0));
        });

        test('Exact true comes after exact false', () {
          final validator1 = DateValidatorDueDayMonth(15, exact: true);
          final validator2 = DateValidatorDueDayMonth(15, exact: false);
          expect(validator1.compareTo(validator2), isPositive);
          expect(validator2.compareTo(validator1), isNegative);
        });

        test('Lower dueDay returns negative', () {
          final validator1 = DateValidatorDueDayMonth(10);
          final validator2 = DateValidatorDueDayMonth(20);
          expect(validator1.compareTo(validator2), isNegative);
        });

        test('Higher dueDay returns positive', () {
          final validator1 = DateValidatorDueDayMonth(25);
          final validator2 = DateValidatorDueDayMonth(15);
          expect(validator1.compareTo(validator2), isPositive);
        });
      });
    });

    group('Edge Cases', () {
      group('Leap year handling', () {
        test('Day 29 in leap year February', () {
          final validator = DateValidatorDueDayMonth(29);
          final leapYearDate = DateTime(2024, DateTime.february, 29);
          expect(validator, isValid(leapYearDate));
        });

        test('Day 29 non-exact in non-leap year February falls back to 28', () {
          final validator = DateValidatorDueDayMonth(29, exact: false);
          final nonLeapYearDate = DateTime(2023, DateTime.february, 28);
          expect(validator, isValid(nonLeapYearDate));
        });

        test('Day 29 exact in non-leap year February is invalid', () {
          final validator = DateValidatorDueDayMonth(29, exact: true);
          final nonLeapYearDate = DateTime(2023, DateTime.february, 28);
          expect(validator, isInvalid(nonLeapYearDate));
        });
      });

      group('Month boundaries', () {
        const monthsWith30Days = [
          DateTime.april,
          DateTime.june,
          DateTime.september,
          DateTime.november,
        ];

        for (final month in monthsWith30Days) {
          test('Day 31 non-exact in $month falls back to day 30', () {
            final validator = DateValidatorDueDayMonth(31, exact: false);
            final date = DateTime(2024, month, 30);
            expect(validator, isValid(date));
          });

          test('Day 31 exact in $month is invalid', () {
            final validator = DateValidatorDueDayMonth(31, exact: true);
            final date = DateTime(2024, month, 30);
            expect(validator, isInvalid(date));
          });
        }
      });
    });

    group('Equality', () {
      final validator1 = DateValidatorDueDayMonth(15, exact: false);
      final validator2 = DateValidatorDueDayMonth(15, exact: true);
      final validator3 = DateValidatorDueDayMonth(20, exact: false);
      final validator4 = DateValidatorDueDayMonth(15, exact: false);

      test('Same instance', () {
        expect(validator1, equals(validator1));
      });
      test('Same dueDay, different exact', () {
        expect(validator1, isNot(equals(validator2)));
      });
      test('Different dueDay, same exact', () {
        expect(validator1, isNot(equals(validator3)));
      });
      test('Same dueDay, same exact', () {
        expect(validator1, equals(validator4));
      });
      test('Hash code consistency', () {
        final validator5 = DateValidatorDueDayMonth(15);
        expect(validator2.hashCode, equals(validator5.hashCode));
      });
    });
  });
}
