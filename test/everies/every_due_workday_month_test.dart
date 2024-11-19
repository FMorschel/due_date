import 'package:due_date/due_date.dart';
import 'package:due_date/src/helpers/helpers.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

import '../date_validators/date_validator_due_workday_month_test.dart';

void main() {
  group('EveryDueWorkdayMonth:', () {
    group('constructors', () {
      group('unnamed', () {
        group('Creates the object', () {
          for (var i = 1; i < 23; i++) {
            test('For $i', () {
              expect(EveryDueWorkdayMonth(i), isNotNull);
            });
          }
        });
        group('asserts limits', () {
          test('Less than 1', () {
            expect(
              () => EveryDueWorkdayMonth(0),
              throwsA(isA<AssertionError>()),
            );
          });
          test('More than 23', () {
            expect(
              () => EveryDueWorkdayMonth(24),
              throwsA(isA<AssertionError>()),
            );
          });
        });
      });
      group('from', () {
        group('Direction none', () {
          test('Valid day', () {
            expect(
              EveryDueWorkdayMonth.from(
                DateTime(2024, 1, 31),
                direction: WorkdayDirection.none,
              ),
              isNotNull,
            );
          });
          test('Throws an error for `WorkdayDirection.none` and weekend', () {
            expect(
              () => EveryDueWorkdayMonth.from(
                DateTime(2024, 6, 2),
                direction: WorkdayDirection.none,
              ),
              throwsA(isA<ArgumentError>()),
            );
          });
          test('Direction forward', () {
            expect(EveryDueWorkdayMonth.from(DateTime(2024, 6, 2)), isNotNull);
          });
          test('Direction backward', () {
            expect(
              EveryDueWorkdayMonth.from(
                DateTime(2024, 6),
                direction: WorkdayDirection.backward,
              ),
              isNotNull,
            );
          });
        });
      });
    });
    group('start of the month', () {
      const every = EveryDueWorkdayMonth(1);
      final date = DateTime(2024, DateTime.november);
      group('startDate', () {
        test('same day', () {
          expect(every.startDate(date), equals(date));
        });
        test('previous day', () {
          expect(every.startDate(date.subtractDays(1)), equals(date));
        });
      });
      group('next', () {
        final expected = DateTime(2024, DateTime.december, 2);
        test('same day', () {
          expect(every.next(date), equals(expected));
        });
        test('invalid day', () {
          expect(every.next(date.addDays(1)), equals(expected));
        });
      });
      group('previous', () {
        test('same day', () {
          final expected = DateTime(2024, DateTime.october);
          expect(every.previous(date), equals(expected));
        });
        test('invalid day', () {
          expect(every.previous(date.addDays(1)), equals(date));
        });
      });
    });
    group('middle of the month', () {
      const every = EveryDueWorkdayMonth(10);
      final date = DateTime(2024, DateTime.november, 14);
      group('startDate', () {
        test('same day', () {
          expect(every.startDate(date), equals(date));
        });
        test('previous day', () {
          expect(every.startDate(date.subtractDays(1)), equals(date));
        });
      });
      group('next', () {
        final expected = DateTime(2024, DateTime.december, 13);
        test('same day', () {
          expect(every.next(date), equals(expected));
        });
        test('invalid day', () {
          expect(every.next(date.addDays(1)), equals(expected));
        });
      });
      group('previous', () {
        test('same day', () {
          final expected = DateTime(2024, DateTime.october, 14);
          expect(every.previous(date), equals(expected));
        });
        test('invalid day', () {
          expect(every.previous(date.addDays(1)), equals(date));
        });
      });
    });
    group('last workday in month', () {
      const list = [
        MonthInYear(2024, DateTime.january), // 23 workdays.
        MonthInYear(2024, DateTime.december), // 22 workdays.
        MonthInYear(2022, DateTime.december), // 22 workdays, ends on a weekend.
        MonthInYear(2025, DateTime.march), // 21 workdays.
        MonthInYear(2024, DateTime.march), // 21 workdays, ends on a weekend.
        MonthInYear(2024, DateTime.february), // 20 workdays.
        MonthInYear(2026, DateTime.february), // 20 workdays, ends on a weekend.
      ];
      final set = list.toSet();
      const everyLastWorkday = EveryDueWorkdayMonth(23);
      for (final month in set) {
        group('${month.year} ${month.month}', () {
          final lastDayOfMonth =
              DateTime(month.year, month.month).lastDayOfMonth;
          late final DateTime lastWorkdayInMonth;
          if (WorkdayHelper.every.valid(lastDayOfMonth)) {
            lastWorkdayInMonth = lastDayOfMonth;
          } else {
            lastWorkdayInMonth = WorkdayHelper.every.previous(lastDayOfMonth);
          }
          group('startDate', () {
            test('same day', () {
              expect(
                everyLastWorkday.startDate(lastWorkdayInMonth),
                equals(lastWorkdayInMonth),
              );
            });
            test('previous day', () {
              expect(
                everyLastWorkday.startDate(lastWorkdayInMonth.subtractDays(1)),
                equals(lastWorkdayInMonth),
              );
            });
          });
          group('next', () {
            final lastDayOfNextMonth =
                DateTime(month.year, month.month + 1).lastDayOfMonth;
            late final DateTime lastWorkdayInNextMonth;
            if (WorkdayHelper.every.valid(lastDayOfNextMonth)) {
              lastWorkdayInNextMonth = lastDayOfNextMonth;
            } else {
              lastWorkdayInNextMonth = WorkdayHelper.every.previous(
                lastDayOfNextMonth,
              );
            }
            test('same day', () {
              expect(
                everyLastWorkday.next(lastWorkdayInMonth),
                equals(lastWorkdayInNextMonth),
              );
            });
            test('invalid day', () {
              expect(
                everyLastWorkday.next(lastWorkdayInMonth.addDays(1)),
                equals(lastWorkdayInNextMonth),
              );
            });
          });
          group('previous', () {
            final lastDayOfPreviousMonth =
                DateTime(month.year, month.month - 1).lastDayOfMonth;
            late final DateTime lastWorkdayInPreviousMonth;
            if (WorkdayHelper.every.valid(lastDayOfPreviousMonth)) {
              lastWorkdayInPreviousMonth = lastDayOfPreviousMonth;
            } else {
              lastWorkdayInPreviousMonth = WorkdayHelper.every.previous(
                lastDayOfPreviousMonth,
              );
            }
            test('same day', () {
              expect(
                everyLastWorkday.previous(lastWorkdayInMonth),
                equals(lastWorkdayInPreviousMonth),
              );
            });
            test('invalid day', () {
              expect(
                everyLastWorkday.previous(lastWorkdayInMonth.subtractDays(1)),
                equals(lastWorkdayInPreviousMonth),
              );
            });
          });
        });
      }
    });
  });
}
