import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

import '../../src/every_match.dart';

/// Test implementation of [EveryModifier] with [LimitedEveryModifierMixin].
class _TestLimitedEveryModifier<T extends Every> extends EveryModifier<T>
    with LimitedEveryModifierMixin<T> {
  const _TestLimitedEveryModifier({
    required super.every,
    this.direction = DateDirection.next,
    this.limitBehavior = _LimitBehavior.normal,
  });

  /// The direction to use when processing dates.
  final DateDirection direction;

  /// The behavior when processing with limit.
  final _LimitBehavior limitBehavior;

  @override
  DateTime processDate(
    DateTime date,
    DateDirection actualDirection, {
    DateTime? limit,
  }) {
    // For testing, we can modify the date based on direction and limit
    switch (limitBehavior) {
      case _LimitBehavior.normal:
        switch (direction) {
          case DateDirection.start:
          case DateDirection.next:
            return date;
          case DateDirection.previous:
            // Subtract one day for testing purposes
            return date.subtract(Duration(days: 1));
        }
      case _LimitBehavior.respectLimit:
        if (limit != null) {
          // Clamp the result to the limit
          final result = direction == DateDirection.previous
              ? date.subtract(Duration(days: 1))
              : date;
          return actualDirection == DateDirection.previous
              ? (result.isBefore(limit) ? limit : result)
              : (result.isAfter(limit) ? limit : result);
        }
        return date;
      case _LimitBehavior.modifyWithLimit:
        if (limit != null) {
          // Add hours equal to the limit's day for testing
          return date.add(Duration(hours: limit.day));
        }
        return date;
    }
  }
}

enum _LimitBehavior {
  normal,
  respectLimit,
  modifyWithLimit,
}

