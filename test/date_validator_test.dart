import 'package:due_date/due_date.dart';
import 'package:due_date/src/shared_private.dart';
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
  group('DateValidatorTimeOfDay:', () {
    group('constructor', () {
      group('unnamed', () {
        group('valid durations', () {
          for (var duration = Duration.zero;
              duration < const Duration(days: 1);
              duration += const Duration(minutes: 1)) {
            test('Valid duration $duration', () {
              expect(DateValidatorTimeOfDay(duration), isNotNull);
            });
          }
          test('last microsecond of day', () {
            expect(
              DateValidatorTimeOfDay(
                const Duration(days: 1) - const Duration(microseconds: 1),
              ),
              isNotNull,
            );
          });
        });
        test('assert when duration is negative', () {
          expect(
            () => DateValidatorTimeOfDay(
              -const Duration(microseconds: 1),
            ),
            throwsA(isA<AssertionError>()),
          );
        });
        group('assert when duration is 1 day or more', () {
          test('1 day', () {
            expect(
              () => DateValidatorTimeOfDay(
                const Duration(days: 1),
              ),
              throwsA(isA<AssertionError>()),
            );
          });
          test('2 days', () {
            expect(
              () => DateValidatorTimeOfDay(
                const Duration(days: 2),
              ),
              throwsA(isA<AssertionError>()),
            );
          });
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
    group('valid', () {
      final validator = DateValidatorTimeOfDay(
        const Duration(hours: 23, minutes: 30),
      );
      test('valid time', () {
        final date = DateTime(2022, 1, 1, 23, 30);
        expect(validator.valid(date), isTrue);
      });
      test('invalid time', () {
        final date = DateTime(2022, 1, 1, 23, 31);
        expect(validator.valid(date), isFalse);
      });
    });
  });
  group('DateValidatorWeekday:', () {
    group('Monday', () {
      const validator = DateValidatorWeekday(Weekday.monday);
      test('Monday is valid', () {
        expect(validator.valid(DateTime(2022, DateTime.september, 26)), isTrue);
      });

      test('Tuesday is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 27)),
          isFalse,
        );
      });
    });
  });
  group('DateValidatorDueDayMonth:', () {
    group('Day 2', () {
      const validator = DateValidatorDueDayMonth(2);
      test('Is valid', () {
        expect(validator.valid(DateTime(2022, DateTime.september, 2)), isTrue);
      });

      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 27)),
          isFalse,
        );
      });
    });
    group('Day 31 not exact', () {
      const validator = DateValidatorDueDayMonth(31);
      group('Is valid', () {
        test('February', () {
          expect(
            validator.valid(DateTime(2022, DateTime.february, 28)),
            isTrue,
          );
        });
        test('September', () {
          expect(
            validator.valid(DateTime(2022, DateTime.september, 30)),
            isTrue,
          );
        });
      });
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 27)),
          isFalse,
        );
      });
    });
    group('Day 31 exact', () {
      const validator = DateValidatorDueDayMonth(31, exact: true);
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.october, 31)),
          isTrue,
        );
      });
      group('Is not valid', () {
        test('February', () {
          expect(
            validator.valid(DateTime(2022, DateTime.february, 28)),
            isFalse,
          );
        });
        test('September', () {
          expect(
            validator.valid(DateTime(2022, DateTime.september, 27)),
            isFalse,
          );
        });
      });
    });
  });
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
  group('DateValidatorWeekdayCountInMonth', () {
    group('First Monday', () {
      const validator = DateValidatorWeekdayCountInMonth(
        week: Week.first,
        day: Weekday.monday,
      );
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 5)),
          isTrue,
        );
      });
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 6)),
          isFalse,
        );
      });
    });
    group('Second Tuesday', () {
      const validator = DateValidatorWeekdayCountInMonth(
        day: Weekday.tuesday,
        week: Week.second,
      );
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 13)),
          isTrue,
        );
      });
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 5)),
          isFalse,
        );
      });
    });
    group('Third Wednesday', () {
      const validator = DateValidatorWeekdayCountInMonth(
        day: Weekday.wednesday,
        week: Week.third,
      );
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 21)),
          isTrue,
        );
      });
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 12)),
          isFalse,
        );
      });
    });
    group('Fourth Thursday', () {
      const validator = DateValidatorWeekdayCountInMonth(
        day: Weekday.thursday,
        week: Week.fourth,
      );
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 22)),
          isTrue,
        );
      });
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 19)),
          isFalse,
        );
      });
    });
    group('Last Friday', () {
      const validator = DateValidatorWeekdayCountInMonth(
        day: Weekday.friday,
        week: Week.last,
      );
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 30)),
          isTrue,
        );
      });
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 19)),
          isFalse,
        );
      });
    });
  });
  group('DateValidatorDayInYear', () {
    group('Day 1', () {
      const validator = DateValidatorDayInYear(1);
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2022)),
          isTrue,
        );
      });
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.january, 2)),
          isFalse,
        );
      });
    });
    group('Day 365', () {
      const validator = DateValidatorDayInYear(365);
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.december, 31)),
          isTrue,
        );
      });
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.january, 2)),
          isFalse,
        );
      });
    });
    group('Day 366 not exact', () {
      const validator = DateValidatorDayInYear(366);
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.january, 31)),
          isFalse,
        );
      });
      group('Is valid', () {
        test('2022', () {
          expect(
            validator.valid(DateTime(2022, DateTime.december, 31)),
            isTrue,
          );
        });
        test('2020', () {
          expect(
            validator.valid(DateTime(2020, DateTime.december, 31)),
            isTrue,
          );
        });
      });
    });
    group('Day 366 exact', () {
      const validator = DateValidatorDayInYear(366, exact: true);
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2020, DateTime.december, 31)),
          isTrue,
        );
      });
      group('Is not valid', () {
        test('January 2nd', () {
          expect(
            validator.valid(DateTime(2022, DateTime.january, 2)),
            isFalse,
          );
        });
        test('December 31st 2022', () {
          expect(
            validator.valid(DateTime(2022, DateTime.december, 31)),
            isFalse,
          );
        });
      });
    });
  });
  group('DateValidatorIntersection', () {
    const validator = DateValidatorIntersection([
      DateValidatorDueDayMonth(24),
      DateValidatorWeekday(Weekday.saturday),
    ]);
    test('Valid', () {
      final date = DateTime(2022, DateTime.september, 24);
      expect(validator.valid(date), isTrue);
    });
    group('Invalid', () {
      test('Wrong day', () {
        final date = DateTime(2022, DateTime.september, 23);
        expect(validator.valid(date), isFalse);
      });
      test('Wrong weekday', () {
        final date = DateTime(2022, DateTime.august, 24);
        expect(validator.valid(date), isFalse);
      });
    });
  });
  group('DateValidatorUnion', () {
    const validator = DateValidatorUnion([
      DateValidatorDueDayMonth(24),
      DateValidatorWeekday(Weekday.saturday),
    ]);
    group('Valid', () {
      test('All valid', () {
        final date = DateTime(2022, DateTime.september, 24);
        expect(validator.valid(date), isTrue);
      });
      test('Wrong day', () {
        final date = DateTime(2022, DateTime.september, 17);
        expect(validator.valid(date), isTrue);
      });
      test('Wrong weekday', () {
        final date = DateTime(2022, DateTime.august, 24);
        expect(validator.valid(date), isTrue);
      });
    });
    test('Invalid', () {
      final date = DateTime(2022, DateTime.september, 23);
      expect(validator.valid(date), isFalse);
    });
  });
  group('DateValidatorDifference', () {
    const validator = DateValidatorDifference([
      DateValidatorDueDayMonth(24),
      DateValidatorWeekday(Weekday.saturday),
    ]);
    group('Valid', () {
      test('Wrong day', () {
        final date = DateTime(2022, DateTime.september, 17);
        expect(validator.valid(date), isTrue);
      });
      test('Wrong weekday', () {
        final date = DateTime(2022, DateTime.august, 24);
        expect(validator.valid(date), isTrue);
      });
    });
    group('Invalid', () {
      test('All valid', () {
        final date = DateTime(2022, DateTime.september, 24);
        expect(validator.valid(date), isFalse);
      });
      test('All Wrong', () {
        final date = DateTime(2022, DateTime.september, 23);
        expect(validator.valid(date), isFalse);
      });
    });
  });
}
