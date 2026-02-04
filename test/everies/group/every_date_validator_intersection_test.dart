import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/everies/built_in/every_due_day_month.dart';
import 'package:due_date/src/everies/built_in/every_weekday.dart';
import 'package:due_date/src/everies/date_time_limit_reached_exception.dart';
import 'package:due_date/src/everies/every_date_validator.dart';
import 'package:due_date/src/everies/group/every_date_validator_difference.dart';
import 'package:due_date/src/everies/group/every_date_validator_intersection.dart';
import 'package:test/test.dart';

import '../../src/date_time_match.dart';
import '../../src/every_match.dart';

void main() {
  group('EveryDateValidatorIntersection:', () {
    group('Constructor', () {
      group('Unnamed', () {
        test('Valid basic case', () {
          expect(
            EveryDateValidatorIntersection([
              EveryDueDayMonth(1),
              EveryWeekday(Weekday.sunday),
            ]),
            isNotNull,
          );
        });
        test('Empty list doesnt throw', () {
          expect(
            EveryDateValidatorIntersection<EveryDateValidator>([]),
            isNotNull,
          );
        });
        test('Single every is allowed', () {
          expect(
            EveryDateValidatorIntersection([EveryDueDayMonth(1)]),
            isNotNull,
          );
        });
        test('Properties are set correctly', () {
          final everies = [
            EveryDueDayMonth(2),
            EveryWeekday(Weekday.friday),
          ];
          final intersection = EveryDateValidatorIntersection(everies);
          expect(intersection.everies, equals(everies));
        });
      });
    });
    group('Methods', () {
      group('startDate', () {
        final everies = EveryDateValidatorIntersection([
          EveryDueDayMonth(24),
          EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
        ]);

        test('Returns same date when input is valid', () {
          // September 24, 2022 is Saturday and 24th, but not Saturday.
          // (valid for intersection since 24th AND not Saturday).
          final september24th = DateTime(2022, DateTime.september, 24);
          expect(everies, startsAtSameDate.withInput(september24th));
        });
        test('Returns next valid date when input is invalid', () {
          // July 25, 2021 is Sunday and 25th.
          final july25th = DateTime(2021, DateTime.july, 25);
          // September 24, 2022 is Saturday and 24th, but not Saturday.
          final expected = DateTime(2022, DateTime.september, 24);
          expect(everies, startsAt(expected).withInput(july25th));
        });
      });

      group('next', () {
        final everies = EveryDateValidatorIntersection([
          EveryDueDayMonth(24),
          EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
        ]);

        test('Always generates date after input', () {
          // July 25, 2021 is Sunday and 25th.
          final july25th = DateTime(2021, DateTime.july, 25);
          expect(everies, nextIsAfter.withInput(july25th));
        });
        test('Generates next occurrence from valid date', () {
          // September 24, 2022 is Saturday and 24th, but not Saturday.
          final september24th = DateTime(2022, DateTime.september, 24);
          // December 24, 2022 is Saturday and 24th, but not Saturday.
          final expected = DateTime(2022, DateTime.december, 24);
          expect(everies, hasNext(expected).withInput(september24th));
        });
      });

      group('previous', () {
        final everies = EveryDateValidatorIntersection([
          EveryDueDayMonth(24),
          EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
        ]);

        test('Always generates date before input', () {
          // July 25, 2021 is Sunday and 25th.
          final july25th = DateTime(2021, DateTime.july, 25);
          expect(everies, previousIsBefore.withInput(july25th));
        });
        test('Generates previous occurrence from valid date', () {
          // September 24, 2022 is Saturday and 24th, but not Saturday.
          final september24th = DateTime(2022, DateTime.september, 24);
          // July 24, 2021 is Saturday and 24th, but not Saturday.
          final expected = DateTime(2021, DateTime.july, 24);
          expect(everies, hasPrevious(expected).withInput(september24th));
        });
      });
      group('endDate', () {
        final everies = EveryDateValidatorIntersection([
          EveryDueDayMonth(24),
          EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
        ]);

        test('Returns same date when input is valid', () {
          // September 24, 2022 is Saturday and 24th, but not Saturday.
          // (valid for intersection since 24th AND not Saturday).
          final september24th = DateTime(2022, DateTime.september, 24);
          expect(everies, endsAtSameDate.withInput(september24th));
        });
        test('Returns previous valid date when input is invalid', () {
          // July 25, 2021 is Sunday and 25th.
          final july25th = DateTime(2021, DateTime.july, 25);
          // September 24, 2022 is Saturday and 24th.
          final expected = DateTime(2021, DateTime.july, 24);
          expect(everies, endsAt(expected).withInput(july25th));
        });
      });
    });

    group('Explicit datetime tests:', () {
      test('24th AND not Saturday intersection calculation', () {
        final everies = EveryDateValidatorIntersection([
          EveryDueDayMonth(24),
          EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
        ]);
        // July 25, 2021 is Sunday and 25th.
        final inputDate = DateTime(2021, DateTime.july, 25);
        // September 24, 2022 is Saturday and 24th, but not Saturday.
        final expected = DateTime(2022, DateTime.september, 24);

        expect(everies, hasNext(expected).withInput(inputDate));
      });

      test('Valid date returns same in startDate', () {
        final everies = EveryDateValidatorIntersection([
          EveryDueDayMonth(24),
          EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
        ]);
        // September 24, 2022 is Saturday and 24th, but not Saturday.
        final validDate = DateTime(2022, DateTime.september, 24);

        expect(everies, startsAt(validDate).withInput(validDate));
      });

      test('Previous calculation across years', () {
        final everies = EveryDateValidatorIntersection([
          EveryDueDayMonth(24),
          EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
        ]);
        // September 24, 2022 is Saturday and 24th, but not Saturday.
        final inputDate = DateTime(2022, DateTime.september, 24);
        // July 24, 2021 is Saturday and 24th, but not Saturday.
        final expected = DateTime(2021, DateTime.july, 24);

        expect(everies, hasPrevious(expected).withInput(inputDate));
      });

      test('Edge case: limit reached exception', () {
        final everies = EveryDateValidatorIntersection([
          EveryDueDayMonth(24),
          EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
        ]);
        // July 22, 2021 is Thursday and 22nd.
        final inputDate = DateTime(2021, DateTime.july, 22);
        // July 23, 2021 is Friday and 23rd.
        final limit = DateTime(2021, DateTime.july, 23);

        expect(
          () => everies.next(inputDate, limit: limit),
          throwsA(isA<DateTimeLimitReachedException>()),
        );
      });

      test('Limit is exactly the expected date', () {
        final everies = EveryDateValidatorIntersection([
          EveryDueDayMonth(24),
          EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
        ]);
        // July 23, 2021 is Friday and 23rd.
        final inputDate = DateTime(2021, DateTime.july, 23);
        // July 24, 2021 is Saturday and 24th, but not Saturday.
        final expected = DateTime(2021, DateTime.july, 24);

        expect(
          everies,
          hasNext(expected).withInput(inputDate, limit: expected),
        );
      });
    });

    group('DateTimeLimitReachedException tests:', () {
      final everies = EveryDateValidatorIntersection([
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

          // Next valid date would be January 15, 2024 (Monday), which exceeds
          // limit.
          expect(
            () => everies.startDate(inputDate, limit: limit),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });

        test('Returns valid date when limit allows it', () {
          // January 10, 2024 is Wednesday.
          final inputDate = DateTime(2024, 1, 10);
          // January 15, 2024 is Monday and 15th.
          final expected = DateTime(2024, 1, 15);
          final limit = DateTime(2024, 1, 15);

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
          // February 18, 2024 is Sunday.
          final limit = DateTime(2024, 2, 18);

          // Next valid date would be February 19, 2024 (Monday), which exceeds
          // limit.
          expect(
            () => everies.next(inputDate, limit: limit),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });

        test('Returns valid next date when limit allows it', () {
          // January 10, 2024 is Saturday.
          final inputDate = DateTime(2024, 1, 10);
          // January 15, 2024 is Monday and 15th.
          final expected = DateTime(2024, 1, 15);
          final limit = DateTime(2024, 1, 19);

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
          // February 20, 2024 is Tuesday.
          final limit = DateTime(2024, 2, 20);

          // Previous valid date would be February 19, 2024 (Monday), which is
          // before limit.
          expect(
            () => everies.previous(inputDate, limit: limit),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });

        test('Returns valid previous date when limit allows it', () {
          // March 20, 2024 is Wednesday.
          final inputDate = DateTime(2024, 3, 20);
          // January 15, 2024 is Monday and 15th.
          final expected = DateTime(2024, 1, 15);
          final limit = DateTime(2024, 1, 10);

          expect(everies.previous(inputDate, limit: limit), equals(expected));
        });

        test('Throws when result from valid dates violates limit', () {
          // Use two equal everies for Monday to ensure predictable
          // intersection.
          final mondayEveries = EveryDateValidatorIntersection([
            EveryWeekday(Weekday.monday),
            EveryWeekday(Weekday.monday),
          ]);
          // January 15, 2024 is Monday.
          final inputDate = DateTime(2024, 1, 15);
          // January 9, 2024 is Tuesday.
          final limit = DateTime(2024, 1, 9);

          // Both everies will find January 8, 2024 (Monday) as previous,
          // but this result is after the limit, causing the exception.
          expect(
            () => mondayEveries.previous(inputDate, limit: limit),
            throwsA(isA<DateTimeLimitReachedException>()),
          );
        });
      });

      group('Edge cases with empty intersection:', () {
        final emptyEveries =
            EveryDateValidatorIntersection<EveryDateValidator>([]);

        test('Empty intersection startDate with limit returns input', () {
          final inputDate = DateTime(2024, 1, 15);
          final limit = DateTime(2024, 1, 20);

          expect(
            emptyEveries.startDate(inputDate, limit: limit),
            equals(inputDate),
          );
        });

        test('Empty intersection next with limit returns input', () {
          final inputDate = DateTime(2024, 1, 15);
          final limit = DateTime(2024, 1, 20);

          expect(emptyEveries.next(inputDate, limit: limit), equals(inputDate));
        });

        test('Empty intersection previous with limit returns input', () {
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

    group('Time component preservation:', () {
      test('Maintains time components in local DateTime', () {
        final everies = EveryDateValidatorIntersection([
          EveryDueDayMonth(24),
          EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
        ]);
        final inputWithTime = DateTime(2021, 7, 25, 14, 30, 45, 123, 456);
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
        final everies = EveryDateValidatorIntersection([
          EveryDueDayMonth(24),
          EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
        ]);
        final inputWithTime = DateTime.utc(2021, 7, 25, 14, 30, 45, 123, 456);
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
        final everies = EveryDateValidatorIntersection([
          EveryDueDayMonth(24),
          EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
        ]);
        final inputWithTime = DateTime(2022, 9, 24, 9, 15, 30, 500, 250);
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
        final everies = EveryDateValidatorIntersection([
          EveryDueDayMonth(24),
          EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
        ]);
        final inputWithTime = DateTime.utc(2022, 9, 24, 9, 15, 30, 500, 250);
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
        final everies = EveryDateValidatorIntersection([
          EveryDueDayMonth(24),
          EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
        ]);
        final inputDate = DateTime(2021, 7, 25);
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
        final everies = EveryDateValidatorIntersection([
          EveryDueDayMonth(24),
          EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
        ]);
        final inputDate = DateTime.utc(2021, 7, 25);
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
      final everies1 = EveryDateValidatorIntersection([
        EveryDueDayMonth(1),
        EveryWeekday(Weekday.sunday),
      ]);
      final everies2 = EveryDateValidatorIntersection([
        EveryDueDayMonth(1),
        EveryWeekday(Weekday.sunday),
      ]);
      final everies3 = EveryDateValidatorIntersection([
        EveryDueDayMonth(2),
        EveryWeekday(Weekday.sunday),
      ]);
      final everies4 = EveryDateValidatorIntersection([
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
