// ignore_for_file: prefer_const_constructors

import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

import '../src/date_time_match.dart';
import '../src/every_match.dart';

void main() {
  group('EveryDateValidatorUnion:', () {
    group('Constructor', () {
      group('Unnamed', () {
        test('Valid basic case', () {
          expect(
            EveryDateValidatorUnion([
              EveryDueDayMonth(1),
              EveryWeekday(Weekday.sunday),
            ]),
            isNotNull,
          );
        });
        test('Empty list doesnt throw', () {
          expect(
            EveryDateValidatorUnion<EveryDateValidator>([]),
            isNotNull,
          );
        });
        test('Single every is allowed', () {
          expect(
            EveryDateValidatorUnion([EveryDueDayMonth(1)]),
            isNotNull,
          );
        });
        test('Properties are set correctly', () {
          final everies = [
            EveryDueDayMonth(2),
            EveryWeekday(Weekday.friday),
          ];
          final union = EveryDateValidatorUnion(everies);
          expect(union.everies, equals(everies));
        });
      });
    });
    group('Methods', () {
      group('startDate', () {
        final everies = EveryDateValidatorUnion([
          EveryDueDayMonth(24),
          EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
        ]);

        test('Returns same date when input is valid', () {
          // September 24, 2022 is Saturday and 24th (valid for union).
          final september24th = DateTime(2022, DateTime.september, 24);
          expect(everies, startsAt(september24th).withInput(september24th));
        });
        test('Returns next valid date when input is invalid', () {
          // September 23, 2022 is Friday and 23rd (invalid for union).
          final september23rd = DateTime(2022, DateTime.september, 23);
          // September 24, 2022 is Saturday and 24th (valid for union).
          final expected = DateTime(2022, DateTime.september, 24);
          expect(everies, startsAt(expected).withInput(september23rd));
        });
      });

      group('next', () {
        final everies = EveryDateValidatorUnion([
          EveryDueDayMonth(24),
          EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
        ]);

        test('Always generates date after input', () {
          // September 17, 2022 is Saturday but not 24th.
          final september17th = DateTime(2022, DateTime.september, 17);
          expect(everies, nextIsAfter.withInput(september17th));
        });
        test('Generates next occurrence from valid date', () {
          // September 24, 2022 is Saturday and 24th (valid for union).
          final september24th = DateTime(2022, DateTime.september, 24);
          // October 1, 2022 is Saturday but not 24th (valid for union).
          final expected = DateTime(2022, DateTime.october);
          expect(everies, hasNext(expected).withInput(september24th));
        });
      });

      group('previous', () {
        final everies = EveryDateValidatorUnion([
          EveryDueDayMonth(24),
          EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
        ]);

        test('Always generates date before input', () {
          // September 23, 2022 is Friday and 23rd.
          final september23rd = DateTime(2022, DateTime.september, 23);
          expect(everies, previousIsBefore.withInput(september23rd));
        });
        test('Generates previous occurrence from valid date', () {
          // September 24, 2022 is Saturday and 24th (valid for union).
          final september24th = DateTime(2022, DateTime.september, 24);
          // September 17, 2022 is Saturday but not 24th (valid for union).
          final expected = DateTime(2022, DateTime.september, 17);
          expect(everies, hasPrevious(expected).withInput(september24th));
        });
      });
    });

    group('Explicit datetime tests:', () {
      test('24th OR not Saturday union calculation', () {
        final everies = EveryDateValidatorUnion([
          EveryDueDayMonth(24),
          EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
        ]);
        // September 17, 2022 is Saturday but not 24th (valid for union).
        final inputDate = DateTime(2022, DateTime.september, 17);
        // September 24, 2022 is Saturday and 24th (valid for union).
        final expected = DateTime(2022, DateTime.september, 24);

        expect(everies, hasNext(expected).withInput(inputDate));
      });

      test('Valid date returns same in startDate', () {
        final everies = EveryDateValidatorUnion([
          EveryDueDayMonth(24),
          EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
        ]);
        // September 24, 2022 is Saturday and 24th (valid for union).
        final validDate = DateTime(2022, DateTime.september, 24);

        expect(everies, startsAt(validDate).withInput(validDate));
      });

      test('Previous calculation within same month', () {
        final everies = EveryDateValidatorUnion([
          EveryDueDayMonth(24),
          EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
        ]);
        // September 24, 2022 is Saturday and 24th (valid for union).
        final inputDate = DateTime(2022, DateTime.september, 24);
        // September 17, 2022 is Saturday but not 24th (valid for union).
        final expected = DateTime(2022, DateTime.september, 17);

        expect(everies, hasPrevious(expected).withInput(inputDate));
      });

      test('Edge case: limit reached exception', () {
        final everies = EveryDateValidatorUnion([
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
        final everies = EveryDateValidatorUnion([
          EveryDueDayMonth(24),
          EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
        ]);
        // July 23, 2021 is Friday and 23rd.
        final inputDate = DateTime(2021, DateTime.july, 23);
        // July 24, 2021 is Saturday and 24th (valid for union).
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
        final everies = EveryDateValidatorUnion([
          EveryDueDayMonth(24),
          EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
        ]);
        final inputWithTime = DateTime(2022, 9, 17, 14, 30, 45, 123, 456);
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
        final everies = EveryDateValidatorUnion([
          EveryDueDayMonth(24),
          EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
        ]);
        final inputWithTime = DateTime.utc(2022, 9, 17, 14, 30, 45, 123, 456);
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
        final everies = EveryDateValidatorUnion([
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
        final everies = EveryDateValidatorUnion([
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
        final everies = EveryDateValidatorUnion([
          EveryDueDayMonth(24),
          EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
        ]);
        final inputDate = DateTime(2022, 9, 17);
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
        final everies = EveryDateValidatorUnion([
          EveryDueDayMonth(24),
          EveryDateValidatorDifference([EveryWeekday(Weekday.saturday)]),
        ]);
        final inputDate = DateTime.utc(2022, 9, 17);
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
      final everies1 = EveryDateValidatorUnion([
        EveryDueDayMonth(1),
        EveryWeekday(Weekday.sunday),
      ]);
      final everies2 = EveryDateValidatorUnion([
        EveryDueDayMonth(1),
        EveryWeekday(Weekday.sunday),
      ]);
      final everies3 = EveryDateValidatorUnion([
        EveryDueDayMonth(2),
        EveryWeekday(Weekday.sunday),
      ]);
      final everies4 = EveryDateValidatorUnion([
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
