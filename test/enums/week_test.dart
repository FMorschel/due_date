import 'package:due_date/src/enums/week.dart';
import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/periods/week_period.dart';
import 'package:test/test.dart';

void main() {
  group('Week:', () {
    group('Values', () {
      test('Has all expected values', () {
        expect(Week.values.length, equals(5));
        expect(
          Week.values,
          containsAllInOrder([
            Week.first,
            Week.second,
            Week.third,
            Week.fourth,
            Week.last,
          ]),
        );
      });
    });
    group('Factory methods', () {
      group('from', () {
        // Test that Week.from returns the correct Week for various days in
        // August 2022.
        const year = 2022;
        const month = 8;
        test('Returns Week.first for days 1-7', () {
          for (var day = 1; day <= 7; day++) {
            final date = DateTime(year, month, day);
            expect(
              Week.from(date),
              equals(Week.first),
              reason: 'Day $day should be Week.first',
            );
          }
        });
        test('Returns Week.second for days 8-14', () {
          for (var day = 8; day <= 14; day++) {
            final date = DateTime(year, month, day);
            expect(
              Week.from(date),
              equals(Week.second),
              reason: 'Day $day should be Week.second',
            );
          }
        });
        test('Returns Week.third for days 15-21', () {
          for (var day = 15; day <= 21; day++) {
            final date = DateTime(year, month, day);
            expect(
              Week.from(date),
              equals(Week.third),
              reason: 'Day $day should be Week.third',
            );
          }
        });
        test('Returns Week.fourth for days 22-28', () {
          for (var day = 22; day <= 28; day++) {
            final date = DateTime(year, month, day);
            expect(
              Week.from(date),
              equals(Week.fourth),
              reason: 'Day $day should be Week.fourth',
            );
          }
        });
        test('Returns Week.last for days 29-31', () {
          for (var day = 29; day <= 31; day++) {
            final date = DateTime(year, month, day);
            expect(
              Week.from(date),
              equals(Week.last),
              reason: 'Day $day should be Week.last',
            );
          }
        });
        test('Works with different years and months', () {
          // Test February 2024 (leap year).
          expect(Week.from(DateTime(2024, 2)), equals(Week.first));
          expect(Week.from(DateTime(2024, 2, 15)), equals(Week.third));
          expect(Week.from(DateTime(2024, 2, 29)), equals(Week.last));

          expect(
            Week.from(DateTime(2024, 2), firstDayOfWeek: Weekday.thursday),
            equals(Week.first),
          );
          expect(
            Week.from(DateTime(2024, 2, 15), firstDayOfWeek: Weekday.thursday),
            equals(Week.third),
          );
          expect(
            Week.from(DateTime(2024, 2, 29), firstDayOfWeek: Weekday.thursday),
            equals(Week.last),
          );

          // Test February 2023 (non-leap year).
          expect(Week.from(DateTime(2023, 2)), equals(Week.first));
          expect(Week.from(DateTime(2023, 2, 15)), equals(Week.third));
          expect(Week.from(DateTime(2023, 2, 28)), equals(Week.last));

          // Test December (31 days).
          expect(Week.from(DateTime(2024, 12)), equals(Week.first));
          expect(Week.from(DateTime(2024, 12, 31)), equals(Week.last));
        });
        test('Works with UTC dates', () {
          expect(Week.from(DateTime.utc(2022, 8)), equals(Week.first));
          expect(Week.from(DateTime.utc(2022, 8, 15)), equals(Week.third));
          expect(Week.from(DateTime.utc(2022, 8, 31)), equals(Week.last));
        });
      });
      group('of method', () {
        test('First week creates correct WeekPeriod', () {
          // January 2024 starts on Monday.
          final weekPeriod = Week.first.of(2024, 1);
          expect(weekPeriod.start.year, equals(2024));
          expect(weekPeriod.start.month, equals(1));
          expect(weekPeriod.start.day, equals(1));
        });
        test('Second week creates correct WeekPeriod', () {
          final weekPeriod = Week.second.of(2024, 1);
          expect(weekPeriod.start.year, equals(2024));
          expect(weekPeriod.start.month, equals(1));
          expect(weekPeriod.start.day, equals(8));
        });
        test('Third week creates correct WeekPeriod', () {
          final weekPeriod = Week.third.of(2024, 1);
          expect(weekPeriod.start.year, equals(2024));
          expect(weekPeriod.start.month, equals(1));
          expect(weekPeriod.start.day, equals(15));
        });
        test('Fourth week creates correct WeekPeriod', () {
          final weekPeriod = Week.fourth.of(2024, 1);
          expect(weekPeriod.start.year, equals(2024));
          expect(weekPeriod.start.month, equals(1));
          expect(weekPeriod.start.day, equals(22));
        });
        test('Last week creates correct WeekPeriod when different from fourth',
            () {
          // January 2024 has 31 days, so last week should be different from
          // fourth.
          final fourthWeek = Week.fourth.of(2024, 1);
          final lastWeek = Week.last.of(2024, 1);

          expect(fourthWeek.start.day, equals(22));
          expect(lastWeek.start.day, equals(29));
          expect(fourthWeek.start, isNot(equals(lastWeek.start)));
        });
        test('Last week returns fourth week when they are the same', () {
          // February 2023 (28 days) - last week should be same as fourth.
          final fourthWeek = Week.fourth.of(2021, 2);
          final lastWeek = Week.last.of(2021, 2);

          expect(lastWeek.start, equals(fourthWeek.start));
          expect(lastWeek.end, equals(fourthWeek.end));
        });
        test('Works with different firstDayOfWeek', () {
          // Test with Sunday as first day of week.
          final weekPeriod = Week.first.of(
            2024,
            1,
            firstDayOfWeek: Weekday.sunday,
          );
          expect(weekPeriod, isA<WeekPeriod>());

          // Test with Saturday as first day of week.
          final weekPeriodSat = Week.second.of(
            2024,
            1,
            firstDayOfWeek: Weekday.saturday,
          );
          expect(weekPeriodSat, isA<WeekPeriod>());
        });
        test('Works with non-UTC dates', () {
          final weekPeriod = Week.first.of(2024, 1, utc: false);
          expect(weekPeriod.start.isUtc, isFalse);
          expect(weekPeriod.start.year, equals(2024));
          expect(weekPeriod.start.month, equals(1));
        });
        test('Works with UTC dates', () {
          final weekPeriod = Week.first.of(2024, 1);
          expect(weekPeriod.start.isUtc, isTrue);
          expect(weekPeriod.start.year, equals(2024));
          expect(weekPeriod.start.month, equals(1));
        });
        test('Default UTC parameter is true', () {
          final weekPeriod = Week.first.of(2024, 1);
          expect(weekPeriod.start.isUtc, isTrue);
        });
        test('Works with different months and years', () {
          // Test leap year February.
          final feb2024 = Week.last.of(2024, 2);
          expect(feb2024.start.year, equals(2024));
          expect(feb2024.start.month, equals(2));

          // Test December.
          final dec2024 = Week.last.of(2024, 12);
          expect(dec2024.start.year, equals(2024));
          expect(dec2024.start.month, equals(12));

          // Test different year.
          final jan2023 = Week.first.of(2023, 1);
          expect(jan2023.start.year, equals(2022));
          expect(jan2023.start.month, equals(12));
          expect(jan2023.end.year, equals(2023));
          expect(jan2023.end.month, equals(1));
        });
        test('All weeks produce valid WeekPeriod objects', () {
          for (final week in Week.values) {
            final weekPeriod = week.of(2026, 8);
            expect(weekPeriod, isA<WeekPeriod>());
            expect(weekPeriod.start.year, equals(2026));
            expect(
              weekPeriod.start.month,
              anyOf(
                equals(7),
                equals(8),
                equals(9),
              ),
            ); // Week might span months.
          }
        });
      });
    });
    group('Navigation methods', () {
      group('Previous:', () {
        for (final week in Week.values) {
          test(week.name, () {
            if (week != Week.first) {
              expect(
                week.previous,
                equals(Week.values[week.index - 1]),
              );
            } else {
              expect(week.previous, equals(Week.last));
            }
          });
        }
      });
      group('Next:', () {
        for (final week in Week.values) {
          test(week.name, () {
            if (week != Week.last) {
              expect(
                week.next,
                equals(Week.values[week.index + 1]),
              );
            } else {
              expect(week.next, equals(Week.first));
            }
          });
        }
      });
    });
    group('Properties for all values:', () {
      for (final week in Week.values) {
        group(week.name, () {
          test('index is correct', () {
            expect(week.index, equals(Week.values.indexOf(week)));
          });
        });
      }
    });
    group('String representation', () {
      test('All weeks have correct string representation', () {
        expect(Week.first.toString(), equals('Week.first'));
        expect(Week.second.toString(), equals('Week.second'));
        expect(Week.third.toString(), equals('Week.third'));
        expect(Week.fourth.toString(), equals('Week.fourth'));
        expect(Week.last.toString(), equals('Week.last'));
      });
    });
    group('Name property', () {
      test('All weeks have correct name', () {
        expect(Week.first.name, equals('first'));
        expect(Week.second.name, equals('second'));
        expect(Week.third.name, equals('third'));
        expect(Week.fourth.name, equals('fourth'));
        expect(Week.last.name, equals('last'));
      });
    });
    group('Index property', () {
      test('All weeks have correct index', () {
        for (var i = 0; i < Week.values.length; i++) {
          expect(Week.values[i].index, equals(i));
        }
      });
    });
    group('Equality', () {
      test('Same values are equal', () {
        expect(Week.first, equals(Week.first));
        expect(Week.last, equals(Week.last));
      });
      test('Different values are not equal', () {
        expect(Week.first, isNot(equals(Week.second)));
        expect(Week.third, isNot(equals(Week.fourth)));
      });
    });
    group('Comparison operators', () {
      group('compareTo', () {
        test('Same week returns 0', () {
          expect(Week.first.compareTo(Week.first), equals(0));
          expect(Week.third.compareTo(Week.third), equals(0));
          expect(Week.last.compareTo(Week.last), equals(0));
        });
        test('Earlier week returns negative', () {
          expect(Week.first.compareTo(Week.second), lessThan(0));
          expect(Week.second.compareTo(Week.fourth), lessThan(0));
          expect(Week.third.compareTo(Week.last), lessThan(0));
        });
        test('Later week returns positive', () {
          expect(Week.second.compareTo(Week.first), greaterThan(0));
          expect(Week.fourth.compareTo(Week.second), greaterThan(0));
          expect(Week.last.compareTo(Week.third), greaterThan(0));
        });
        test('All weeks comparison consistency', () {
          for (var i = 0; i < Week.values.length; i++) {
            for (var j = 0; j < Week.values.length; j++) {
              final week1 = Week.values[i];
              final week2 = Week.values[j];
              final result = week1.compareTo(week2);
              if (i == j) {
                expect(result, equals(0), reason: '$week1 should equal $week2');
              } else if (i < j) {
                expect(
                  result,
                  lessThan(0),
                  reason: '$week1 should be less than $week2',
                );
              } else {
                expect(
                  result,
                  greaterThan(0),
                  reason: '$week1 should be greater than $week2',
                );
              }
            }
          }
        });
      });
      group('Greater than operator (>)', () {
        test('Later weeks are greater than earlier weeks', () {
          expect(Week.second > Week.first, isTrue);
          expect(Week.fourth > Week.third, isTrue);
          expect(Week.last > Week.second, isTrue);
        });
        test('Earlier weeks are not greater than later weeks', () {
          expect(Week.first > Week.second, isFalse);
          expect(Week.third > Week.fourth, isFalse);
          expect(Week.second > Week.last, isFalse);
        });
        test('Same weeks are not greater than each other', () {
          expect(Week.first > Week.first, isFalse);
          expect(Week.third > Week.third, isFalse);
          expect(Week.last > Week.last, isFalse);
        });
      });
      group('Greater than or equal operator (>=)', () {
        test('Later weeks are greater than or equal to earlier weeks', () {
          expect(Week.second >= Week.first, isTrue);
          expect(Week.fourth >= Week.third, isTrue);
          expect(Week.last >= Week.second, isTrue);
        });
        test('Same weeks are greater than or equal to each other', () {
          expect(Week.first >= Week.first, isTrue);
          expect(Week.third >= Week.third, isTrue);
          expect(Week.last >= Week.last, isTrue);
        });
        test('Earlier weeks are not greater than or equal to later weeks', () {
          expect(Week.first >= Week.second, isFalse);
          expect(Week.third >= Week.fourth, isFalse);
          expect(Week.second >= Week.last, isFalse);
        });
      });
      group('Less than operator (<)', () {
        test('Earlier weeks are less than later weeks', () {
          expect(Week.first < Week.second, isTrue);
          expect(Week.third < Week.fourth, isTrue);
          expect(Week.second < Week.last, isTrue);
        });
        test('Later weeks are not less than earlier weeks', () {
          expect(Week.second < Week.first, isFalse);
          expect(Week.fourth < Week.third, isFalse);
          expect(Week.last < Week.second, isFalse);
        });
        test('Same weeks are not less than each other', () {
          expect(Week.first < Week.first, isFalse);
          expect(Week.third < Week.third, isFalse);
          expect(Week.last < Week.last, isFalse);
        });
      });
      group('Less than or equal operator (<=)', () {
        test('Earlier weeks are less than or equal to later weeks', () {
          expect(Week.first <= Week.second, isTrue);
          expect(Week.third <= Week.fourth, isTrue);
          expect(Week.second <= Week.last, isTrue);
        });
        test('Same weeks are less than or equal to each other', () {
          expect(Week.first <= Week.first, isTrue);
          expect(Week.third <= Week.third, isTrue);
          expect(Week.last <= Week.last, isTrue);
        });
        test('Later weeks are not less than or equal to earlier weeks', () {
          expect(Week.second <= Week.first, isFalse);
          expect(Week.fourth <= Week.third, isFalse);
          expect(Week.last <= Week.second, isFalse);
        });
      });
    });
    group('Arithmetic operators', () {
      group('Addition operator (+)', () {
        test('Adding 1 week advances to next week', () {
          expect(Week.first + 1, equals(Week.second));
          expect(Week.second + 1, equals(Week.third));
          expect(Week.third + 1, equals(Week.fourth));
          expect(Week.fourth + 1, equals(Week.last));
        });
        test('Adding multiple weeks advances correctly', () {
          expect(Week.first + 2, equals(Week.third));
          expect(Week.first + 3, equals(Week.fourth));
          expect(Week.second + 2, equals(Week.fourth));
          expect(Week.second + 3, equals(Week.last));
        });
        test('Adding wraps around when exceeding last week', () {
          expect(Week.last + 1, equals(Week.first));
          expect(Week.fourth + 2, equals(Week.first));
          expect(Week.third + 3, equals(Week.first));
        });
        test('Adding 5 weeks returns same week', () {
          for (final week in Week.values) {
            expect(week + 5, equals(week));
          }
        });
        test('Adding 0 returns same week', () {
          for (final week in Week.values) {
            expect(week + 0, equals(week));
          }
        });
        test('Adding large numbers wraps correctly', () {
          expect(Week.first + 6, equals(Week.second));
          expect(Week.second + 8, equals(Week.last));
          expect(Week.third + 10, equals(Week.third));
        });
        test('Adding negative numbers subtracts correctly', () {
          expect(Week.second + (-1), equals(Week.first));
          expect(Week.first + (-1), equals(Week.last));
          expect(Week.fourth + (-2), equals(Week.second));
        });
      });
      group('Subtraction operator (-)', () {
        test('Subtracting 1 week goes to previous week', () {
          expect(Week.second - 1, equals(Week.first));
          expect(Week.third - 1, equals(Week.second));
          expect(Week.fourth - 1, equals(Week.third));
          expect(Week.last - 1, equals(Week.fourth));
        });
        test('Subtracting multiple weeks goes back correctly', () {
          expect(Week.third - 2, equals(Week.first));
          expect(Week.fourth - 3, equals(Week.first));
          expect(Week.last - 2, equals(Week.third));
          expect(Week.last - 3, equals(Week.second));
        });
        test('Subtracting wraps around when going before first week', () {
          expect(Week.first - 1, equals(Week.last));
          expect(Week.second - 2, equals(Week.last));
          expect(Week.third - 3, equals(Week.last));
        });
        test('Subtracting 5 weeks returns same week', () {
          for (final week in Week.values) {
            expect(week - 5, equals(week));
          }
        });
        test('Subtracting 0 returns same week', () {
          for (final week in Week.values) {
            expect(week - 0, equals(week));
          }
        });
        test('Subtracting large numbers wraps correctly', () {
          expect(Week.second - 6, equals(Week.first));
          expect(Week.first - 8, equals(Week.third));
          expect(Week.third - 10, equals(Week.third));
        });
        test('Subtracting negative numbers adds correctly', () {
          expect(Week.first - (-1), equals(Week.second));
          expect(Week.last - (-1), equals(Week.first));
          expect(Week.second - (-2), equals(Week.fourth));
        });
      });
    });
    group('Edge Cases', () {
      test('All weeks are unique', () {
        final set = Week.values.toSet();
        expect(set.length, equals(Week.values.length));
      });
    });
  });
}
