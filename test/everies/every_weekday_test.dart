// ignore_for_file: prefer_const_constructors

import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

import '../src/date_validator_match.dart';
import '../src/every_match.dart';

void main() {
  group('EveryWeekday:', () {
    // August 12, 2022 is Friday.
    final august12th2022 = DateTime(2022, DateTime.august, 12);
    // August 12, 2022 is Friday (UTC).
    final august12th2022Utc = DateTime.utc(2022, DateTime.august, 12);

    group('Constructor', () {
      group('Unnamed', () {
        test('Valid basic case', () {
          expect(EveryWeekday(Weekday.monday), isNotNull);
        });
        test('Creates with correct weekday', () {
          final everyMonday = EveryWeekday(Weekday.monday);
          expect(everyMonday.weekday, equals(Weekday.monday));
        });
      });

      group('from', () {
        test('Creates from DateTime weekday', () {
          // August 12, 2022 is Friday.
          final everyFriday = EveryWeekday.from(august12th2022);
          expect(everyFriday.weekday, equals(Weekday.friday));
        });
        test('Creates from DateTime weekday UTC', () {
          // August 12, 2022 is Friday (UTC).
          final everyFriday = EveryWeekday.from(august12th2022Utc);
          expect(everyFriday.weekday, equals(Weekday.friday));
        });
      });
    });

    group('Static constants', () {
      test('workdays is EveryDateValidatorUnion', () {
        expect(EveryWeekday.workdays, isA<EveryDateValidatorUnion>());
      });
      test('weekend is EveryDateValidatorUnion', () {
        expect(EveryWeekday.weekend, isA<EveryDateValidatorUnion>());
      });
    });

    group('Properties', () {
      test('weekday returns correct value', () {
        final everyTuesday = EveryWeekday(Weekday.tuesday);
        expect(everyTuesday.weekday, equals(Weekday.tuesday));
      });
    });

    group('Methods', () {
      group('compareTo', () {
        test('Same weekday returns 0', () {
          final every1 = EveryWeekday(Weekday.friday);
          final every2 = EveryWeekday(Weekday.friday);
          expect(every1.compareTo(every2), equals(0));
        });
        test('Lower weekday returns negative', () {
          final everyMonday = EveryWeekday(Weekday.monday);
          final everyWednesday = EveryWeekday(Weekday.wednesday);
          expect(everyMonday.compareTo(everyWednesday), isNegative);
        });
        test('Higher weekday returns positive', () {
          final everySunday = EveryWeekday(Weekday.sunday);
          final everyFriday = EveryWeekday(Weekday.friday);
          expect(everySunday.compareTo(everyFriday), isPositive);
        });
      });

      group('startDate', () {
        final everySaturday = EveryWeekday(Weekday.saturday);
        // August 13, 2022 is Saturday.
        final august13th = DateTime(2022, DateTime.august, 13);

        test('Returns same date when input is valid', () {
          expect(
            everySaturday,
            startsAtSameDate.withInput(august13th),
          );
        });
        test('Returns next valid date when input is invalid', () {
          expect(
            everySaturday,
            startsAt(august13th).withInput(august12th2022),
          );
        });
        test('Works with UTC dates', () {
          final everySaturdayUtc = EveryWeekday(Weekday.saturday);
          final august13thUtc = DateTime.utc(2022, DateTime.august, 13);
          expect(
            everySaturdayUtc,
            startsAt(august13thUtc).withInput(august12th2022Utc),
          );
        });
      });

      group('next', () {
        final everySaturday = EveryWeekday(Weekday.saturday);
        // August 13, 2022 is Saturday.
        final august13th = DateTime(2022, DateTime.august, 13);
        // August 20, 2022 is Saturday.
        final august20th = DateTime(2022, DateTime.august, 20);

        test('Always generates date after input', () {
          expect(everySaturday, nextIsAfter.withInput(august12th2022));
          expect(everySaturday, nextIsAfter.withInput(august13th));
        });
        test('Generates next Saturday from Friday', () {
          expect(
            everySaturday,
            hasNext(august13th).withInput(august12th2022),
          );
        });
        test('Generates next Saturday from Saturday', () {
          expect(
            everySaturday,
            hasNext(august20th).withInput(august13th),
          );
        });
        test('Works with UTC dates', () {
          final august13thUtc = DateTime.utc(2022, DateTime.august, 13);
          final august20thUtc = DateTime.utc(2022, DateTime.august, 20);
          expect(
            everySaturday,
            hasNext(august13thUtc).withInput(august12th2022Utc),
          );
          expect(
            everySaturday,
            hasNext(august20thUtc).withInput(august13thUtc),
          );
        });
      });

      group('previous', () {
        final everySaturday = EveryWeekday(Weekday.saturday);
        // August 13, 2022 is Saturday.
        final august13th = DateTime(2022, DateTime.august, 13);
        // August 6, 2022 is Saturday.
        final august6th = DateTime(2022, DateTime.august, 6);

        test('Always generates date before input', () {
          expect(everySaturday, previousIsBefore.withInput(august12th2022));
          expect(everySaturday, previousIsBefore.withInput(august13th));
        });
        test('Generates previous Saturday from Friday', () {
          expect(
            everySaturday,
            hasPrevious(august6th).withInput(august12th2022),
          );
        });
        test('Generates previous Saturday from Saturday', () {
          expect(
            everySaturday,
            hasPrevious(august6th).withInput(august13th),
          );
        });
        test('Works with UTC dates', () {
          final august13thUtc = DateTime.utc(2022, DateTime.august, 13);
          final august6thUtc = DateTime.utc(2022, DateTime.august, 6);
          expect(
            everySaturday,
            hasPrevious(august6thUtc).withInput(august12th2022Utc),
          );
          expect(
            everySaturday,
            hasPrevious(august6thUtc).withInput(august13thUtc),
          );
        });
      });

      group('addWeeks', () {
        final everySaturday = EveryWeekday(Weekday.saturday);
        // August 13, 2022 is Saturday.
        final august13th = DateTime(2022, DateTime.august, 13);

        test('Zero weeks returns same date', () {
          expect(
            everySaturday.addWeeks(august13th, 0),
            equals(august13th),
          );
        });
        test('Positive weeks adds correct number', () {
          // August 20, 2022 is Saturday (1 week later).
          final august20th = DateTime(2022, DateTime.august, 20);
          expect(
            everySaturday.addWeeks(august13th, 1),
            equals(august20th),
          );
        });
        test('Negative weeks subtracts correct number', () {
          // August 6, 2022 is Saturday (1 week earlier).
          final august6th = DateTime(2022, DateTime.august, 6);
          expect(
            everySaturday.addWeeks(august13th, -1),
            equals(august6th),
          );
        });
        test('Works with non-matching weekday input', () {
          // August 13, 2022 is Saturday (next from Friday August 12).
          final august20th = DateTime(2022, DateTime.august, 20);
          expect(
            everySaturday.addWeeks(DateTime(2022, DateTime.august, 13), 1),
            equals(august20th),
          );
        });
        test('Works with UTC dates', () {
          final august13thUtc = DateTime.utc(2022, DateTime.august, 13);
          final august20thUtc = DateTime.utc(2022, DateTime.august, 20);
          expect(
            everySaturday.addWeeks(august13thUtc, 1),
            equals(august20thUtc),
          );
        });
      });

      group('addMonths', () {
        final everyMonday = EveryWeekday(Weekday.monday);
        // August 8, 2022 is Monday (2nd Monday of August).
        final august8th = DateTime(2022, DateTime.august, 8);

        test('Delegates to EveryWeekdayCountInMonth.addMonths', () {
          final result = everyMonday.addMonths(august8th, 1);
          final expected =
              EveryWeekdayCountInMonth.from(august8th).addMonths(august8th, 1);
          expect(result, equals(expected));
        });
      });

      group('addYears', () {
        final everyMonday = EveryWeekday(Weekday.monday);
        // August 8, 2022 is Monday.
        final august8th = DateTime(2022, DateTime.august, 8);

        test('Delegates to addMonths with years * 12', () {
          final result = everyMonday.addYears(august8th, 1);
          final expected = everyMonday.addMonths(august8th, 12);
          expect(result, equals(expected));
        });
      });
    });

    group('Explicit datetime tests:', () {
      test('Monday to next Monday calculation', () {
        final everyMonday = EveryWeekday(Weekday.monday);
        // August 8, 2022 is Monday.
        final inputDate = DateTime(2022, 8, 8);
        // August 15, 2022 is Monday.
        final expected = DateTime(2022, 8, 15);

        expect(everyMonday, hasNext(expected).withInput(inputDate));
      });

      test('Friday to next Monday calculation', () {
        final everyMonday = EveryWeekday(Weekday.monday);
        // August 12, 2022 is Friday.
        final inputDate = DateTime(2022, 8, 12);
        // August 15, 2022 is Monday.
        final expected = DateTime(2022, 8, 15);

        expect(everyMonday, hasNext(expected).withInput(inputDate));
      });

      test('Edge case: last day of month to next month', () {
        final everyTuesday = EveryWeekday(Weekday.tuesday);
        // August 31, 2022 is Wednesday.
        final inputDate = DateTime(2022, 8, 31);
        // September 6, 2022 is Tuesday.
        final expected = DateTime(2022, 9, 6);

        expect(everyTuesday, hasNext(expected).withInput(inputDate));
      });

      test('Edge case: year boundary', () {
        final everyWednesday = EveryWeekday(Weekday.wednesday);
        // December 31, 2022 is Saturday.
        final inputDate = DateTime(2022, 12, 31);
        // January 4, 2023 is Wednesday.
        final expected = DateTime(2023, 1, 4);

        expect(everyWednesday, hasNext(expected).withInput(inputDate));
      });

      test('Previous calculation across month boundary', () {
        final everySunday = EveryWeekday(Weekday.sunday);
        // September 1, 2022 is Thursday.
        final inputDate = DateTime(2022, 9);
        // August 28, 2022 is Sunday.
        final expected = DateTime(2022, 8, 28);

        expect(everySunday, hasPrevious(expected).withInput(inputDate));
      });
    });

    group('Time component preservation:', () {
      test('Maintains time components in local DateTime', () {
        final everyMonday = EveryWeekday(Weekday.monday);
        final inputWithTime = DateTime(2022, 8, 12, 14, 30, 45, 123, 456);
        final result = everyMonday.next(inputWithTime);

        // Should preserve time components.
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
        expect(result.isUtc, isFalse);
      });

      test('Maintains time components in UTC DateTime', () {
        final everyMonday = EveryWeekday(Weekday.monday);
        final inputWithTime = DateTime.utc(2022, 8, 12, 14, 30, 45, 123, 456);
        final result = everyMonday.next(inputWithTime);

        // Should preserve time components and UTC flag.
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
        expect(result.isUtc, isTrue);
      });

      test('Previous maintains time components in local DateTime', () {
        final everySaturday = EveryWeekday(Weekday.saturday);
        final inputWithTime = DateTime(2022, 8, 15, 9, 15, 30, 500, 250);
        final result = everySaturday.previous(inputWithTime);

        // Should preserve time components.
        expect(result.hour, equals(9));
        expect(result.minute, equals(15));
        expect(result.second, equals(30));
        expect(result.millisecond, equals(500));
        expect(result.microsecond, equals(250));
        expect(result.isUtc, isFalse);
      });

      test('Previous maintains time components in UTC DateTime', () {
        final everySaturday = EveryWeekday(Weekday.saturday);
        final inputWithTime = DateTime.utc(2022, 8, 15, 9, 15, 30, 500, 250);
        final result = everySaturday.previous(inputWithTime);

        // Should preserve time components and UTC flag.
        expect(result.hour, equals(9));
        expect(result.minute, equals(15));
        expect(result.second, equals(30));
        expect(result.millisecond, equals(500));
        expect(result.microsecond, equals(250));
        expect(result.isUtc, isTrue);
      });

      test('Normal generation with date-only input (local)', () {
        final everyTuesday = EveryWeekday(Weekday.tuesday);
        final inputDate = DateTime(2022, 8, 15);
        final expected = DateTime(2022, 8, 16);

        expect(everyTuesday, hasNext(expected).withInput(inputDate));
      });

      test('Normal generation with date-only input (UTC)', () {
        final everyTuesday = EveryWeekday(Weekday.tuesday);
        final inputDate = DateTime.utc(2022, 8, 15);
        final expected = DateTime.utc(2022, 8, 16);

        expect(everyTuesday, hasNext(expected).withInput(inputDate));
      });

      test('Next week', () {
        final everyFriday = EveryWeekday(Weekday.friday);
        // Saturday.
        final inputWithTime = DateTime(2022, 8, 13, 10, 25, 40, 333, 777);
        final result = everyFriday.next(inputWithTime);

        // Should preserve time components when going to next week's Friday.
        expect(result.hour, equals(10));
        expect(result.minute, equals(25));
        expect(result.second, equals(40));
        expect(result.millisecond, equals(333));
        expect(result.microsecond, equals(777));
        expect(result.isUtc, isFalse);
        expect(result.weekday, equals(Weekday.friday.dateTimeValue));
      });

      test('Previous on the same week', () {
        final everyMonday = EveryWeekday(Weekday.monday);
        // Wednesday.
        final inputWithTime = DateTime(2022, 8, 10, 16, 45, 20, 888, 999);
        final result = everyMonday.previous(inputWithTime);

        // Should preserve time components when going to same week's Monday.
        expect(result.hour, equals(16));
        expect(result.minute, equals(45));
        expect(result.second, equals(20));
        expect(result.millisecond, equals(888));
        expect(result.microsecond, equals(999));
        expect(result.isUtc, isFalse);
        expect(result.weekday, equals(Weekday.monday.dateTimeValue));
      });
    });

    group('Edge Cases', () {
      group('All weekdays comprehensive validation', () {
        test('Handles all weekdays correctly', () {
          for (final weekday in Weekday.values) {
            final everyWeekday = EveryWeekday(weekday);
            for (var i = 1; i <= 7; i++) {
              // July 1, 2024 is Monday.
              final date = DateTime(2024, 7, i);
              final isValidWeekday = date.weekday == weekday.dateTimeValue;
              if (isValidWeekday) {
                expect(everyWeekday, startsAtSameDate.withInput(date));
              } else {
                expect(everyWeekday, nextIsAfter.withInput(date));
                expect(everyWeekday, previousIsBefore.withInput(date));
              }
            }
          }
        });
      });

      group('Week boundaries', () {
        final everySunday = EveryWeekday(Weekday.sunday);

        test('Handles week start correctly', () {
          // August 14, 2022 is Sunday.
          final august14th = DateTime(2022, DateTime.august, 14);
          expect(
            everySunday,
            startsAtSameDate.withInput(august14th),
          );
        });
      });

      group('Month boundaries', () {
        final everyFirstOfMonth = EveryWeekday(Weekday.monday);
        // August 1, 2022 is Monday.
        final august1st = DateTime(2022, DateTime.august);

        test('Handles month start correctly', () {
          expect(
            everyFirstOfMonth,
            startsAtSameDate.withInput(august1st),
          );
        });
      });

      group('Year boundaries', () {
        final everyNewYear = EveryWeekday(Weekday.saturday);
        // January 1, 2022 is Saturday.
        final january1st = DateTime(2022);

        test('Handles year start correctly', () {
          expect(
            everyNewYear,
            startsAtSameDate.withInput(january1st),
          );
        });
      });
    });

    group('Validation behavior', () {
      group('All weekdays validation:', () {
        for (final weekday in Weekday.values) {
          group('Every ${weekday.name}', () {
            final everyWeekday = EveryWeekday(weekday);
            for (var i = 1; i <= 7; i++) {
              // July 1, 2024 is Monday.
              final date = DateTime(2024, 7, i);
              final isValidWeekday = date.weekday == weekday.dateTimeValue;
              test(
                'Day $i (${Weekday.fromDateTimeValue(date.weekday).name}) is '
                '${isValidWeekday ? '' : 'not '}valid',
                () {
                  if (isValidWeekday) {
                    expect(everyWeekday, isValid(date));
                  } else {
                    expect(everyWeekday, isInvalid(date));
                  }
                },
              );
            }
          });
        }
      });
    });

    group('All weekdays', () {
      for (final weekday in Weekday.values) {
        group('Every ${weekday.name}', () {
          final everyWeekday = EveryWeekday(weekday);

          test('Creates correctly', () {
            expect(everyWeekday.weekday, equals(weekday));
          });
          test('Next is always after input', () {
            expect(everyWeekday, nextIsAfter.withInput(august12th2022));
          });
          test('Previous is always before input', () {
            expect(everyWeekday, previousIsBefore.withInput(august12th2022));
          });
        });
      }
    });

    group('toString', () {
      test('Returns meaningful string representation', () {
        final everyMonday = EveryWeekday(Weekday.monday);
        expect(everyMonday.toString(), equals('EveryWeekday<Weekday.monday>'));
      });
    });

    group('Equality', () {
      final everyMonday1 = EveryWeekday(Weekday.monday);
      final everyMonday2 = EveryWeekday(Weekday.monday);
      final everyTuesday = EveryWeekday(Weekday.tuesday);

      test('Same instance', () {
        expect(everyMonday1, equals(everyMonday1));
      });
      test('Same weekday', () {
        expect(everyMonday1, equals(everyMonday2));
      });
      test('Different weekday', () {
        expect(everyMonday1, isNot(equals(everyTuesday)));
      });
      test('Hash codes are equal for same weekday', () {
        expect(everyMonday1.hashCode, equals(everyMonday2.hashCode));
      });
      test('Hash codes are different for different weekdays', () {
        expect(everyMonday1.hashCode, isNot(equals(everyTuesday.hashCode)));
      });
    });
  });
}