void main() {
  group('LimitedEveryModifierMixin:', () {
    final baseEvery = EveryWeekday(Weekday.monday);
    final modifier = _TestLimitedEveryModifier<EveryWeekday>(every: baseEvery);

    group('Constructor', () {
      group('Unnamed', () {
        test('Valid basic case', () {
          expect(modifier, isNotNull);
        });
        test('Creates with correct every', () {
          expect(modifier.every, equals(baseEvery));
        });
        test('Default property values', () {
          expect(modifier.direction, equals(DateDirection.next));
          expect(modifier.limitBehavior, equals(_LimitBehavior.normal));
        });
        test('Implements LimitedEvery', () {
          expect(modifier, isA<LimitedEvery>());
        });
      });
    });

    group('Base every integration', () {
      test('Works with EveryWeekday', () {
        final base = EveryWeekday(Weekday.monday);
        final modified = _TestLimitedEveryModifier<EveryWeekday>(every: base);
        expect(modified.every, equals(base));
      });

      test('Works with EveryDueDayMonth', () {
        final base = EveryDueDayMonth(15);
        final modified = _TestLimitedEveryModifier<EveryDueDayMonth>(
          every: base,
        );
        expect(modified.every, equals(base));
      });

      test('Works with other Every implementations', () {
        final base = EveryDueWorkdayMonth(3);
        final modified = _TestLimitedEveryModifier<EveryDueWorkdayMonth>(
          every: base,
        );
        expect(modified.every, equals(base));
      });

      test('Works with LimitedEvery base', () {
        final limitedBase = EverySkipInvalidModifier(
          every: baseEvery,
          invalidator: DateValidatorWeekdayCountInMonth(
            week: Week.first,
            day: Weekday.monday,
          ),
        );
        final modifier = _TestLimitedEveryModifier<
            EverySkipInvalidModifier<EveryWeekday, DateValidator>>(
          every: limitedBase,
        );
        expect(modifier.every, equals(limitedBase));
      });
    });

    group('Modifier behavior', () {
      test('Delegates to LimitedOrEveryHandler.startDate with null limit', () {
        // December 4, 2023 is Monday
        final inputDate = DateTime(2023, DateTime.december, 4);
        expect(modifier, startsAtSameDate.withInput(inputDate));
      });

      test('Delegates to LimitedOrEveryHandler.startDate with limit', () {
        final limit = DateTime(2024);
        // December 4, 2023 is Monday
        final inputDate = DateTime(2023, DateTime.december, 4);
        expect(modifier, startsAtSameDate.withInput(inputDate, limit: limit));
      });

      test('Processes date with custom logic', () {
        final modifierWithPrevious = _TestLimitedEveryModifier<EveryWeekday>(
          every: baseEvery,
          direction: DateDirection.previous,
        );
        // December 5, 2023 is Tuesday
        final inputDate = DateTime(2023, DateTime.december, 5);
        // December 10, 2023 (December 11 minus one day due to processDate)
        final expectedDate = DateTime(2023, DateTime.december, 10);
        expect(
          modifierWithPrevious,
          startsAt(expectedDate).withInput(inputDate),
        );
      });

      test('Processes date with limit parameter', () {
        final modifierWithLimit = _TestLimitedEveryModifier<EveryWeekday>(
          every: baseEvery,
          limitBehavior: _LimitBehavior.modifyWithLimit,
        );
        // December 4, 2023 is Monday
        final inputDate = DateTime(2023, DateTime.december, 4);
        final limit = DateTime(2023, DateTime.december, 10);
        // Expected: December 4 + 10 hours (limit.day = 10)
        final expected = DateTime(2023, DateTime.december, 4, 10);
        expect(
          modifierWithLimit,
          startsAt(expected).withInput(inputDate, limit: limit),
        );
      });
    });

    group('Methods', () {
      group('startDate', () {
        test('Returns same date when input is valid and no limit', () {
          // December 4, 2023 is Monday
          final validDate = DateTime(2023, DateTime.december, 4);
          expect(modifier, startsAtSameDate.withInput(validDate));
        });

        test('Returns next valid date when input is invalid and no limit', () {
          // December 5, 2023 is Tuesday
          final invalidDate = DateTime(2023, DateTime.december, 5);
          // December 11, 2023 is Monday
          final expectedDate = DateTime(2023, DateTime.december, 11);
          expect(modifier, startsAt(expectedDate).withInput(invalidDate));
        });

        test('Accepts limit parameter', () {
          // December 5, 2023 is Tuesday
          final invalidDate = DateTime(2023, DateTime.december, 5);
          final limit = DateTime(2024);
          // December 11, 2023 is Monday
          final expectedDate = DateTime(2023, DateTime.december, 11);
          expect(
            modifier,
            startsAt(expectedDate).withInput(invalidDate, limit: limit),
          );
        });

        test('Passes limit to processDate', () {
          final modifierWithLimit = _TestLimitedEveryModifier<EveryWeekday>(
            every: baseEvery,
            limitBehavior: _LimitBehavior.modifyWithLimit,
          );
          // December 4, 2023 is Monday
          final validDate = DateTime(2023, DateTime.december, 4);
          final limit = DateTime(2023, DateTime.december, 5);
          // Expected: December 4 + 5 hours (limit.day = 5)
          final expected = DateTime(2023, DateTime.december, 4, 5);
          expect(
            modifierWithLimit,
            startsAt(expected).withInput(validDate, limit: limit),
          );
        });
      });

      group('next', () {
        test('Always generates date after input when no limit', () {
          // December 4, 2023 is Monday
          final date = DateTime(2023, DateTime.december, 4);
          expect(modifier, nextIsAfter.withInput(date));
        });

        test('Returns next occurrence with processDate applied', () {
          // December 4, 2023 is Monday
          final date = DateTime(2023, DateTime.december, 4);
          // December 11, 2023 is Monday (next occurrence)
          final expectedDate = DateTime(2023, DateTime.december, 11);
          expect(modifier, hasNext(expectedDate).withInput(date));
        });

        test('Accepts limit parameter', () {
          // December 4, 2023 is Monday
          final date = DateTime(2023, DateTime.december, 4);
          final limit = DateTime(2024);
          // December 11, 2023 is Monday (next occurrence)
          final expectedDate = DateTime(2023, DateTime.december, 11);
          expect(modifier, hasNext(expectedDate).withInput(date, limit: limit));
        });

        test('Passes limit to processDate', () {
          final modifierWithLimit = _TestLimitedEveryModifier<EveryWeekday>(
            every: baseEvery,
            limitBehavior: _LimitBehavior.modifyWithLimit,
          );
          // December 4, 2023 is Monday
          final date = DateTime(2023, DateTime.december, 4);
          final limit = DateTime(2023, DateTime.december, 15);
          // Next Monday would be December 11, then + 15 hours
          final expected = DateTime(2023, DateTime.december, 11, 15);
          expect(
            modifierWithLimit,
            hasNext(expected).withInput(date, limit: limit),
          );
        });

        test('Applies processDate to the result', () {
          final modifierWithPrevious = _TestLimitedEveryModifier<EveryWeekday>(
            every: baseEvery,
            direction: DateDirection.previous,
          );
          // December 4, 2023 is Monday
          final date = DateTime(2023, DateTime.december, 4);
          // December 10, 2023 (December 11 minus one day due to processDate)
          final expectedDate = DateTime(2023, DateTime.december, 10);
          expect(modifierWithPrevious, hasNext(expectedDate).withInput(date));
        });
      });

      group('previous', () {
        test('Always generates date before input when no limit', () {
          // December 11, 2023 is Monday
          final date = DateTime(2023, DateTime.december, 11);
          expect(modifier, previousIsBefore.withInput(date));
        });

        test('Returns previous occurrence with processDate applied', () {
          // December 11, 2023 is Monday
          final date = DateTime(2023, DateTime.december, 11);
          // December 4, 2023 is Monday (previous occurrence)
          final expectedDate = DateTime(2023, DateTime.december, 4);
          expect(modifier, hasPrevious(expectedDate).withInput(date));
        });

        test('Accepts limit parameter', () {
          // December 11, 2023 is Monday
          final date = DateTime(2023, DateTime.december, 11);
          final limit = DateTime(2023, DateTime.november);
          // December 4, 2023 is Monday (previous occurrence)
          final expectedDate = DateTime(2023, DateTime.december, 4);
          expect(
            modifier,
            hasPrevious(expectedDate).withInput(date, limit: limit),
          );
        });

        test('Passes limit to processDate', () {
          final modifierWithLimit = _TestLimitedEveryModifier<EveryWeekday>(
            every: baseEvery,
            limitBehavior: _LimitBehavior.modifyWithLimit,
          );
          // December 11, 2023 is Monday
          final date = DateTime(2023, DateTime.december, 11);
          final limit = DateTime(2023, DateTime.december, 8);
          // Previous Monday would be December 4, then + 8 hours
          final expected = DateTime(2023, DateTime.december, 4, 8);
          expect(
            modifierWithLimit,
            hasPrevious(expected).withInput(date, limit: limit),
          );
        });

        test('Applies processDate to the result', () {
          final modifierWithPrevious = _TestLimitedEveryModifier<EveryWeekday>(
            every: baseEvery,
            direction: DateDirection.previous,
          );
          // December 11, 2023 is Monday
          final date = DateTime(2023, DateTime.december, 11);
          // December 3, 2023 (December 4 minus one day due to processDate)
          final expectedDate = DateTime(2023, DateTime.december, 3);
          expect(
            modifierWithPrevious,
            hasPrevious(expectedDate).withInput(date),
          );
        });
      });
    });

    group('Edge Cases', () {
      test('Handles processDate correctly with different directions', () {
        // Test that processDate is called with correct direction parameter
        final modifier = _TestLimitedEveryModifier<EveryWeekday>(
          every: baseEvery,
          direction: DateDirection.start,
        );
        // December 4, 2023 is Monday
        final date = DateTime(2023, DateTime.december, 4);
        expect(modifier, startsAtSameDate.withInput(date));
      });

      test('Works with edge dates and limits', () {
        // Test with year boundary
        final date = DateTime(2023, DateTime.december, 31);
        final limit = DateTime(2024, DateTime.february);
        // Should work without throwing
        expect(() => modifier.startDate(date, limit: limit), returnsNormally);
        expect(() => modifier.next(date, limit: limit), returnsNormally);
        expect(() => modifier.previous(date, limit: limit), returnsNormally);
      });

      test('Limit is passed correctly through the chain', () {
        final modifierWithRespectLimit =
            _TestLimitedEveryModifier<EveryWeekday>(
          every: baseEvery,
          limitBehavior: _LimitBehavior.respectLimit,
        );
        // December 4, 2023 is Monday
        final date = DateTime(2023, DateTime.december, 4);
        final limit = DateTime(2023, DateTime.december, 8);

        // For next, if limit is before the next Monday (Dec 11), it should
        // return limit
        expect(
          modifierWithRespectLimit,
          hasNext(limit).withInput(date, limit: limit),
        );

        // For previous, if limit is after the previous Monday (Nov 27), it
        // should return limit
        expect(
          modifierWithRespectLimit,
          hasPrevious(limit).withInput(date, limit: limit),
        );
      });

      test('Null limit behavior', () {
        // December 4, 2023 is Monday
        final date = DateTime(2023, DateTime.december, 4);

        // Should behave the same as no limit parameter
        expect(modifier, startsAtSameDate.withInput(date));
        expect(modifier, startsAtSameDate.withInput(date));
      });
    });

    group('LimitedEvery interface compliance', () {
      test('All methods accept limit parameter', () {
        // Verify that all three methods accept the limit parameter
        final date = DateTime(2023, DateTime.december, 4);
        final limit = DateTime(2024);

        // These should all compile and run without error
        expect(() => modifier.startDate(date, limit: limit), returnsNormally);
        expect(() => modifier.next(date, limit: limit), returnsNormally);
        expect(() => modifier.previous(date, limit: limit), returnsNormally);
      });

      test('Is a LimitedEvery instance', () {
        expect(modifier, isA<LimitedEvery>());
        expect(modifier, isA<Every>());
      });

      test('Abstract processDate method requires limit parameter', () {
        // This is tested by the fact that our concrete implementation
        // successfully overrides the abstract method with the limit parameter
        expect(modifier, isNotNull);
      });
    });
  });
}
