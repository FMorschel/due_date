import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

import '../src/date_time_match.dart';
import '../src/every_match.dart';

void main() {
  group('EveryDateValidatorDifference:', () {
    group('Constructor', () {
      group('Unnamed', () {
        test('Valid basic case', () {
          expect(
            EveryDateValidatorDifference([
              EveryDueDayMonth(1),
              EveryWeekday(Weekday.sunday),
            ]),
            isNotNull,
          );
        });
        test('Empty list doesnt throw', () {
          expect(
            EveryDateValidatorDifference<EveryDateValidator>([]),
            isNotNull,
          );
        });
        test('Single every is allowed', () {
          expect(
            EveryDateValidatorDifference([EveryDueDayMonth(1)]),
            isNotNull,
          );
        });
        test('Properties are set correctly', () {
          final everies = [
            EveryDueDayMonth(2),
            EveryWeekday(Weekday.friday),
          ];
          final difference = EveryDateValidatorDifference(everies);
          expect(difference.everies, equals(everies));
        });
      });
    });
    group('Methods', () {
      group('startDate', () {
        final everies = EveryDateValidatorDifference([
          EveryDueDayMonth(24),
          EveryWeekday(Weekday.saturday),
        ]);

        test('Returns same date when input is valid', () {
          // October 1, 2022 is Saturday but not 24th, so it's valid for
          // difference.
          final october1st = DateTime(2022, DateTime.october);
          expect(everies, startsAt(october1st).withInput(october1st));
        });
        test('Returns next valid date when input is invalid', () {
          // September 24, 2022 is Saturday and 24th, so both match (invalid for
          // difference).
          final september24th = DateTime(2022, DateTime.september, 24);
          final expected = DateTime(2022, DateTime.october);
          expect(everies, startsAt(expected).withInput(september24th));
        });
      });

      group('next', () {
        final everies = EveryDateValidatorDifference([
          EveryDueDayMonth(24),
          EveryWeekday(Weekday.saturday),
        ]);

        test('Always generates date after input', () {
          // September 23, 2022 is Friday and 23rd.
          final september23rd = DateTime(2022, DateTime.september, 23);
          expect(everies, nextIsAfter.withInput(september23rd));
        });
        test('Generates next occurrence from valid date', () {
          // October 1, 2022 is Saturday but not 24th.
          final october1st = DateTime(2022, DateTime.october);
          final expected = DateTime(2022, DateTime.october, 8);
          expect(everies, hasNext(expected).withInput(october1st));
        });
      });

      group('previous', () {
        final everies = EveryDateValidatorDifference([
          EveryDueDayMonth(24),
          EveryWeekday(Weekday.saturday),
        ]);

        test('Always generates date before input', () {
          // September 25, 2022 is Sunday and 25th.
          final september25th = DateTime(2022, DateTime.september, 25);
          expect(everies, previousIsBefore.withInput(september25th));
        });
        test('Generates previous occurrence from valid date', () {
          // October 1, 2022 is Saturday but not 24th.
          final october1st = DateTime(2022, DateTime.october);
          final expected = DateTime(2022, DateTime.september, 17);
          expect(everies, hasPrevious(expected).withInput(october1st));
        });
      });
    });

    group('Explicit datetime tests:', () {
      test('24th or Saturday difference calculation', () {
        final everies = EveryDateValidatorDifference([
          EveryDueDayMonth(24),
          EveryWeekday(Weekday.saturday),
        ]);
        // September 23, 2022 is Friday and 23rd.
        final inputDate = DateTime(2022, DateTime.september, 23);
        // October 1, 2022 is Saturday but not 24th.
        final expected = DateTime(2022, DateTime.october);

        expect(everies, hasNext(expected).withInput(inputDate));
      });

      test('Edge case: when all validators match (invalid for difference)', () {
        final everies = EveryDateValidatorDifference([
          EveryDueDayMonth(24),
          EveryWeekday(Weekday.saturday),
        ]);
        // September 24, 2022 is Saturday and 24th.
        final inputDate = DateTime(2022, DateTime.september, 24);
        // October 1, 2022 is Saturday but not 24th.
        final expected = DateTime(2022, DateTime.october);

        expect(everies, hasNext(expected).withInput(inputDate));
      });

      test('Edge case: when no validators match (invalid for difference)', () {
        final everies = EveryDateValidatorDifference([
          EveryDueDayMonth(24),
          EveryWeekday(Weekday.saturday),
        ]);
        // September 23, 2022 is Friday and 23rd.
        final inputDate = DateTime(2022, DateTime.september, 23);
        // October 1, 2022 is Saturday but not 24th.
        final expected = DateTime(2022, DateTime.october);

        expect(everies, hasNext(expected).withInput(inputDate));
      });

      test('Previous calculation across months', () {
        final everies = EveryDateValidatorDifference([
          EveryDueDayMonth(24),
          EveryWeekday(Weekday.saturday),
        ]);
        // October 2, 2022 is Sunday and 2nd.
        final inputDate = DateTime(2022, DateTime.october, 2);
        // October 1, 2022 is Saturday but not 24th.
        final expected = DateTime(2022, DateTime.october);

        expect(everies, hasPrevious(expected).withInput(inputDate));
      });

      test('Limit is passed through to underlying Every implementations', () {
        final everies = EveryDateValidatorDifference([
          EveryDueDayMonth(24),
          EveryWeekday(Weekday.saturday),
        ]);
        // September 23, 2022 is Friday and 23rd.
        final inputDate = DateTime(2022, DateTime.september, 23);
        // October 1, 2022 is Saturday but not 24th.
        final expectedDate = DateTime(2022, DateTime.october);

        expect(
          everies,
          hasNext(expectedDate).withInput(inputDate, limit: expectedDate),
        );
      });

      test('Limit constraint respected in next method', () {
        final everies = EveryDateValidatorDifference([
          EveryDueDayMonth(24),
          EveryWeekday(Weekday.saturday),
        ]);
        // September 23, 2022 is Friday and 23rd.
        final inputDate = DateTime(2022, DateTime.september, 23);
        // September 30, 2022 is before expected October 1st.
        final limitDate = DateTime(2022, DateTime.september, 30);

        expect(
          () => everies.next(inputDate, limit: limitDate),
          throwsA(isA<DateTimeLimitReachedException>()),
        );
      });
    });

    group('DateTimeLimitReachedException tests:', () {
      final everies = EveryDateValidatorDifference([
        EveryDueDayMonth(15),
        EveryWeekday(Weekday.monday),
      ]);

      group('startDate method:', () {
        test('Throws when input date is after limit', () {
          // January 20, 2024 is Saturday.
          final inputDate = DateTime(2024, 1, 20);
          // January 19, 2024 is Friday.
          final limit = DateTime(2024, 1, 19);

          expect(
            () => everies.startDate(inputDate, limit: limit),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });

        test('Throws when input date equals limit', () {
          // January 20, 2024 is Saturday.
          final inputDate = DateTime(2024, 1, 20);
          final limit = DateTime(2024, 1, 20);

          expect(
            () => everies.startDate(inputDate, limit: limit),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });

        test('Throws when calculated result would exceed limit', () {
          // January 10, 2024 is Wednesday.
          final inputDate = DateTime(2024, 1, 10);
          // January 14, 2024 is Sunday.
          final limit = DateTime(2024, 1, 14);

          // Next valid date would be January 16, 2024 (Tuesday), which exceeds
          // limit.
          expect(
            () => everies.startDate(inputDate, limit: limit),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });

        test('Returns valid date when limit allows it', () {
          // January 10, 2024 is Wednesday.
          final inputDate = DateTime(2024, 1, 10);
          final expected = DateTime(2024, 1, 22);
          final limit = DateTime(2024, 1, 23);

          expect(everies.startDate(inputDate, limit: limit), equals(expected));
        });
      });

      group('next method:', () {
        test('Throws when input date is after limit', () {
          // February 20, 2024 is Tuesday.
          final inputDate = DateTime(2024, 2, 20);
          // February 19, 2024 is Monday.
          final limit = DateTime(2024, 2, 19);

          expect(
            () => everies.next(inputDate, limit: limit),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });

        test('Throws when input date equals limit', () {
          // February 15, 2024 is Thursday.
          final inputDate = DateTime(2024, 2, 15);
          final limit = DateTime(2024, 2, 15);

          expect(
            () => everies.next(inputDate, limit: limit),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });

        test('Throws when calculated next result would exceed limit', () {
          // February 10, 2024 is Saturday.
          final inputDate = DateTime(2024, 2, 10);
          final limit = DateTime(2024, 2, 11);

          expect(
            () => everies.next(inputDate, limit: limit),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });

        test('Returns valid next date when limit allows it', () {
          // January 10, 2024 is Wednesday.
          final inputDate = DateTime(2024, 1, 10);
          final expected = DateTime(2024, 1, 22);
          final limit = DateTime(2024, 1, 23);

          expect(everies.next(inputDate, limit: limit), equals(expected));
        });
      });

      group('previous method:', () {
        test('Throws when input date is before limit', () {
          // March 10, 2024 is Sunday.
          final inputDate = DateTime(2024, 3, 10);
          // March 11, 2024 is Monday.
          final limit = DateTime(2024, 3, 11);

          expect(
            () => everies.previous(inputDate, limit: limit),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });

        test('Throws when input date equals limit', () {
          // March 15, 2024 is Friday.
          final inputDate = DateTime(2024, 3, 15);
          final limit = DateTime(2024, 3, 15);

          expect(
            () => everies.previous(inputDate, limit: limit),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });

        test('Throws when calculated previous result would be before limit',
            () {
          // March 20, 2024 is Wednesday.
          final inputDate = DateTime(2024, 3, 20);
          final limit = DateTime(2024, 3, 19);

          // Previous valid date would be February 14, 2024 (Wednesday), which
          // is before limit.
          expect(
            () => everies.previous(inputDate, limit: limit),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });

        test('Returns valid previous date when limit allows it', () {
          // March 20, 2024 is Wednesday.
          final inputDate = DateTime(2024, 3, 20);
          final expected = DateTime(2024, 3, 18);
          final limit = DateTime(2024, 1, 10);

          expect(everies.previous(inputDate, limit: limit), equals(expected));
        });

        test('Throws when result from valid dates violates limit', () {
          // Use two equal everies for Tuesday to ensure predictable
          // difference.
          final tuesdayEveries = EveryDateValidatorDifference([
            EveryWeekday(Weekday.tuesday),
          ]);
          // January 16, 2024 is Tuesday.
          final inputDate = DateTime(2024, 1, 16);
          // January 10, 2024 is Wednesday.
          final limit = DateTime(2024, 1, 10);

          // Previous would be January 9, 2024 (Tuesday), which is before limit.
          expect(
            () => tuesdayEveries.previous(inputDate, limit: limit),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });
      });

      group('Edge cases with empty difference:', () {
        final emptyEveries =
            EveryDateValidatorDifference<EveryDateValidator>([]);

        test('Empty difference startDate with limit returns input', () {
          final inputDate = DateTime(2024, 1, 15);
          final limit = DateTime(2024, 1, 20);

          expect(
            emptyEveries.startDate(inputDate, limit: limit),
            equals(inputDate),
          );
        });

        test('Empty difference next with limit returns input', () {
          final inputDate = DateTime(2024, 1, 15);
          final limit = DateTime(2024, 1, 20);

          expect(emptyEveries.next(inputDate, limit: limit), equals(inputDate));
        });

        test('Empty difference previous with limit returns input', () {
          final inputDate = DateTime(2024, 1, 15);
          final limit = DateTime(2024, 1, 10);

          expect(
            emptyEveries.previous(inputDate, limit: limit),
            equals(inputDate),
          );
        });
      });

      group('UTC DateTime with limits:', () {
        test('Throws DateTimeLimitReachedException with UTC DateTimes in next',
            () {
          // January 10, 2024 UTC.
          final inputDate = DateTime.utc(2024, 1, 10);
          // January 14, 2024 UTC.
          final limit = DateTime.utc(2024, 1, 14);

          expect(
            () => everies.next(inputDate, limit: limit),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });

        test(
            'Throws DateTimeLimitReachedException with UTC DateTimes in '
            'previous', () {
          // March 10, 2024 UTC.
          final inputDate = DateTime.utc(2024, 3, 10);
          // March 11, 2024 UTC.
          final limit = DateTime.utc(2024, 3, 11);

          expect(
            () => everies.previous(inputDate, limit: limit),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });
      });
    });

    // REQUIRED: Time component preservation tests.
    group('Time component preservation:', () {
      test('Maintains time components in local DateTime', () {
        final everies = EveryDateValidatorDifference([
          EveryDueDayMonth(24),
          EveryWeekday(Weekday.saturday),
        ]);
        final inputWithTime = DateTime(2022, 9, 23, 14, 30, 45, 123, 456);
        final result = everies.next(inputWithTime);

        // Should preserve time components.
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
        expect(result, isLocalDateTime);
      });

      test('Maintains time components in UTC DateTime', () {
        final everies = EveryDateValidatorDifference([
          EveryDueDayMonth(24),
          EveryWeekday(Weekday.saturday),
        ]);
        final inputWithTime = DateTime.utc(2022, 9, 23, 14, 30, 45, 123, 456);
        final result = everies.next(inputWithTime);

        // Should preserve time components and UTC flag.
        expect(result.hour, equals(14));
        expect(result.minute, equals(30));
        expect(result.second, equals(45));
        expect(result.millisecond, equals(123));
        expect(result.microsecond, equals(456));
        expect(result, isUtcDateTime);
      });

      test('Previous maintains time components in local DateTime', () {
        final everies = EveryDateValidatorDifference([
          EveryDueDayMonth(24),
          EveryWeekday(Weekday.saturday),
        ]);
        final inputWithTime = DateTime(2022, 10, 2, 9, 15, 30, 500, 250);
        final result = everies.previous(inputWithTime);

        // Should preserve time components.
        expect(result.hour, equals(9));
        expect(result.minute, equals(15));
        expect(result.second, equals(30));
        expect(result.millisecond, equals(500));
        expect(result.microsecond, equals(250));
        expect(result, isLocalDateTime);
      });

      test('Previous maintains time components in UTC DateTime', () {
        final everies = EveryDateValidatorDifference([
          EveryDueDayMonth(24),
          EveryWeekday(Weekday.saturday),
        ]);
        final inputWithTime = DateTime.utc(2022, 10, 2, 9, 15, 30, 500, 250);
        final result = everies.previous(inputWithTime);

        // Should preserve time components and UTC flag.
        expect(result.hour, equals(9));
        expect(result.minute, equals(15));
        expect(result.second, equals(30));
        expect(result.millisecond, equals(500));
        expect(result.microsecond, equals(250));
        expect(result, isUtcDateTime);
      });

      test('Normal generation with date-only input (local)', () {
        final everies = EveryDateValidatorDifference([
          EveryDueDayMonth(24),
          EveryWeekday(Weekday.saturday),
        ]);
        final inputDate = DateTime(2022, 9, 23);
        final result = everies.next(inputDate);

        // Should maintain date-only format.
        expect(result.hour, equals(0));
        expect(result.minute, equals(0));
        expect(result.second, equals(0));
        expect(result.millisecond, equals(0));
        expect(result.microsecond, equals(0));
        expect(result, isLocalDateTime);
      });

      test('Normal generation with date-only input (UTC)', () {
        final everies = EveryDateValidatorDifference([
          EveryDueDayMonth(24),
          EveryWeekday(Weekday.saturday),
        ]);
        final inputDate = DateTime.utc(2022, 9, 23);
        final result = everies.next(inputDate);

        // Should maintain date-only format and UTC flag.
        expect(result.hour, equals(0));
        expect(result.minute, equals(0));
        expect(result.second, equals(0));
        expect(result.millisecond, equals(0));
        expect(result.microsecond, equals(0));
        expect(result, isUtcDateTime);
      });
    });

    group('Equality', () {
      final everies1 = EveryDateValidatorDifference([
        EveryDueDayMonth(1),
        EveryWeekday(Weekday.sunday),
      ]);
      final everies2 = EveryDateValidatorDifference([
        EveryDueDayMonth(1),
        EveryWeekday(Weekday.sunday),
      ]);
      final everies3 = EveryDateValidatorDifference([
        EveryDueDayMonth(2),
        EveryWeekday(Weekday.sunday),
      ]);
      final everies4 = EveryDateValidatorDifference([
        EveryWeekday(Weekday.sunday),
        EveryDueDayMonth(1),
      ]);

      test('Same instance', () {
        expect(everies1, equals(everies1));
      });
      test('Same everies, same order', () {
        expect(everies1, equals(everies2));
      });
      test('Different everies', () {
        expect(everies1, isNot(equals(everies3)));
      });
      test('Same everies, different order', () {
        expect(everies1, isNot(equals(everies4)));
      });
      test('Hash code consistency', () {
        expect(everies1.hashCode, equals(everies2.hashCode));
      });
    });
  });
}
