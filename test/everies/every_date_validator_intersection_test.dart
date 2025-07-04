// ignore_for_file: prefer_const_constructors

import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

import '../src/date_time_match.dart';
import '../src/every_match.dart';

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
          expect(everies, startsAt(september24th).withInput(september24th));
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

    // REQUIRED: Time component preservation tests.
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
