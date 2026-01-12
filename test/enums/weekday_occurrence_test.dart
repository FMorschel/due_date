import 'package:due_date/src/enums/week.dart';
import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/enums/weekday_occurrence.dart';
import 'package:due_date/src/everies/every_weekday_count_in_month.dart';
import 'package:test/test.dart';

import '../src/date_time_match.dart';

void main() {
  group('WeekdayOccurrence:', () {
    group('Values', () {
      test('Has all expected values', () {
        expect(WeekdayOccurrence.values.length, equals(35));
        expect(
          WeekdayOccurrence.values,
          containsAllInOrder([
            WeekdayOccurrence.firstMonday,
            WeekdayOccurrence.firstTuesday,
            WeekdayOccurrence.firstWednesday,
            WeekdayOccurrence.firstThursday,
            WeekdayOccurrence.firstFriday,
            WeekdayOccurrence.firstSaturday,
            WeekdayOccurrence.firstSunday,
            WeekdayOccurrence.secondMonday,
            WeekdayOccurrence.secondTuesday,
            WeekdayOccurrence.secondWednesday,
            WeekdayOccurrence.secondThursday,
            WeekdayOccurrence.secondFriday,
            WeekdayOccurrence.secondSaturday,
            WeekdayOccurrence.secondSunday,
            WeekdayOccurrence.thirdMonday,
            WeekdayOccurrence.thirdTuesday,
            WeekdayOccurrence.thirdWednesday,
            WeekdayOccurrence.thirdThursday,
            WeekdayOccurrence.thirdFriday,
            WeekdayOccurrence.thirdSaturday,
            WeekdayOccurrence.thirdSunday,
            WeekdayOccurrence.fourthMonday,
            WeekdayOccurrence.fourthTuesday,
            WeekdayOccurrence.fourthWednesday,
            WeekdayOccurrence.fourthThursday,
            WeekdayOccurrence.fourthFriday,
            WeekdayOccurrence.fourthSaturday,
            WeekdayOccurrence.fourthSunday,
            WeekdayOccurrence.lastMonday,
            WeekdayOccurrence.lastTuesday,
            WeekdayOccurrence.lastWednesday,
            WeekdayOccurrence.lastThursday,
            WeekdayOccurrence.lastFriday,
            WeekdayOccurrence.lastSaturday,
            WeekdayOccurrence.lastSunday,
          ]),
        );
      });
    });
    group('Equals', () {
      test('firstMonday equals EveryWeekdayCountInMonth', () {
        const weekdayOccurrence = WeekdayOccurrence.firstMonday;
        const everyWeekdayCountInMonth = EveryWeekdayCountInMonth(
          week: Week.first,
          day: Weekday.monday,
        );
        expect(
          weekdayOccurrence,
          equals(everyWeekdayCountInMonth),
        );
      });
    });
    group('String representation', () {
      test('All have correct string representation', () {
        expect(
          WeekdayOccurrence.firstMonday.toString(),
          equals('WeekdayOccurrence.firstMonday'),
        );
        expect(
          WeekdayOccurrence.firstTuesday.toString(),
          equals('WeekdayOccurrence.firstTuesday'),
        );
        expect(
          WeekdayOccurrence.firstWednesday.toString(),
          equals('WeekdayOccurrence.firstWednesday'),
        );
        expect(
          WeekdayOccurrence.firstThursday.toString(),
          equals('WeekdayOccurrence.firstThursday'),
        );
        expect(
          WeekdayOccurrence.firstFriday.toString(),
          equals('WeekdayOccurrence.firstFriday'),
        );
        expect(
          WeekdayOccurrence.firstSaturday.toString(),
          equals('WeekdayOccurrence.firstSaturday'),
        );
        expect(
          WeekdayOccurrence.firstSunday.toString(),
          equals('WeekdayOccurrence.firstSunday'),
        );
      });
    });
    group('Name property', () {
      test('All have correct name', () {
        expect(
          WeekdayOccurrence.firstMonday.name,
          equals('firstMonday'),
        );
        expect(
          WeekdayOccurrence.firstTuesday.name,
          equals('firstTuesday'),
        );
        expect(
          WeekdayOccurrence.firstWednesday.name,
          equals('firstWednesday'),
        );
        expect(
          WeekdayOccurrence.firstThursday.name,
          equals('firstThursday'),
        );
        expect(
          WeekdayOccurrence.firstFriday.name,
          equals('firstFriday'),
        );
        expect(
          WeekdayOccurrence.firstSaturday.name,
          equals('firstSaturday'),
        );
        expect(
          WeekdayOccurrence.firstSunday.name,
          equals('firstSunday'),
        );
      });
    });
    group('Index property', () {
      test('All have correct index', () {
        for (var i = 0; i < WeekdayOccurrence.values.length; i++) {
          expect(WeekdayOccurrence.values[i].index, equals(i));
        }
      });
    });
    group('Equality', () {
      test('Same values are equal', () {
        expect(
          WeekdayOccurrence.firstMonday,
          equals(WeekdayOccurrence.firstMonday),
        );
        expect(
          WeekdayOccurrence.firstTuesday,
          equals(WeekdayOccurrence.firstTuesday),
        );
      });
      test('Different values are not equal', () {
        expect(
          WeekdayOccurrence.firstMonday,
          isNot(equals(WeekdayOccurrence.firstTuesday)),
        );
        expect(
          WeekdayOccurrence.firstWednesday,
          isNot(equals(WeekdayOccurrence.firstThursday)),
        );
      });
    });
    group('Edge Cases', () {
      test('All values are unique', () {
        final set = WeekdayOccurrence.values.toSet();
        expect(set.length, equals(WeekdayOccurrence.values.length));
      });
    });
    group('Factory constructors', () {
      group('from', () {
        test('Creates correct WeekdayOccurrence from first Monday', () {
          // July 4, 2022 is Monday (first Monday of July).
          final july4th2022 = DateTime(2022, DateTime.july, 4);
          final result = WeekdayOccurrence.from(july4th2022);
          expect(result, equals(WeekdayOccurrence.firstMonday));
        });

        test('Creates correct WeekdayOccurrence from second Tuesday', () {
          // August 9, 2022 is Tuesday (second Tuesday of August).
          final august9th2022 = DateTime(2022, DateTime.august, 9);
          final result = WeekdayOccurrence.from(august9th2022);
          expect(result, equals(WeekdayOccurrence.secondTuesday));
        });

        test('Creates correct WeekdayOccurrence from third Wednesday', () {
          // July 20, 2022 is Wednesday (third Wednesday of July).
          final july20th2022 = DateTime(2022, DateTime.july, 20);
          final result = WeekdayOccurrence.from(july20th2022);
          expect(result, equals(WeekdayOccurrence.thirdWednesday));
        });

        test('Creates correct WeekdayOccurrence from fourth Thursday', () {
          // July 28, 2022 is Thursday (fourth Thursday of July).
          final july28th2022 = DateTime(2022, DateTime.july, 28);
          final result = WeekdayOccurrence.from(july28th2022);
          expect(result, equals(WeekdayOccurrence.fourthThursday));
        });

        test('Creates correct WeekdayOccurrence from last Friday', () {
          // July 29, 2022 is Friday (last Friday of July).
          final july29th2022 = DateTime(2022, DateTime.july, 29);
          final result = WeekdayOccurrence.from(july29th2022);
          expect(result, equals(WeekdayOccurrence.lastFriday));
        });

        test('Creates correct WeekdayOccurrence from first Saturday', () {
          // October 1, 2022 is Saturday (first Saturday of October).
          final october1st2022 = DateTime(2022, DateTime.october);
          final result = WeekdayOccurrence.from(october1st2022);
          expect(result, equals(WeekdayOccurrence.firstSaturday));
        });

        test('Creates correct WeekdayOccurrence from last Sunday', () {
          // July 31, 2022 is Sunday (last Sunday of July).
          final july31st2022 = DateTime(2022, DateTime.july, 31);
          final result = WeekdayOccurrence.from(july31st2022);
          expect(result, equals(WeekdayOccurrence.lastSunday));
        });

        test('Works with UTC dates', () {
          // July 4, 2022 is Monday (first Monday of July) UTC.
          final july4th2022Utc = DateTime.utc(2022, DateTime.july, 4);
          final result = WeekdayOccurrence.from(july4th2022Utc);
          expect(result, equals(WeekdayOccurrence.firstMonday));
        });

        test('Works with leap year dates', () {
          // February 29, 2020 is Saturday (last Saturday of February in leap
          // year).
          final feb29th2020 = DateTime(2020, DateTime.february, 29);
          final result = WeekdayOccurrence.from(feb29th2020);
          expect(result, equals(WeekdayOccurrence.lastSaturday));
        });
      });

      group('fromEvery', () {
        test(
            'Creates correct WeekdayOccurrence from EveryWeekdayCountInMonth '
            'first Monday', () {
          const every = EveryWeekdayCountInMonth(
            day: Weekday.monday,
            week: Week.first,
          );
          final result = WeekdayOccurrence.fromEvery(every);
          expect(result, equals(WeekdayOccurrence.firstMonday));
        });

        test(
            'Creates correct WeekdayOccurrence from EveryWeekdayCountInMonth '
            'second Tuesday', () {
          const every = EveryWeekdayCountInMonth(
            day: Weekday.tuesday,
            week: Week.second,
          );
          final result = WeekdayOccurrence.fromEvery(every);
          expect(result, equals(WeekdayOccurrence.secondTuesday));
        });

        test(
            'Creates correct WeekdayOccurrence from EveryWeekdayCountInMonth '
            'third Wednesday', () {
          const every = EveryWeekdayCountInMonth(
            day: Weekday.wednesday,
            week: Week.third,
          );
          final result = WeekdayOccurrence.fromEvery(every);
          expect(result, equals(WeekdayOccurrence.thirdWednesday));
        });

        test(
            'Creates correct WeekdayOccurrence from EveryWeekdayCountInMonth '
            'fourth Thursday', () {
          const every = EveryWeekdayCountInMonth(
            day: Weekday.thursday,
            week: Week.fourth,
          );
          final result = WeekdayOccurrence.fromEvery(every);
          expect(result, equals(WeekdayOccurrence.fourthThursday));
        });

        test(
            'Creates correct WeekdayOccurrence from EveryWeekdayCountInMonth '
            'last Friday', () {
          const every = EveryWeekdayCountInMonth(
            day: Weekday.friday,
            week: Week.last,
          );
          final result = WeekdayOccurrence.fromEvery(every);
          expect(result, equals(WeekdayOccurrence.lastFriday));
        });

        test(
            'Creates correct WeekdayOccurrence from EveryWeekdayCountInMonth '
            'first Saturday', () {
          const every = EveryWeekdayCountInMonth(
            day: Weekday.saturday,
            week: Week.first,
          );
          final result = WeekdayOccurrence.fromEvery(every);
          expect(result, equals(WeekdayOccurrence.firstSaturday));
        });

        test(
            'Creates correct WeekdayOccurrence from EveryWeekdayCountInMonth '
            'last Sunday', () {
          const every = EveryWeekdayCountInMonth(
            day: Weekday.sunday,
            week: Week.last,
          );
          final result = WeekdayOccurrence.fromEvery(every);
          expect(result, equals(WeekdayOccurrence.lastSunday));
        });

        test('Works with all possible combinations', () {
          // Test that fromEvery works for all enum values.
          for (final occurrence in WeekdayOccurrence.values) {
            final every = EveryWeekdayCountInMonth(
              day: occurrence.day,
              week: occurrence.week,
            );
            final result = WeekdayOccurrence.fromEvery(every);
            expect(result, equals(occurrence));
          }
        });
      });

      group('Round trip consistency', () {
        test('from(date) and fromEvery should be consistent', () {
          // July 4, 2022 is Monday (first Monday of July).
          final july4th2022 = DateTime(2022, DateTime.july, 4);

          final fromDate = WeekdayOccurrence.from(july4th2022);
          final every = EveryWeekdayCountInMonth.from(july4th2022);
          final fromEvery = WeekdayOccurrence.fromEvery(every);

          expect(fromDate, equals(fromEvery));
          expect(fromDate, equals(WeekdayOccurrence.firstMonday));
        });

        test('Round trip with multiple dates', () {
          final testDates = [
            // First Monday.
            DateTime(2022, DateTime.july, 4),
            // Second Tuesday.
            DateTime(2022, DateTime.august, 9),
            // Third Wednesday.
            DateTime(2022, DateTime.july, 20),
            // Fourth Thursday.
            DateTime(2022, DateTime.july, 28),
            // Last Friday.
            DateTime(2022, DateTime.july, 29),
            // First Saturday.
            DateTime(2022, DateTime.october),
            // Last Sunday.
            DateTime(2022, DateTime.july, 31),
          ];

          for (final date in testDates) {
            final fromDate = WeekdayOccurrence.from(date);
            final every = EveryWeekdayCountInMonth.from(date);
            final fromEvery = WeekdayOccurrence.fromEvery(every);

            expect(
              fromDate,
              equals(fromEvery),
              reason: 'Round trip failed for date: $date',
            );
          }
        });
      });
    });
    group('Method delegation to handler', () {
      group('addMonths', () {
        test('Delegates addMonths to handler correctly with positive months',
            () {
          const occurrence = WeekdayOccurrence.lastFriday;
          // July 29, 2022 is Friday (last Friday of July).
          final july29th = DateTime(2022, DateTime.july, 29);

          // Create equivalent EveryWeekdayCountInMonth for comparison.
          const every = EveryWeekdayCountInMonth(
            day: Weekday.friday,
            week: Week.last,
          );

          final resultFromOccurrence = occurrence.addMonths(july29th, 2);
          final expectedFromHandler = every.addMonths(july29th, 2);

          expect(resultFromOccurrence, isSameDateTime(expectedFromHandler));
          // September 30, 2022 is Friday (last Friday of September).
          expect(
            resultFromOccurrence,
            isSameDateTime(DateTime(2022, DateTime.september, 30)),
          );
        });

        test('Delegates addMonths to handler correctly with negative months',
            () {
          const occurrence = WeekdayOccurrence.lastFriday;
          // July 29, 2022 is Friday (last Friday of July).
          final july29th = DateTime(2022, DateTime.july, 29);

          // Create equivalent EveryWeekdayCountInMonth for comparison.
          const every = EveryWeekdayCountInMonth(
            day: Weekday.friday,
            week: Week.last,
          );

          final resultFromOccurrence = occurrence.addMonths(july29th, -2);
          final expectedFromHandler = every.addMonths(july29th, -2);

          expect(resultFromOccurrence, isSameDateTime(expectedFromHandler));
          // May 27, 2022 is Friday (last Friday of May).
          expect(
            resultFromOccurrence,
            isSameDateTime(DateTime(2022, DateTime.may, 27)),
          );
        });

        test('Delegates addMonths to handler correctly with zero months', () {
          const occurrence = WeekdayOccurrence.lastFriday;
          // July 29, 2022 is Friday (last Friday of July).
          final july29th = DateTime(2022, DateTime.july, 29);

          // Create equivalent EveryWeekdayCountInMonth for comparison.
          const every = EveryWeekdayCountInMonth(
            day: Weekday.friday,
            week: Week.last,
          );

          final resultFromOccurrence = occurrence.addMonths(july29th, 0);
          final expectedFromHandler = every.addMonths(july29th, 0);

          expect(resultFromOccurrence, isSameDateTime(expectedFromHandler));
          expect(resultFromOccurrence, isSameDateTime(july29th));
        });

        test('Delegates addMonths to handler correctly for first occurrence',
            () {
          const occurrence = WeekdayOccurrence.firstMonday;
          // August 1, 2022 is Monday (first Monday of August).
          final august1st = DateTime(2022, DateTime.august);

          // Create equivalent EveryWeekdayCountInMonth for comparison.
          const every = EveryWeekdayCountInMonth(
            day: Weekday.monday,
            week: Week.first,
          );

          final resultFromOccurrence = occurrence.addMonths(august1st, 1);
          final expectedFromHandler = every.addMonths(august1st, 1);

          expect(resultFromOccurrence, isSameDateTime(expectedFromHandler));
          // September 5, 2022 is Monday (first Monday of September).
          expect(
            resultFromOccurrence,
            isSameDateTime(DateTime(2022, DateTime.september, 5)),
          );
        });

        test('Delegates addMonths to handler correctly for different weekdays',
            () {
          // Test secondTuesday.
          const secondTuesday = WeekdayOccurrence.secondTuesday;
          // August 9, 2022 is Tuesday (second Tuesday of August).
          final august9th = DateTime(2022, DateTime.august, 9);
          final secondTuesdayEvery = EveryWeekdayCountInMonth(
            day: secondTuesday.day,
            week: secondTuesday.week,
          );
          expect(
            secondTuesday.addMonths(august9th, 1),
            equals(secondTuesdayEvery.addMonths(august9th, 1)),
          );

          // Test thirdWednesday.
          const thirdWednesday = WeekdayOccurrence.thirdWednesday;
          // July 20, 2022 is Wednesday (third Wednesday of July).
          final july20th = DateTime(2022, DateTime.july, 20);
          final thirdWednesdayEvery = EveryWeekdayCountInMonth(
            day: thirdWednesday.day,
            week: thirdWednesday.week,
          );
          expect(
            thirdWednesday.addMonths(july20th, 1),
            equals(thirdWednesdayEvery.addMonths(july20th, 1)),
          );

          // Test fourthThursday.
          const fourthThursday = WeekdayOccurrence.fourthThursday;
          // July 28, 2022 is Thursday (fourth Thursday of July).
          final july28th = DateTime(2022, DateTime.july, 28);
          final fourthThursdayEvery = EveryWeekdayCountInMonth(
            day: fourthThursday.day,
            week: fourthThursday.week,
          );
          expect(
            fourthThursday.addMonths(july28th, 1),
            equals(fourthThursdayEvery.addMonths(july28th, 1)),
          );
        });

        test('Delegates addMonths to handler correctly with UTC dates', () {
          const occurrence = WeekdayOccurrence.firstSaturday;
          // October 1, 2022 is Saturday (first Saturday of October) UTC.
          final october1stUtc = DateTime.utc(2022, DateTime.october);

          // Create equivalent EveryWeekdayCountInMonth for comparison.
          const every = EveryWeekdayCountInMonth(
            day: Weekday.saturday,
            week: Week.first,
          );

          final resultFromOccurrence = occurrence.addMonths(october1stUtc, 1);
          final expectedFromHandler = every.addMonths(october1stUtc, 1);

          expect(resultFromOccurrence, isSameDateTime(expectedFromHandler));
          expect(resultFromOccurrence.isUtc, isTrue);
        });
      });

      group('startDate', () {
        test('Delegates startDate to handler correctly', () {
          const occurrence = WeekdayOccurrence.firstMonday;
          // July 4, 2022 is Monday (first Monday of July).
          final july4th = DateTime(2022, DateTime.july, 4);

          // Create equivalent EveryWeekdayCountInMonth for comparison.
          const every = EveryWeekdayCountInMonth(
            day: Weekday.monday,
            week: Week.first,
          );

          final resultFromOccurrence = occurrence.startDate(july4th);
          final expectedFromHandler = every.startDate(july4th);

          expect(resultFromOccurrence, isSameDateTime(expectedFromHandler));
          expect(resultFromOccurrence, isSameDateTime(july4th));
        });

        test('Delegates startDate to handler correctly with invalid date', () {
          const occurrence = WeekdayOccurrence.firstMonday;
          // July 5, 2022 is Tuesday (not first Monday).
          final july5th = DateTime(2022, DateTime.july, 5);

          // Create equivalent EveryWeekdayCountInMonth for comparison.
          const every = EveryWeekdayCountInMonth(
            day: Weekday.monday,
            week: Week.first,
          );

          final resultFromOccurrence = occurrence.startDate(july5th);
          final expectedFromHandler = every.startDate(july5th);

          expect(resultFromOccurrence, isSameDateTime(expectedFromHandler));
          // Should return the next first Monday (August 1, 2022).
          expect(
            resultFromOccurrence,
            isSameDateTime(DateTime(2022, DateTime.august)),
          );
        });
      });

      group('next', () {
        test('Delegates next to handler correctly', () {
          const occurrence = WeekdayOccurrence.secondTuesday;
          // August 9, 2022 is Tuesday (second Tuesday of August).
          final august9th = DateTime(2022, DateTime.august, 9);

          // Create equivalent EveryWeekdayCountInMonth for comparison.
          const every = EveryWeekdayCountInMonth(
            day: Weekday.tuesday,
            week: Week.second,
          );

          final resultFromOccurrence = occurrence.next(august9th);
          final expectedFromHandler = every.next(august9th);

          expect(resultFromOccurrence, isSameDateTime(expectedFromHandler));
          // Next second Tuesday should be September 13, 2022.
          expect(
            resultFromOccurrence,
            isSameDateTime(DateTime(2022, DateTime.september, 13)),
          );
        });
      });

      group('previous', () {
        test('Delegates previous to handler correctly', () {
          const occurrence = WeekdayOccurrence.thirdWednesday;
          // July 20, 2022 is Wednesday (third Wednesday of July).
          final july20th = DateTime(2022, DateTime.july, 20);

          // Create equivalent EveryWeekdayCountInMonth for comparison.
          const every = EveryWeekdayCountInMonth(
            day: Weekday.wednesday,
            week: Week.third,
          );

          final resultFromOccurrence = occurrence.previous(july20th);
          final expectedFromHandler = every.previous(july20th);

          expect(resultFromOccurrence, isSameDateTime(expectedFromHandler));
          // Previous third Wednesday should be June 15, 2022.
          expect(
            resultFromOccurrence,
            isSameDateTime(DateTime(2022, DateTime.june, 15)),
          );
        });
      });

      group('endDate', () {
        test('Delegates endDate to handler correctly', () {
          const occurrence = WeekdayOccurrence.firstMonday;
          // July 4, 2022 is Monday (first Monday of July).
          final july4th = DateTime(2022, DateTime.july, 4);

          // Create equivalent EveryWeekdayCountInMonth for comparison.
          const every = EveryWeekdayCountInMonth(
            day: Weekday.monday,
            week: Week.first,
          );

          final resultFromOccurrence = occurrence.endDate(july4th);
          final expectedFromHandler = every.endDate(july4th);

          expect(resultFromOccurrence, isSameDateTime(expectedFromHandler));
          expect(resultFromOccurrence, isSameDateTime(july4th));
        });

        test('Delegates endDate to handler correctly with invalid date', () {
          const occurrence = WeekdayOccurrence.firstMonday;
          // August 2nd, 2022 is Tuesday (not first Monday).
          final august2nd = DateTime(2022, DateTime.august, 2);

          // Create equivalent EveryWeekdayCountInMonth for comparison.
          const every = EveryWeekdayCountInMonth(
            day: Weekday.monday,
            week: Week.first,
          );

          final resultFromOccurrence = occurrence.endDate(august2nd);
          final expectedFromHandler = every.endDate(august2nd);

          expect(resultFromOccurrence, isSameDateTime(expectedFromHandler));
          // Should return the previous first Monday (August 1, 2022).
          expect(
            resultFromOccurrence,
            isSameDateTime(DateTime(2022, DateTime.august)),
          );
        });
      });

      group('addYears', () {
        test('Delegates addYears to handler correctly', () {
          const occurrence = WeekdayOccurrence.lastFriday;
          // July 29, 2022 is Friday (last Friday of July).
          final july29th = DateTime(2022, DateTime.july, 29);

          // Create equivalent EveryWeekdayCountInMonth for comparison.
          const every = EveryWeekdayCountInMonth(
            day: Weekday.friday,
            week: Week.last,
          );

          final resultFromOccurrence = occurrence.addYears(july29th, 1);
          final expectedFromHandler = every.addYears(july29th, 1);

          expect(resultFromOccurrence, isSameDateTime(expectedFromHandler));
          // Last Friday of July 2023 should be July 28, 2023.
          expect(
            resultFromOccurrence,
            isSameDateTime(DateTime(2023, DateTime.july, 28)),
          );
        });
      });

      group('valid', () {
        test('Delegates valid to handler correctly for valid date', () {
          const occurrence = WeekdayOccurrence.firstSaturday;
          // October 1, 2022 is Saturday (first Saturday of October).
          final october1st = DateTime(2022, DateTime.october);

          // Create equivalent EveryWeekdayCountInMonth for comparison.
          const every = EveryWeekdayCountInMonth(
            day: Weekday.saturday,
            week: Week.first,
          );

          final resultFromOccurrence = occurrence.valid(october1st);
          final expectedFromHandler = every.valid(october1st);

          expect(resultFromOccurrence, equals(expectedFromHandler));
          expect(resultFromOccurrence, isTrue);
        });

        test('Delegates valid to handler correctly for invalid date', () {
          const occurrence = WeekdayOccurrence.firstSaturday;
          // October 2, 2022 is Sunday (not first Saturday).
          final october2nd = DateTime(2022, DateTime.october, 2);

          // Create equivalent EveryWeekdayCountInMonth for comparison.
          const every = EveryWeekdayCountInMonth(
            day: Weekday.saturday,
            week: Week.first,
          );

          final resultFromOccurrence = occurrence.valid(october2nd);
          final expectedFromHandler = every.valid(october2nd);

          expect(resultFromOccurrence, equals(expectedFromHandler));
          expect(resultFromOccurrence, isFalse);
        });
      });

      group('compareTo', () {
        test('Delegates compareTo to handler correctly', () {
          const occurrence = WeekdayOccurrence.secondMonday;
          const other = EveryWeekdayCountInMonth(
            day: Weekday.tuesday,
            week: Week.second,
          );

          // Create equivalent EveryWeekdayCountInMonth for comparison.
          const every = EveryWeekdayCountInMonth(
            day: Weekday.monday,
            week: Week.second,
          );

          final resultFromOccurrence = occurrence.compareTo(other);
          final expectedFromHandler = every.compareTo(other);

          expect(resultFromOccurrence, equals(expectedFromHandler));
        });
      });

      group('Properties delegation', () {
        test('Delegates day property to handler correctly', () {
          const occurrence = WeekdayOccurrence.thirdThursday;
          expect(occurrence.day, equals(Weekday.thursday));
        });

        test('Delegates week property to handler correctly', () {
          const occurrence = WeekdayOccurrence.fourthSunday;
          expect(occurrence.week, equals(Week.fourth));
        });

        test('Delegates stringify property to handler correctly', () {
          const occurrence = WeekdayOccurrence.lastMonday;
          const every = EveryWeekdayCountInMonth(
            day: Weekday.monday,
            week: Week.last,
          );

          expect(occurrence.stringify, equals(every.stringify));
        });

        test('Delegates props property to handler correctly', () {
          const occurrence = WeekdayOccurrence.firstTuesday;
          const every = EveryWeekdayCountInMonth(
            day: Weekday.tuesday,
            week: Week.first,
          );

          expect(occurrence.props, equals(every.props));
        });
      });

      group('Comparison operators', () {
        group('Greater than (>)', () {
          test('Returns true when week is later', () {
            expect(
              WeekdayOccurrence.secondMonday > WeekdayOccurrence.firstMonday,
              isTrue,
            );
            expect(
              WeekdayOccurrence.thirdTuesday > WeekdayOccurrence.secondTuesday,
              isTrue,
            );
            expect(
              WeekdayOccurrence.lastFriday > WeekdayOccurrence.fourthFriday,
              isTrue,
            );
          });

          test('Returns true when week is same and day is later', () {
            expect(
              WeekdayOccurrence.firstTuesday > WeekdayOccurrence.firstMonday,
              isTrue,
            );
            expect(
              WeekdayOccurrence.secondSunday > WeekdayOccurrence.secondSaturday,
              isTrue,
            );
            expect(
              WeekdayOccurrence.thirdFriday > WeekdayOccurrence.thirdThursday,
              isTrue,
            );
          });

          test('Returns false when week is earlier', () {
            expect(
              WeekdayOccurrence.firstMonday > WeekdayOccurrence.secondMonday,
              isFalse,
            );
            expect(
              WeekdayOccurrence.secondTuesday > WeekdayOccurrence.thirdTuesday,
              isFalse,
            );
          });

          test('Returns false when week is same and day is earlier', () {
            expect(
              WeekdayOccurrence.firstMonday > WeekdayOccurrence.firstTuesday,
              isFalse,
            );
            expect(
              WeekdayOccurrence.secondThursday > WeekdayOccurrence.secondFriday,
              isFalse,
            );
          });

          test('Returns false when comparing equal occurrences', () {
            expect(
              WeekdayOccurrence.firstMonday > WeekdayOccurrence.firstMonday,
              isFalse,
            );
            expect(
              WeekdayOccurrence.lastSunday > WeekdayOccurrence.lastSunday,
              isFalse,
            );
          });
        });

        group('Greater than or equal (>=)', () {
          test('Returns true when week is later', () {
            expect(
              WeekdayOccurrence.secondMonday >= WeekdayOccurrence.firstMonday,
              isTrue,
            );
            expect(
              WeekdayOccurrence.thirdTuesday >= WeekdayOccurrence.secondTuesday,
              isTrue,
            );
          });

          test('Returns true when week is same and day is later', () {
            expect(
              WeekdayOccurrence.firstTuesday >= WeekdayOccurrence.firstMonday,
              isTrue,
            );
            expect(
              WeekdayOccurrence.secondSunday >=
                  WeekdayOccurrence.secondSaturday,
              isTrue,
            );
          });

          test('Returns true when comparing equal occurrences', () {
            expect(
              WeekdayOccurrence.firstMonday >= WeekdayOccurrence.firstMonday,
              isTrue,
            );
            expect(
              WeekdayOccurrence.lastSunday >= WeekdayOccurrence.lastSunday,
              isTrue,
            );
          });

          test('Returns false when week is earlier', () {
            expect(
              WeekdayOccurrence.firstMonday >= WeekdayOccurrence.secondMonday,
              isFalse,
            );
            expect(
              WeekdayOccurrence.secondTuesday >= WeekdayOccurrence.thirdTuesday,
              isFalse,
            );
          });

          test('Returns false when week is same and day is earlier', () {
            expect(
              WeekdayOccurrence.firstMonday >= WeekdayOccurrence.firstTuesday,
              isFalse,
            );
            expect(
              WeekdayOccurrence.secondThursday >=
                  WeekdayOccurrence.secondFriday,
              isFalse,
            );
          });
        });

        group('Less than (<)', () {
          test('Returns true when week is earlier', () {
            expect(
              WeekdayOccurrence.firstMonday < WeekdayOccurrence.secondMonday,
              isTrue,
            );
            expect(
              WeekdayOccurrence.secondTuesday < WeekdayOccurrence.thirdTuesday,
              isTrue,
            );
            expect(
              WeekdayOccurrence.fourthFriday < WeekdayOccurrence.lastFriday,
              isTrue,
            );
          });

          test('Returns true when week is same and day is earlier', () {
            expect(
              WeekdayOccurrence.firstMonday < WeekdayOccurrence.firstTuesday,
              isTrue,
            );
            expect(
              WeekdayOccurrence.secondSaturday < WeekdayOccurrence.secondSunday,
              isTrue,
            );
            expect(
              WeekdayOccurrence.thirdThursday < WeekdayOccurrence.thirdFriday,
              isTrue,
            );
          });

          test('Returns false when week is later', () {
            expect(
              WeekdayOccurrence.secondMonday < WeekdayOccurrence.firstMonday,
              isFalse,
            );
            expect(
              WeekdayOccurrence.thirdTuesday < WeekdayOccurrence.secondTuesday,
              isFalse,
            );
          });

          test('Returns false when week is same and day is later', () {
            expect(
              WeekdayOccurrence.firstTuesday < WeekdayOccurrence.firstMonday,
              isFalse,
            );
            expect(
              WeekdayOccurrence.secondFriday < WeekdayOccurrence.secondThursday,
              isFalse,
            );
          });

          test('Returns false when comparing equal occurrences', () {
            expect(
              WeekdayOccurrence.firstMonday < WeekdayOccurrence.firstMonday,
              isFalse,
            );
            expect(
              WeekdayOccurrence.lastSunday < WeekdayOccurrence.lastSunday,
              isFalse,
            );
          });
        });

        group('Less than or equal (<=)', () {
          test('Returns true when week is earlier', () {
            expect(
              WeekdayOccurrence.firstMonday <= WeekdayOccurrence.secondMonday,
              isTrue,
            );
            expect(
              WeekdayOccurrence.secondTuesday <= WeekdayOccurrence.thirdTuesday,
              isTrue,
            );
          });

          test('Returns true when week is same and day is earlier', () {
            expect(
              WeekdayOccurrence.firstMonday <= WeekdayOccurrence.firstTuesday,
              isTrue,
            );
            expect(
              WeekdayOccurrence.secondSaturday <=
                  WeekdayOccurrence.secondSunday,
              isTrue,
            );
          });

          test('Returns true when comparing equal occurrences', () {
            expect(
              WeekdayOccurrence.firstMonday <= WeekdayOccurrence.firstMonday,
              isTrue,
            );
            expect(
              WeekdayOccurrence.lastSunday <= WeekdayOccurrence.lastSunday,
              isTrue,
            );
          });

          test('Returns false when week is later', () {
            expect(
              WeekdayOccurrence.secondMonday <= WeekdayOccurrence.firstMonday,
              isFalse,
            );
            expect(
              WeekdayOccurrence.thirdTuesday <= WeekdayOccurrence.secondTuesday,
              isFalse,
            );
          });

          test('Returns false when week is same and day is later', () {
            expect(
              WeekdayOccurrence.firstTuesday <= WeekdayOccurrence.firstMonday,
              isFalse,
            );
            expect(
              WeekdayOccurrence.secondFriday <=
                  WeekdayOccurrence.secondThursday,
              isFalse,
            );
          });
        });

        group('Cross-week comparisons', () {
          test('Correctly compares across different weeks with same days', () {
            // All Mondays in order.
            expect(
              WeekdayOccurrence.firstMonday < WeekdayOccurrence.secondMonday,
              isTrue,
            );
            expect(
              WeekdayOccurrence.secondMonday < WeekdayOccurrence.thirdMonday,
              isTrue,
            );
            expect(
              WeekdayOccurrence.thirdMonday < WeekdayOccurrence.fourthMonday,
              isTrue,
            );
            expect(
              WeekdayOccurrence.fourthMonday < WeekdayOccurrence.lastMonday,
              isTrue,
            );
          });

          test('Correctly compares different days in different weeks', () {
            // Sunday of first week should be less than Monday of second week.
            expect(
              WeekdayOccurrence.firstSunday < WeekdayOccurrence.secondMonday,
              isTrue,
            );
            // Saturday of second week should be less than Sunday of second
            // week.
            expect(
              WeekdayOccurrence.secondSaturday < WeekdayOccurrence.secondSunday,
              isTrue,
            );
          });

          test('Works correctly with extreme comparisons', () {
            // First value should be less than last value.
            expect(
              WeekdayOccurrence.firstMonday < WeekdayOccurrence.lastSunday,
              isTrue,
            );
            expect(
              WeekdayOccurrence.lastSunday > WeekdayOccurrence.firstMonday,
              isTrue,
            );

            // Adjacent values should work correctly.
            expect(
              WeekdayOccurrence.firstMonday < WeekdayOccurrence.firstTuesday,
              isTrue,
            );
            expect(
              WeekdayOccurrence.firstTuesday > WeekdayOccurrence.firstMonday,
              isTrue,
            );
          });
        });

        group('Edge cases', () {
          test('All operators work with all enum values', () {
            // Test that we can compare any two values without errors.
            for (var i = 0; i < WeekdayOccurrence.values.length; i++) {
              for (var j = 0; j < WeekdayOccurrence.values.length; j++) {
                final a = WeekdayOccurrence.values[i];
                final b = WeekdayOccurrence.values[j];

                // These operations should not throw.
                expect(() => a > b, returnsNormally);
                expect(() => a >= b, returnsNormally);
                expect(() => a < b, returnsNormally);
                expect(() => a <= b, returnsNormally);

                // Check consistency with index comparison.
                expect(a > b, equals(i > j));
                expect(a >= b, equals(i >= j));
                expect(a < b, equals(i < j));
                expect(a <= b, equals(i <= j));
              }
            }
          });
        });
      });
    });
  });
}
