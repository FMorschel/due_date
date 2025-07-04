// Always include this comment at the top for constructor tests.
// ignore_for_file: prefer_const_constructors

// Standard imports order:
import 'package:due_date/due_date.dart';
// Internal helpers (if needed).
import 'package:due_date/src/helpers/helpers.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

// Relative imports for test utilities.
import '../src/every_match.dart';
import '../src/month_in_year.dart';

void main() {
  group('EveryDueWorkdayMonth:', () {
    group('Constructor', () {
      group('Unnamed', () {
        test('Valid basic case', () {
          expect(EveryDueWorkdayMonth(1), isNotNull);
        });
        test('Creates with correct dueWorkday', () {
          expect(EveryDueWorkdayMonth(15).dueWorkday, equals(15));
        });
        test('Default exact is false', () {
          expect(EveryDueWorkdayMonth(10).exact, isFalse);
        });
        group('Creates for all valid workdays', () {
          for (var i = 1; i <= 23; i++) {
            test('For workday $i', () {
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
        group('WorkdayDirection.none', () {
          test('Valid workday creates successfully', () {
            // January 31, 2024 is Wednesday (23rd workday of January).
            expect(
              EveryDueWorkdayMonth.from(
                DateTime(2024, 1, 31),
                direction: WorkdayDirection.none,
              ),
              isNotNull,
            );
          });
          test('Weekend throws ArgumentError', () {
            // June 2, 2024 is Sunday.
            expect(
              () => EveryDueWorkdayMonth.from(
                DateTime(2024, 6, 2),
                direction: WorkdayDirection.none,
              ),
              throwsA(isA<ArgumentError>()),
            );
          });
        });
        group('WorkdayDirection.forward', () {
          test('Creates successfully from weekend', () {
            // June 2, 2024 is Sunday.
            expect(
              EveryDueWorkdayMonth.from(DateTime(2024, 6, 2)),
              isNotNull,
            );
          });
        });
        group('WorkdayDirection.backward', () {
          test('Creates successfully from weekend', () {
            // June 1, 2024 is Saturday.
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

    group('Methods', () {
      group('startDate', () {
        const every = EveryDueWorkdayMonth(10);

        test('Returns same date when input is valid', () {
          // November 14, 2024 is Thursday (10th workday of November).
          final validDate = DateTime(2024, DateTime.november, 14);
          expect(every, startsAtSameDate.withInput(validDate));
        });
        test('Returns next valid date when input is invalid', () {
          // November 13, 2024 is Wednesday (9th workday of November).
          final invalidDate = DateTime(2024, DateTime.november, 13);
          // November 14, 2024 is Thursday (10th workday of November).
          final expected = DateTime(2024, DateTime.november, 14);
          expect(every, startsAt(expected).withInput(invalidDate));
        });
        test('Works with UTC dates', () {
          // November 14, 2024 is Thursday (10th workday of November, UTC).
          final validDateUtc = DateTime.utc(2024, DateTime.november, 14);
          expect(every, startsAtSameDate.withInput(validDateUtc));
        });
      });

      group('next', () {
        const every = EveryDueWorkdayMonth(10);

        test('Always generates date after input', () {
          // November 14, 2024 is Thursday (10th workday of November).
          final validDate = DateTime(2024, DateTime.november, 14);
          expect(every, nextIsAfter.withInput(validDate));
        });
        test('Generates next occurrence from valid date', () {
          // November 14, 2024 is Thursday (10th workday of November).
          final validDate = DateTime(2024, DateTime.november, 14);
          // December 13, 2024 is Friday (10th workday of December).
          final expected = DateTime(2024, DateTime.december, 13);
          expect(every, hasNext(expected).withInput(validDate));
        });
        test('Generates next occurrence from invalid date', () {
          // November 15, 2024 is Friday (11th workday of November).
          final invalidDate = DateTime(2024, DateTime.november, 15);
          // December 13, 2024 is Friday (10th workday of December).
          final expected = DateTime(2024, DateTime.december, 13);
          expect(every, hasNext(expected).withInput(invalidDate));
        });
        test('Works with UTC dates', () {
          // November 14, 2024 is Thursday (10th workday of November, UTC).
          final validDateUtc = DateTime.utc(2024, DateTime.november, 14);
          // December 13, 2024 is Friday (10th workday of December, UTC).
          final expectedUtc = DateTime.utc(2024, DateTime.december, 13);
          expect(every, hasNext(expectedUtc).withInput(validDateUtc));
        });
      });

      group('previous', () {
        const every = EveryDueWorkdayMonth(10);

        test('Always generates date before input', () {
          // November 14, 2024 is Thursday (10th workday of November).
          final validDate = DateTime(2024, DateTime.november, 14);
          expect(every, previousIsBefore.withInput(validDate));
        });
        test('Generates previous occurrence from valid date', () {
          // November 14, 2024 is Thursday (10th workday of November).
          final validDate = DateTime(2024, DateTime.november, 14);
          // October 14, 2024 is Monday (10th workday of October).
          final expected = DateTime(2024, DateTime.october, 14);
          expect(every, hasPrevious(expected).withInput(validDate));
        });
        test('Generates previous occurrence from invalid date', () {
          // November 15, 2024 is Friday (11th workday of November).
          final invalidDate = DateTime(2024, DateTime.november, 15);
          // November 14, 2024 is Thursday (10th workday of November).
          final expected = DateTime(2024, DateTime.november, 14);
          expect(every, hasPrevious(expected).withInput(invalidDate));
        });
        test('Works with UTC dates', () {
          // November 14, 2024 is Thursday (10th workday of November, UTC).
          final validDateUtc = DateTime.utc(2024, DateTime.november, 14);
          // October 14, 2024 is Monday (10th workday of October, UTC).
          final expectedUtc = DateTime.utc(2024, DateTime.october, 14);
          expect(every, hasPrevious(expectedUtc).withInput(validDateUtc));
        });
      });

      group('addMonths', () {
        const every = EveryDueWorkdayMonth(5);

        test('Zero months returns same date when valid', () {
          // November 7, 2024 is Thursday (5th workday of November).
          final validDate = DateTime(2024, DateTime.november, 7);
          expect(every.addMonths(validDate, 0), equals(validDate));
        });
        test('Positive months adds correctly', () {
          // November 7, 2024 is Thursday (5th workday of November).
          final validDate = DateTime(2024, DateTime.november, 7);
          // January 7, 2025 is Thursday (5th workday of January).
          final expected = DateTime(2025, DateTime.january, 7);
          expect(every.addMonths(validDate, 2), equals(expected));
        });
        test('Negative months subtracts correctly', () {
          // November 7, 2024 is Thursday (5th workday of November).
          final validDate = DateTime(2024, DateTime.november, 7);
          // September 6, 2024 is Friday (5th workday of September).
          final expected = DateTime(2024, DateTime.september, 6);
          expect(every.addMonths(validDate, -2), equals(expected));
        });
        test('Works with UTC dates', () {
          // November 7, 2024 is Thursday (5th workday of November, UTC).
          final validDateUtc = DateTime.utc(2024, DateTime.november, 7);
          // December 6, 2024 is Friday (5th workday of December, UTC).
          final expectedUtc = DateTime.utc(2024, DateTime.december, 6);
          expect(every.addMonths(validDateUtc, 1), equals(expectedUtc));
        });
      });
    });

    // REQUIRED: Explicit datetime-to-datetime tests.
    group('Explicit datetime tests:', () {
      test('First workday of month calculation', () {
        const everyFirstWorkday = EveryDueWorkdayMonth(1);
        // November 5, 2024 is Tuesday (3rd workday of November).
        final inputDate = DateTime(2024, 11, 5);
        // December 2, 2024 is Monday (1st workday of December).
        final expected = DateTime(2024, 12, 2);

        expect(everyFirstWorkday, hasNext(expected).withInput(inputDate));
      });

      test('10th workday calculation', () {
        const everyTenthWorkday = EveryDueWorkdayMonth(10);
        // November 1, 2024 is Friday (1st workday of November).
        final inputDate = DateTime(2024, 11);
        // November 14, 2024 is Thursday (10th workday of November).
        final expected = DateTime(2024, 11, 14);

        expect(everyTenthWorkday, hasNext(expected).withInput(inputDate));
      });

      test('Last workday (23rd) calculation', () {
        const everyLastWorkday = EveryDueWorkdayMonth(23);
        // January 15, 2024 is Monday (11th workday of January).
        final inputDate = DateTime(2024, 1, 15);
        // January 31, 2024 is Wednesday (23rd workday of January).
        final expected = DateTime(2024, 1, 31);

        expect(everyLastWorkday, hasNext(expected).withInput(inputDate));
      });

      test('Edge case: month with fewer than 23 workdays', () {
        const everyLastWorkday = EveryDueWorkdayMonth(23);
        // February 15, 2024 is Thursday (11th workday of February).
        final inputDate = DateTime(2024, 2, 15);
        // February 29, 2024 is Thursday (21st workday, but clamped to
        // available).
        final expected = DateTime(2024, 2, 29);

        expect(everyLastWorkday, hasNext(expected).withInput(inputDate));
      });

      test('Edge case: year boundary crossing', () {
        const everyFifthWorkday = EveryDueWorkdayMonth(5);
        // December 20, 2024 is Friday (16th workday of December).
        final inputDate = DateTime(2024, 12, 20);
        // January 7, 2025 is Thursday (5th workday of January).
        final expected = DateTime(2025, 1, 7);

        expect(everyFifthWorkday, hasNext(expected).withInput(inputDate));
      });

      test('Previous calculation across months', () {
        const everyFifthWorkday = EveryDueWorkdayMonth(5);
        // November 1, 2024 is Friday (1st workday of November).
        final inputDate = DateTime(2024, 11);
        // October 7, 2024 is Monday (5th workday of October).
        final expected = DateTime(2024, 10, 7);

        expect(everyFifthWorkday, hasPrevious(expected).withInput(inputDate));
      });
    });

    // REQUIRED: Time component preservation tests.
    group('Time component preservation:', () {
      test('Maintains time components in local DateTime', () {
        const everyFifthWorkday = EveryDueWorkdayMonth(5);
        final inputWithTime = DateTime(2024, 11, 1, 14, 30, 45, 123, 456);
        final result = everyFifthWorkday.next(inputWithTime);

        // Should preserve time components.
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
        expect(result.isUtc, isFalse);
      });

      test('Maintains time components in UTC DateTime', () {
        const everyFifthWorkday = EveryDueWorkdayMonth(5);
        final inputWithTime = DateTime.utc(2024, 11, 1, 14, 30, 45, 123, 456);
        final result = everyFifthWorkday.next(inputWithTime);

        // Should preserve time components and UTC flag.
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
        expect(result.isUtc, isTrue);
      });

      test('Previous maintains time components in local DateTime', () {
        const everyTenthWorkday = EveryDueWorkdayMonth(10);
        final inputWithTime = DateTime(2024, 11, 15, 9, 15, 30, 500, 250);
        final result = everyTenthWorkday.previous(inputWithTime);

        // Should preserve time components.
        expect(result.hour, equals(9));
        expect(result.minute, equals(15));
        expect(result.second, equals(30));
        expect(result.millisecond, equals(500));
        expect(result.microsecond, equals(250));
        expect(result.isUtc, isFalse);
      });

      test('Previous maintains time components in UTC DateTime', () {
        const everyTenthWorkday = EveryDueWorkdayMonth(10);
        final inputWithTime = DateTime.utc(2024, 11, 15, 9, 15, 30, 500, 250);
        final result = everyTenthWorkday.previous(inputWithTime);

        // Should preserve time components and UTC flag.
        expect(result.hour, equals(9));
        expect(result.minute, equals(15));
        expect(result.second, equals(30));
        expect(result.millisecond, equals(500));
        expect(result.microsecond, equals(250));
        expect(result.isUtc, isTrue);
      });

      test('Normal generation with date-only input (local)', () {
        const everyFirstWorkday = EveryDueWorkdayMonth(1);
        final inputDate = DateTime(2024, 11, 15);
        final result = everyFirstWorkday.next(inputDate);

        // Should maintain date-only format.
        expect(result.hour, equals(0));
        expect(result.minute, equals(0));
        expect(result.second, equals(0));
        expect(result.millisecond, equals(0));
        expect(result.microsecond, equals(0));
        expect(result.isUtc, isFalse);
      });

      test('Normal generation with date-only input (UTC)', () {
        const everyFirstWorkday = EveryDueWorkdayMonth(1);
        final inputDate = DateTime.utc(2024, 11, 15);
        final result = everyFirstWorkday.next(inputDate);

        // Should maintain date-only format and UTC flag.
        expect(result.hour, equals(0));
        expect(result.minute, equals(0));
        expect(result.second, equals(0));
        expect(result.millisecond, equals(0));
        expect(result.microsecond, equals(0));
        expect(result.isUtc, isTrue);
      });
    });

    group('Edge Cases', () {
      group('First workday of month', () {
        const everyFirstWorkday = EveryDueWorkdayMonth(1);

        test('Handles month starting on Monday', () {
          // April 1, 2024 is Monday (1st workday of April).
          final firstWorkday = DateTime(2024, DateTime.april);
          expect(
            everyFirstWorkday,
            startsAt(firstWorkday).withInput(firstWorkday),
          );
        });
        test('Handles month starting on weekend', () {
          // June 1, 2024 is Saturday, so first workday is June 3 (Monday).
          final monthStart = DateTime(2024, DateTime.june);
          final expected = DateTime(2024, DateTime.june, 3);
          expect(
            everyFirstWorkday,
            startsAt(expected).withInput(monthStart),
          );
        });
      });

      group('Middle workday of month', () {
        const everyTenthWorkday = EveryDueWorkdayMonth(10);

        test('Handles different month lengths', () {
          // February 2024 (leap year) - 10th workday should be February 14.
          final inputDate = DateTime(2024, DateTime.february);
          final expected = DateTime(2024, DateTime.february, 14);
          expect(everyTenthWorkday, hasNext(expected).withInput(inputDate));
        });
      });

      group('Last workday in month (23rd workday)', () {
        // Use descriptive constants for test data.
        const testMonths = [
          // 23 workdays.
          MonthInYear(2024, DateTime.january),
          // 22 workdays.
          MonthInYear(2024, DateTime.december),
          // 22 workdays, ends on a weekend.
          MonthInYear(2022, DateTime.december),
          // 21 workdays.
          MonthInYear(2025, DateTime.march),
          // 21 workdays, ends on a weekend.
          MonthInYear(2024, DateTime.march),
          // 20 workdays.
          MonthInYear(2024, DateTime.february),
          // 20 workdays, ends on a weekend.
          MonthInYear(2026, DateTime.february),
        ];
        const everyLastWorkday = EveryDueWorkdayMonth(23);

        for (final month in testMonths) {
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
              test('Returns same date when on last workday', () {
                expect(
                  everyLastWorkday,
                  startsAt(lastWorkdayInMonth).withInput(lastWorkdayInMonth),
                );
              });
              test('Returns last workday when before it', () {
                expect(
                  everyLastWorkday,
                  startsAt(lastWorkdayInMonth).withInput(
                    lastWorkdayInMonth.subtractDays(1),
                  ),
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

              test('Generates next month last workday', () {
                expect(
                  everyLastWorkday,
                  hasNext(lastWorkdayInNextMonth).withInput(lastWorkdayInMonth),
                );
              });
              test('Handles invalid date correctly', () {
                expect(
                  everyLastWorkday,
                  hasNext(lastWorkdayInNextMonth)
                      .withInput(lastWorkdayInMonth.addDays(1)),
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

              test('Generates previous month last workday', () {
                expect(
                  everyLastWorkday,
                  hasPrevious(lastWorkdayInPreviousMonth)
                      .withInput(lastWorkdayInMonth),
                );
              });
              test('Handles invalid date correctly', () {
                expect(
                  everyLastWorkday,
                  hasPrevious(lastWorkdayInPreviousMonth)
                      .withInput(lastWorkdayInMonth.subtractDays(1)),
                );
              });
            });
          });
        }
      });

      group('Year boundary transitions', () {
        test('December to January transition', () {
          const everyFirstWorkday = EveryDueWorkdayMonth(1);
          // December 31, 2024 is Tuesday (22nd workday of December).
          final december31 = DateTime(2024, 12, 31);
          // January 1, 2025 is Thursday (1st workday of January).
          final expected = DateTime(2025);
          expect(
            everyFirstWorkday,
            hasNext(expected).withInput(december31),
          );
        });

        test('January to December transition (previous)', () {
          const everyLastWorkday = EveryDueWorkdayMonth(23);
          // January 1, 2025 is Wednesday (1st workday of January).
          final january1 = DateTime(2025);
          // December 31, 2024 is Tuesday (22nd workday of December).
          final expected = DateTime(2024, 12, 31);
          expect(
            everyLastWorkday,
            hasPrevious(expected).withInput(january1),
          );
        });
      });
    });

    group('toString', () {
      test('Returns meaningful string representation', () {
        const everyFifthWorkday = EveryDueWorkdayMonth(5);
        expect(everyFifthWorkday.toString(), equals('EveryDueWorkdayMonth<5>'));
      });

      test('Returns meaningful string representation for last workday', () {
        const everyLastWorkday = EveryDueWorkdayMonth(23);
        expect(everyLastWorkday.toString(), equals('EveryDueWorkdayMonth<23>'));
      });
    });

    group('Equality', () {
      final everyFifth1 = EveryDueWorkdayMonth(5);
      final everyFifth2 = EveryDueWorkdayMonth(5);
      final everyTenth = EveryDueWorkdayMonth(10);

      test('Same instance', () {
        expect(everyFifth1, equals(everyFifth1));
      });
      test('Different dueWorkday', () {
        expect(everyFifth1, isNot(equals(everyTenth)));
      });
      test('Same dueWorkday', () {
        expect(everyFifth1, equals(everyFifth2));
      });
      test('Hash code consistency', () {
        expect(everyFifth1.hashCode, equals(everyFifth2.hashCode));
      });
    });
  });
}
