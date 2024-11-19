import 'package:due_date/due_date.dart';
import 'package:due_date/src/helpers/helpers.dart';
import 'package:equatable/equatable.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

class MonthInYear with EquatableMixin {
  const MonthInYear(
    this.year,
    this.month,
  );

  final int month;
  final int year;

  DateTime date([int day = 1]) => DateTime(year, month, day);

  @override
  String toString() {
    return 'MonthInYear{year: $year, month: $month}';
  }

  @override
  List<Object?> get props => [year, month];
}

void main() {
  group('DateValidatorDueWorkdayMonth:', () {
    group('Constructor', () {
      group('Unnamed', () {
        test('Due workday 1', () {
          expect(const DateValidatorDueWorkdayMonth(1), isNotNull);
        });
        test('Exact false', () {
          expect(const DateValidatorDueWorkdayMonth(23).exact, isFalse);
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
      final set = list.toSet();
      for (final month in set) {
        group('${month.year} ${month.month}', () {
          for (final exact in {true, false}) {
            for (var i = 1; i <= 23; i++) {
              final validator = DateValidatorDueWorkdayMonth(i, exact: exact);
              final lastDayOfMonth =
                  DateTime(month.year, month.month).lastDayOfMonth;
              DateTime lastWorkdayInMonth;
              if (WorkdayHelper.every.valid(lastDayOfMonth)) {
                lastWorkdayInMonth = lastDayOfMonth;
              } else {
                lastWorkdayInMonth =
                    WorkdayHelper.every.previous(lastDayOfMonth);
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
                      expect(validator.valid(date), isTrue);
                    });
                  } else if (!WorkdayHelper.every.valid(date)) {
                    test('Day $day is not valid', () {
                      expect(validator.valid(date), isFalse);
                    });
                  } else if (!validator.exact &&
                      !date.isBefore(lastWorkdayInMonth) &&
                      maxWorkdayInMonth < validator.dueWorkday) {
                    test('Day $day is valid', () {
                      expect(validator.valid(month.date(day)), isTrue);
                    });
                  } else {
                    test('Day $day is not valid', () {
                      expect(validator.valid(date), isFalse);
                    });
                  }
                }
              });
            }
          }
        });
      }
    });
  });
}
