// ignore_for_file: prefer_const_constructors

import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

import '../src/date_time_match.dart';
import '../src/date_validator_match.dart';
import '../src/every_match.dart';

void main() {
  group('EveryWeekdayCountInMonth:', () {
    // August 12, 2022 is Friday.
    final august12th2022 = DateTime(2022, DateTime.august, 12);
    // August 12, 2022 is Friday (UTC).
    final august12th2022Utc = DateTime.utc(2022, DateTime.august, 12);

    group('Constructor', () {
      group('Unnamed', () {
        test('Valid basic case', () {
          expect(
            EveryWeekdayCountInMonth(day: Weekday.monday, week: Week.first),
            isNotNull,
          );
        });
        test('Creates with correct weekday and week', () {
          final every = EveryWeekdayCountInMonth(
            day: Weekday.tuesday,
            week: Week.second,
          );
          expect(every.day, equals(Weekday.tuesday));
          expect(every.week, equals(Week.second));
        });
      });
      group('from', () {
        test('Creates correct instance from first Monday of month', () {
          // July 4, 2022 is Monday (first Monday of July).
          final july4th2022 = DateTime(2022, DateTime.july, 4);
          final result = EveryWeekdayCountInMonth.from(july4th2022);

          expect(result.day, equals(Weekday.monday));
          expect(result.week, equals(Week.first));
        });

        test('Creates correct instance from second Tuesday of month', () {
          // August 9, 2022 is Tuesday (second Tuesday of August).
          final august9th2022 = DateTime(2022, DateTime.august, 9);
          final result = EveryWeekdayCountInMonth.from(august9th2022);

          expect(result.day, equals(Weekday.tuesday));
          expect(result.week, equals(Week.second));
        });

        test('Creates correct instance from third Wednesday of month', () {
          // July 20, 2022 is Wednesday (third Wednesday of July).
          final july20th2022 = DateTime(2022, DateTime.july, 20);
          final result = EveryWeekdayCountInMonth.from(july20th2022);

          expect(result.day, equals(Weekday.wednesday));
          expect(result.week, equals(Week.third));
        });

        test('Creates correct instance from fourth Thursday of month', () {
          // July 28, 2022 is Thursday (fourth Thursday of July).
          final july28th2022 = DateTime(2022, DateTime.july, 28);
          final result = EveryWeekdayCountInMonth.from(july28th2022);

          expect(result.day, equals(Weekday.thursday));
          expect(result.week, equals(Week.fourth));
        });

        test('Creates correct instance from last Friday of month', () {
          // July 29, 2022 is Friday (last Friday of July).
          final july29th2022 = DateTime(2022, DateTime.july, 29);
          final result = EveryWeekdayCountInMonth.from(july29th2022);

          expect(result.day, equals(Weekday.friday));
          expect(result.week, equals(Week.last));
        });

        test('Creates correct instance from first Saturday of month', () {
          // October 1, 2022 is Saturday (first Saturday of October).
          final october1st2022 = DateTime(2022, DateTime.october);
          final result = EveryWeekdayCountInMonth.from(october1st2022);

          expect(result.day, equals(Weekday.saturday));
          expect(result.week, equals(Week.first));
        });

        test('Creates correct instance from last Sunday of month', () {
          // July 31, 2022 is Sunday (last Sunday of July).
          final july31st2022 = DateTime(2022, DateTime.july, 31);
          final result = EveryWeekdayCountInMonth.from(july31st2022);

          expect(result.day, equals(Weekday.sunday));
          expect(result.week, equals(Week.last));
        });

        test('Works correctly with UTC dates', () {
          // July 4, 2022 is Monday (first Monday of July) UTC.
          final july4th2022Utc = DateTime.utc(2022, DateTime.july, 4);
          final result = EveryWeekdayCountInMonth.from(july4th2022Utc);

          expect(result.day, equals(Weekday.monday));
          expect(result.week, equals(Week.first));
        });

        test('Works correctly with leap year dates', () {
          // February 29, 2020 is Saturday (last Saturday of February in leap
          // year).
          final feb29th2020 = DateTime(2020, DateTime.february, 29);
          final result = EveryWeekdayCountInMonth.from(feb29th2020);

          expect(result.day, equals(Weekday.saturday));
          expect(result.week, equals(Week.last));
        });

        test('Correctly identifies week considering first day of month', () {
          // Test edge case where month starts on different weekdays.
          // November 1, 2022 is Tuesday, so the first Monday is November 7
          // (second occurrence).
          final november7th2022 = DateTime(2022, DateTime.november, 7);
          final result = EveryWeekdayCountInMonth.from(november7th2022);

          expect(result.day, equals(Weekday.monday));
          expect(result.week, equals(Week.first));
        });

        test(
            'Correctly identifies first occurrence when month starts on target '
            'weekday', () {
          // June 1, 2022 is Wednesday, so June 1 is the first Wednesday.
          final june1st2022 = DateTime(2022, DateTime.june);
          final result = EveryWeekdayCountInMonth.from(june1st2022);

          expect(result.day, equals(Weekday.wednesday));
          expect(result.week, equals(Week.first));
        });

        test('Created instance can regenerate same date', () {
          // Test that the created instance can find the same date.
          final testDates = [
            DateTime(2022, DateTime.july, 4), // First Monday
            DateTime(2022, DateTime.august, 9), // Second Tuesday
            DateTime(2022, DateTime.july, 20), // Third Wednesday
            DateTime(2022, DateTime.july, 28), // Fourth Thursday
            DateTime(2022, DateTime.july, 29), // Last Friday
            DateTime(2022, DateTime.october), // First Saturday
            DateTime(2022, DateTime.july, 31), // Last Sunday
          ];

          for (final date in testDates) {
            final every = EveryWeekdayCountInMonth.from(date);
            expect(
              every.valid(date),
              isTrue,
              reason: 'Generated EveryWeekdayCountInMonth should validate the '
                  'source date: $date',
            );
          }
        });

        test('Preserves time components from input date', () {
          // July 4, 2022 14:30:45.123456 is Monday (first Monday of July).
          final dateWithTime =
              DateTime(2022, DateTime.july, 4, 14, 30, 45, 123, 456);
          final result = EveryWeekdayCountInMonth.from(dateWithTime);

          // The factory should only consider the date part, not time.
          expect(result.day, equals(Weekday.monday));
          expect(result.week, equals(Week.first));

          // Verify the instance works correctly with the time-containing date.
          expect(result.valid(dateWithTime), isTrue);
        });
      });
    });

    group('Properties', () {
      test('day returns correct value', () {
        final every = EveryWeekdayCountInMonth(
          day: Weekday.wednesday,
          week: Week.third,
        );
        expect(every.day, equals(Weekday.wednesday));
      });
      test('week returns correct value', () {
        final every = EveryWeekdayCountInMonth(
          day: Weekday.wednesday,
          week: Week.third,
        );
        expect(every.week, equals(Week.third));
      });
    });

    group('Methods', () {
      group('startDate', () {
        const every = EveryWeekdayCountInMonth(
          day: Weekday.saturday,
          week: Week.second,
        );
        // August 13, 2022 is Saturday (2nd Saturday of August).
        final august13th = DateTime(2022, DateTime.august, 13);

        test('Returns same date when input is valid', () {
          expect(every, startsAtSameDate.withInput(august13th));
        });
        test('Returns next valid date when input is invalid', () {
          final invalidDate = DateTime(2022, DateTime.august, 14);
          expect(
            every,
            startsAt(every.next(invalidDate)).withInput(invalidDate),
          );
        });
      });

      group('next', () {
        const every = EveryWeekdayCountInMonth(
          day: Weekday.saturday,
          week: Week.second,
        );
        // August 13, 2022 is Saturday (2nd Saturday of August).
        final august13th = DateTime(2022, DateTime.august, 13);
        // September 10, 2022 is Saturday (2nd Saturday of September).
        final september10th = DateTime(2022, DateTime.september, 10);

        test('Always generates date after input', () {
          expect(every, nextIsAfter.withInput(august13th));
        });
        test('Generates next occurrence from valid date', () {
          expect(every, hasNext(september10th).withInput(august13th));
        });
        test('Generates next occurrence from invalid date', () {
          expect(every, hasNext(august13th).withInput(august12th2022));
        });
      });

      group('previous', () {
        const every = EveryWeekdayCountInMonth(
          day: Weekday.saturday,
          week: Week.second,
        );
        // August 13, 2022 is Saturday (2nd Saturday of August).
        final august13th = DateTime(2022, DateTime.august, 13);
        // July 9, 2022 is Saturday (2nd Saturday of July).
        final july9th = DateTime(2022, DateTime.july, 9);

        test('Always generates date before input', () {
          expect(every, previousIsBefore.withInput(august13th));
        });
        test('Generates previous occurrence from valid date', () {
          expect(every, hasPrevious(july9th).withInput(august13th));
        });
        test('Generates previous occurrence from invalid date', () {
          expect(every, hasPrevious(july9th).withInput(august12th2022));
        });
      });

      group('addMonths', () {
        const every = EveryWeekdayCountInMonth(
          day: Weekday.friday,
          week: Week.last,
        );
        // July 29, 2022 is Friday (last Friday of July).
        final july29th = DateTime(2022, DateTime.july, 29);

        test('Adds positive months correctly', () {
          // September 30, 2022 is Friday (last Friday of September).
          final expected = DateTime(2022, DateTime.september, 30);
          expect(every.addMonths(july29th, 2), isSameDateTime(expected));
        });
        test('Adds negative months correctly', () {
          // May 27, 2022 is Friday (last Friday of May).
          final expected = DateTime(2022, DateTime.may, 27);
          expect(every.addMonths(july29th, -2), isSameDateTime(expected));
        });
        test('Adds zero months returns same date when valid', () {
          expect(every.addMonths(july29th, 0), isSameDateTime(july29th));
        });
      });

      group('addYears', () {
        const every = EveryWeekdayCountInMonth(
          day: Weekday.wednesday,
          week: Week.third,
        );
        // August 17, 2022 is Wednesday (3rd Wednesday of August).
        final august17th2022 = DateTime(2022, DateTime.august, 17);

        test('Adds positive years correctly', () {
          // August 16, 2023 is Wednesday (3rd Wednesday of August).
          final expected = DateTime(2023, DateTime.august, 16);
          expect(every.addYears(august17th2022, 1), isSameDateTime(expected));
        });
        test('Adds negative years correctly', () {
          // August 18, 2021 is Wednesday (3rd Wednesday of August).
          final expected = DateTime(2021, DateTime.august, 18);
          expect(every.addYears(august17th2022, -1), isSameDateTime(expected));
        });
        test('Adds zero years returns same date when valid', () {
          expect(
            every.addYears(august17th2022, 0),
            isSameDateTime(august17th2022),
          );
        });
      });

      group('compareTo', () {
        test('Same week and day returns 0', () {
          final every1 =
              EveryWeekdayCountInMonth(day: Weekday.monday, week: Week.first);
          final every2 =
              EveryWeekdayCountInMonth(day: Weekday.monday, week: Week.first);
          expect(every1.compareTo(every2), equals(0));
        });
        test('Different week returns difference', () {
          final every1 =
              EveryWeekdayCountInMonth(day: Weekday.monday, week: Week.first);
          final every2 =
              EveryWeekdayCountInMonth(day: Weekday.monday, week: Week.second);
          expect(every1.compareTo(every2), isNegative);
          expect(every2.compareTo(every1), isPositive);
        });
        test('Different day returns difference', () {
          final every1 =
              EveryWeekdayCountInMonth(day: Weekday.monday, week: Week.first);
          final every2 =
              EveryWeekdayCountInMonth(day: Weekday.tuesday, week: Week.first);
          expect(every1.compareTo(every2), isNegative);
          expect(every2.compareTo(every1), isPositive);
        });
      });
    });

    group('Explicit datetime tests:', () {
      test('First Monday of month calculation', () {
        const everyFirstMonday = EveryWeekdayCountInMonth(
          day: Weekday.monday,
          week: Week.first,
        );
        // August 15, 2022 is Monday (3rd Monday of August).
        final inputDate = DateTime(2022, 8, 15);
        // September 5, 2022 is Monday (1st Monday of September).
        final expected = DateTime(2022, 9, 5);

        expect(everyFirstMonday, hasNext(expected).withInput(inputDate));
      });

      test('Last Friday of month calculation', () {
        const everyLastFriday = EveryWeekdayCountInMonth(
          day: Weekday.friday,
          week: Week.last,
        );
        // August 15, 2022 is Monday.
        final inputDate = DateTime(2022, 8, 15);
        // August 26, 2022 is Friday (last Friday of August).
        final expected = DateTime(2022, 8, 26);

        expect(everyLastFriday, hasNext(expected).withInput(inputDate));
      });

      test('Edge case: leap year February last day', () {
        const everyLastThursday = EveryWeekdayCountInMonth(
          day: Weekday.thursday,
          week: Week.last,
        );
        // February 15, 2024 is Thursday.
        final inputDate = DateTime(2024, 2, 15);
        // February 29, 2024 is Thursday (last Thursday of leap year February).
        final expected = DateTime(2024, 2, 29);

        expect(everyLastThursday, hasNext(expected).withInput(inputDate));
      });

      test('Edge case: third Wednesday across year boundary', () {
        const everyThirdWednesday = EveryWeekdayCountInMonth(
          day: Weekday.wednesday,
          week: Week.third,
        );
        // December 25, 2022 is Sunday.
        final inputDate = DateTime(2022, 12, 25);
        // January 18, 2023 is Wednesday (3rd Wednesday of January).
        final expected = DateTime(2023, 1, 18);

        expect(everyThirdWednesday, hasNext(expected).withInput(inputDate));
      });

      test('Previous calculation: second Saturday', () {
        const everySecondSaturday = EveryWeekdayCountInMonth(
          day: Weekday.saturday,
          week: Week.second,
        );
        // September 15, 2022 is Thursday.
        final inputDate = DateTime(2022, 9, 15);
        // September 10, 2022 is Saturday (2nd Saturday of September).
        final expected = DateTime(2022, 9, 10);

        expect(everySecondSaturday, hasPrevious(expected).withInput(inputDate));
      });

      test('Fourth Tuesday calculation', () {
        const everyFourthTuesday = EveryWeekdayCountInMonth(
          day: Weekday.tuesday,
          week: Week.fourth,
        );
        // August 1, 2022 is Monday.
        final inputDate = DateTime(2022, 8);
        // August 23, 2022 is Tuesday (4th Tuesday of August).
        final expected = DateTime(2022, 8, 23);

        expect(everyFourthTuesday, hasNext(expected).withInput(inputDate));
      });
    });

    group('Time component preservation:', () {
      test('Maintains time components in local DateTime', () {
        const everySecondMonday = EveryWeekdayCountInMonth(
          day: Weekday.monday,
          week: Week.second,
        );
        final inputWithTime = DateTime(2022, 8, 15, 14, 30, 45, 123, 456);
        final result = everySecondMonday.next(inputWithTime);

        // Should preserve time components.
        expect(result.exactTimeOfDay, equals(inputWithTime.exactTimeOfDay));
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
        expect(result, isLocalDateTime);
      });

      test('Maintains time components in UTC DateTime', () {
        const everySecondMonday = EveryWeekdayCountInMonth(
          day: Weekday.monday,
          week: Week.second,
        );
        final inputWithTime = DateTime.utc(2022, 8, 15, 14, 30, 45, 123, 456);
        final result = everySecondMonday.next(inputWithTime);

        // Should preserve time components and UTC flag.
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
        expect(result, isUtcDateTime);
      });

      test('Previous maintains time components in local DateTime', () {
        const everyLastFriday = EveryWeekdayCountInMonth(
          day: Weekday.friday,
          week: Week.last,
        );
        final inputWithTime = DateTime(2022, 9, 15, 9, 15, 30, 500, 250);
        final result = everyLastFriday.previous(inputWithTime);

        // Should preserve time components.
        expect(result.hour, equals(9));
        expect(result.minute, equals(15));
        expect(result.second, equals(30));
        expect(result.millisecond, equals(500));
        expect(result.microsecond, equals(250));
        expect(result, isLocalDateTime);
      });

      test('Previous maintains time components in UTC DateTime', () {
        const everyLastFriday = EveryWeekdayCountInMonth(
          day: Weekday.friday,
          week: Week.last,
        );
        final inputWithTime = DateTime.utc(2022, 10, 16, 9, 15, 30, 500, 250);
        final result = everyLastFriday.previous(inputWithTime);

        // Should preserve time components and UTC flag.
        expect(result.hour, equals(9));
        expect(result.minute, equals(15));
        expect(result.second, equals(30));
        expect(result.millisecond, equals(500));
        expect(result.microsecond, equals(250));
        expect(result, isUtcDateTime);
      });

      test('Normal generation with date-only input (local)', () {
        const everyThirdWednesday = EveryWeekdayCountInMonth(
          day: Weekday.wednesday,
          week: Week.third,
        );
        final inputDate = DateTime(2022, 8, 5);
        final expected = DateTime(2022, 8, 17);

        expect(everyThirdWednesday, hasNext(expected).withInput(inputDate));
      });

      test('Normal generation with date-only input (UTC)', () {
        const everyThirdWednesday = EveryWeekdayCountInMonth(
          day: Weekday.wednesday,
          week: Week.third,
        );
        final inputDate = DateTime.utc(2022, 8, 5);
        final expected = DateTime.utc(2022, 8, 17);

        expect(everyThirdWednesday, hasNext(expected).withInput(inputDate));
      });
    });

    group('Edge Cases', () {
      group('All weekday occurrences', () {
        for (final occurrence in WeekdayOccurrence.values) {
          test('${occurrence.name} works correctly', () {
            final every = EveryWeekdayCountInMonth(
              day: occurrence.day,
              week: occurrence.week,
            );
            expect(every.day, equals(occurrence.day));
            expect(every.week, equals(occurrence.week));

            // Test that it can generate dates.
            final testDate = DateTime(2023, DateTime.june, 15);
            final next = every.next(testDate);
            final previous = every.previous(testDate);
            expect(next.isAfter(testDate), isTrue);
            expect(previous.isBefore(testDate), isTrue);
          });
        }
      });

      group('Month boundaries', () {
        const every = EveryWeekdayCountInMonth(
          day: Weekday.friday,
          week: Week.last,
        );

        test('Handles February in leap year', () {
          // February 2024 is a leap year.
          final testDate = DateTime(2024, DateTime.february, 15);
          final result = every.next(testDate);
          expect(result.month, equals(DateTime.february));
          expect(result.year, equals(2024));
        });
        test('Handles February in non-leap year', () {
          // February 2023 is not a leap year.
          final testDate = DateTime(2023, DateTime.february, 15);
          final result = every.next(testDate);
          expect(result.month, equals(DateTime.february));
          expect(result.year, equals(2023));
        });
      });

      group('Year boundaries', () {
        const every = EveryWeekdayCountInMonth(
          day: Weekday.sunday,
          week: Week.first,
        );

        test('Handles December to January transition', () {
          final december31 = DateTime(2022, DateTime.december, 31);
          final result = every.next(december31);
          expect(result.year, equals(2023));
          expect(result.month, equals(DateTime.january));
        });
        test('Handles January to December transition', () {
          final january1 = DateTime(2023);
          final result = every.previous(january1);
          expect(result.year, equals(2022));
          expect(result.month, equals(DateTime.december));
        });
      });
    });

    group('toString', () {
      test('Returns meaningful string representation', () {
        final every = EveryWeekdayCountInMonth(
          day: Weekday.friday,
          week: Week.third,
        );
        expect(
          every.toString(),
          equals('EveryWeekdayCountInMonth<Week.third, Weekday.friday>'),
        );
      });
    });

    group('First Monday', () {
      const firstMondayOfMonth = EveryWeekdayCountInMonth(
        week: Week.first,
        day: Weekday.monday,
      );
      group('Local', () {
        test('Day 1', () {
          final middleOfPreviousMonth = DateTime(2022, DateTime.july, 15);
          final matcher = DateTime(2022, DateTime.august);
          expect(
            firstMondayOfMonth.startDate(middleOfPreviousMonth),
            isSameDateTime(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(middleOfPreviousMonth, 0),
            isSameDateTime(matcher),
          );
        });
        test('Day 2', () {
          final middleOfPreviousMonth = DateTime(2022, DateTime.december, 15);
          final matcher = DateTime(2023, DateTime.january, 2);
          expect(
            firstMondayOfMonth.startDate(middleOfPreviousMonth),
            isSameDateTime(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(middleOfPreviousMonth, 0),
            isSameDateTime(matcher),
          );
        });
        test('Day 3', () {
          final middleOfPreviousMonth = DateTime(2022, DateTime.september, 15);
          final matcher = DateTime(2022, DateTime.october, 3);
          expect(
            firstMondayOfMonth.startDate(middleOfPreviousMonth),
            isSameDateTime(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(middleOfPreviousMonth, 0),
            isSameDateTime(matcher),
          );
        });
        test('Day 4', () {
          final middleOfPreviousMonth = DateTime(2022, DateTime.june, 15);
          final matcher = DateTime(2022, DateTime.july, 4);
          expect(
            firstMondayOfMonth.startDate(middleOfPreviousMonth),
            isSameDateTime(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(middleOfPreviousMonth, 0),
            isSameDateTime(matcher),
          );
        });
        test('Day 5', () {
          final matcher = DateTime(2022, DateTime.september, 5);
          expect(
            firstMondayOfMonth.startDate(august12th2022),
            isSameDateTime(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(august12th2022, 0),
            isSameDateTime(matcher),
          );
        });
        test('Day 6', () {
          final middleOfPreviousMonth = DateTime(2023, DateTime.january, 15);
          final matcher = DateTime(2023, DateTime.february, 6);
          expect(
            firstMondayOfMonth.startDate(middleOfPreviousMonth),
            isSameDateTime(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(middleOfPreviousMonth, 0),
            isSameDateTime(matcher),
          );
        });
        test('Day 7', () {
          final middleOfPreviousMonth = DateTime(2022, DateTime.october, 15);
          final matcher = DateTime(2022, DateTime.november, 7);
          expect(
            firstMondayOfMonth.startDate(middleOfPreviousMonth),
            isSameDateTime(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(middleOfPreviousMonth, 0),
            isSameDateTime(matcher),
          );
        });
      });
      group('UTC', () {
        test('Day 1', () {
          final middleOfPreviousMonthUtc = DateTime.utc(
            2022,
            DateTime.july,
            15,
          );
          final matcher = DateTime.utc(2022, DateTime.august);
          expect(
            firstMondayOfMonth.startDate(middleOfPreviousMonthUtc),
            isSameDateTime(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(middleOfPreviousMonthUtc, 0),
            isSameDateTime(matcher),
          );
        });
        test('Day 2', () {
          final middleOfPreviousMonthUtc = DateTime.utc(
            2022,
            DateTime.december,
            15,
          );
          final matcher = DateTime.utc(2023, DateTime.january, 2);
          expect(
            firstMondayOfMonth.startDate(middleOfPreviousMonthUtc),
            isSameDateTime(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(middleOfPreviousMonthUtc, 0),
            isSameDateTime(matcher),
          );
        });
        test('Day 3', () {
          final middleOfPreviousMonthUtc = DateTime.utc(
            2022,
            DateTime.september,
            15,
          );
          final matcher = DateTime.utc(2022, DateTime.october, 3);
          expect(
            firstMondayOfMonth.startDate(middleOfPreviousMonthUtc),
            isSameDateTime(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(middleOfPreviousMonthUtc, 0),
            isSameDateTime(matcher),
          );
        });
        test('Day 4', () {
          final middleOfPreviousMonthUtc = DateTime.utc(
            2022,
            DateTime.june,
            15,
          );
          final matcher = DateTime.utc(2022, DateTime.july, 4);
          expect(
            firstMondayOfMonth.startDate(middleOfPreviousMonthUtc),
            isSameDateTime(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(middleOfPreviousMonthUtc, 0),
            isSameDateTime(matcher),
          );
        });
        test('Day 5', () {
          final matcher = DateTime.utc(2022, DateTime.september, 5);
          expect(
            firstMondayOfMonth.startDate(august12th2022Utc),
            isSameDateTime(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(august12th2022Utc, 0),
            isSameDateTime(matcher),
          );
        });
        test('Day 6', () {
          final middleOfPreviousMonthUtc = DateTime.utc(
            2023,
            DateTime.january,
            15,
          );
          final matcher = DateTime.utc(2023, DateTime.february, 6);
          expect(
            firstMondayOfMonth.startDate(middleOfPreviousMonthUtc),
            isSameDateTime(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(middleOfPreviousMonthUtc, 0),
            isSameDateTime(matcher),
          );
        });
        test('Day 7', () {
          final middleOfPreviousMonthUtc = DateTime.utc(
            2022,
            DateTime.october,
            15,
          );
          final matcher = DateTime.utc(2022, DateTime.november, 7);
          expect(
            firstMondayOfMonth.startDate(middleOfPreviousMonthUtc),
            isSameDateTime(matcher),
          );
          expect(
            firstMondayOfMonth.addMonths(middleOfPreviousMonthUtc, 0),
            isSameDateTime(matcher),
          );
        });
      });
    });
    group('Last wednesday', () {
      const lastWednesdayOfMonth = EveryWeekdayCountInMonth(
        week: Week.last,
        day: Weekday.wednesday,
      );
      group('Local', () {
        final middleOfMonth = DateTime(2024, DateTime.february, 15);
        test('Subtract months so is March', () {
          final matcher = DateTime(2023, DateTime.march, 29);
          expect(
            lastWednesdayOfMonth.addMonths(middleOfMonth, -11),
            isSameDateTime(matcher),
          );
        });
        test('Add months so is March in leap year', () {
          final matcher = DateTime(2024, DateTime.march, 27);
          expect(
            lastWednesdayOfMonth.addMonths(middleOfMonth, 1),
            isSameDateTime(matcher),
          );
        });
      });
      group('UTC', () {
        final middleOfMonthUtc = DateTime.utc(2024, DateTime.february, 15);
        test('Subtract months so is March', () {
          final matcher = DateTime.utc(2023, DateTime.march, 29);
          expect(
            lastWednesdayOfMonth.addMonths(middleOfMonthUtc, -11),
            isSameDateTime(matcher),
          );
        });
        test('Add months so is March in leap year', () {
          final matcher = DateTime.utc(2024, DateTime.march, 27);
          expect(
            lastWednesdayOfMonth.addMonths(middleOfMonthUtc, 1),
            isSameDateTime(matcher),
          );
        });
      });
    });
    group('Equality', () {
      final every1 = EveryWeekdayCountInMonth(
        day: Weekday.monday,
        week: Week.first,
      );
      final every2 = EveryWeekdayCountInMonth(
        day: Weekday.tuesday,
        week: Week.first,
      );
      final every3 = EveryWeekdayCountInMonth(
        day: Weekday.monday,
        week: Week.second,
      );
      final every4 = EveryWeekdayCountInMonth(
        day: Weekday.monday,
        week: Week.first,
      );

      test('Same instance', () {
        expect(every1, equals(every1));
      });
      test('Different day', () {
        expect(every1, isNot(equals(every2)));
      });
      test('Different week', () {
        expect(every1, isNot(equals(every3)));
      });
      test('Same day and week', () {
        expect(every1, equals(every4));
      });
      test('Hash code consistency', () {
        expect(every1.hashCode, equals(every4.hashCode));
      });
    });
    group('Validation behavior', () {
      group('All weekday occurrences validation:', () {
        for (final occurrence in WeekdayOccurrence.values) {
          group('Every ${occurrence.name}', () {
            final every = EveryWeekdayCountInMonth(
              day: occurrence.day,
              week: occurrence.week,
            );

            // Test several months to ensure consistent behavior.
            for (var month = 1; month <= 12; month++) {
              group('Month $month', () {
                // 2023 for testing.
                const year = 2023;
                final daysInMonth = DateTime(year, month + 1, 0).day;

                for (var dayOfMonth = 1;
                    dayOfMonth <= daysInMonth;
                    dayOfMonth++) {
                  final date = DateTime(year, month, dayOfMonth);
                  final valid = every.valid(date);

                  test(
                    'Day $dayOfMonth ('
                    '${Weekday.fromDateTimeValue(date.weekday).name}) is '
                    '${valid ? '' : 'not '}valid',
                    () {
                      if (valid) {
                        expect(every, isValid(date));
                        expect(every, startsAtSameDate.withInput(date));
                      } else {
                        expect(every, isInvalid(date));
                        expect(every, nextIsAfter.withInput(date));
                        expect(every, previousIsBefore.withInput(date));
                      }
                    },
                  );
                }
              });
            }
          });
        }
      });
    });
  });
}
