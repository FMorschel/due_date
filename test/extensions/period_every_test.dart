import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/everies/built_in/every_due_day_month.dart';
import 'package:due_date/src/everies/built_in/every_weekday.dart';
import 'package:due_date/src/everies/every.dart';
import 'package:due_date/src/extensions/period_every.dart';
import 'package:due_date/src/periods/period.dart';
import 'package:test/test.dart';

import '../src/every_day.dart';

void main() {
  group('PeriodEvery:', () {
    group('getEveryDateTimeValues', () {
      // January 1, 2024 is a Monday.
      group('EveryDateValidator', () {
        test('Includes the start when it is valid', () {
          final period = Period(
            start: DateTime(2024),
            end: DateTime(2024, 1, 31),
          );
          expect(
            period.getEveryDateTimeValues(const Every.weekday(Weekday.monday)),
            orderedEquals([
              DateTime(2024),
              DateTime(2024, 1, 8),
              DateTime(2024, 1, 15),
              DateTime(2024, 1, 22),
              DateTime(2024, 1, 29),
            ]),
          );
        });

        test('Starts at the first valid date after an invalid start', () {
          final period = Period(
            start: DateTime(2024, 1, 2),
            end: DateTime(2024, 1, 31),
          );
          expect(
            period.getEveryDateTimeValues(const Every.weekday(Weekday.monday)),
            orderedEquals([
              DateTime(2024, 1, 8),
              DateTime(2024, 1, 15),
              DateTime(2024, 1, 22),
              DateTime(2024, 1, 29),
            ]),
          );
        });

        test('Includes an occurrence at the end', () {
          final period = Period(
            start: DateTime(2024, 1, 2),
            end: DateTime(2024, 1, 8),
          );
          expect(
            period.getEveryDateTimeValues(const Every.weekday(Weekday.monday)),
            orderedEquals([DateTime(2024, 1, 8)]),
          );
        });

        test('Returns empty when there is no occurrence in the period', () {
          final period = Period(
            start: DateTime(2024, 1, 2),
            end: DateTime(2024, 1, 7),
          );
          expect(
            period.getEveryDateTimeValues(const Every.weekday(Weekday.monday)),
            isEmpty,
          );
        });
      });

      group('Plain Every', () {
        test('Excludes the start', () {
          final period = Period(
            start: DateTime(2024),
            end: DateTime(2024, 1, 3),
          );
          expect(
            period.getEveryDateTimeValues(const EveryDay()),
            orderedEquals([DateTime(2024, 1, 2), DateTime(2024, 1, 3)]),
          );
        });
      });

      group('LimitedEvery', () {
        test('Returns the occurrences of a union', () {
          final period = Period(
            start: DateTime(2024),
            end: DateTime(2024, 1, 14),
          );
          expect(
            period.getEveryDateTimeValues(
              const Every.union([
                EveryWeekday(Weekday.monday),
                EveryWeekday(Weekday.friday),
              ]),
            ),
            orderedEquals([
              DateTime(2024),
              DateTime(2024, 1, 5),
              DateTime(2024, 1, 8),
              DateTime(2024, 1, 12),
            ]),
          );
        });

        test('Stops at the period end when the next occurrence is past it', () {
          // The next Monday that is the 1st of a month after January 1, 2024
          // is April 1, 2024, past the period end used as the limit.
          final period = Period(
            start: DateTime(2024),
            end: DateTime(2024, 3, 31),
          );
          expect(
            period.getEveryDateTimeValues(
              const Every.intersection([
                EveryWeekday(Weekday.monday),
                EveryDueDayMonth(1),
              ]),
            ),
            orderedEquals([DateTime(2024)]),
          );
        });

        test('Returns empty when the first occurrence is past the end', () {
          final period = Period(
            start: DateTime(2024),
            end: DateTime(2024, 1, 31),
          );
          // No date is both a Monday and a Tuesday.
          expect(
            period.getEveryDateTimeValues(
              const Every.intersection([
                EveryWeekday(Weekday.monday),
                EveryWeekday(Weekday.tuesday),
              ]),
            ),
            isEmpty,
          );
        });
      });
    });
  });
}
