// ignore_for_file: prefer_const_constructors

import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

import '../../src/every_match.dart';

/// Test implementation of [EveryModifier] with [EveryModifierMixin].
class _TestEveryModifier<T extends Every> extends EveryModifier<T>
    with EveryModifierMixin<T> {
  const _TestEveryModifier({
    required super.every,
    this.direction = DateDirection.next,
  });

  /// The direction to use when processing dates.
  final DateDirection direction;

  @override
  DateTime processDate(DateTime date, DateDirection actualDirection) {
    // For testing, we can modify the date based on direction
    // This is a simple test implementation
    switch (direction) {
      case DateDirection.start:
      case DateDirection.next:
        return date;
      case DateDirection.previous:
        // Subtract one day for testing purposes
        return date.subtract(Duration(days: 1));
    }
  }
}

void main() {
  group('EveryModifierMixin:', () {
    final baseEvery = EveryWeekday(Weekday.monday);
    final modifier = _TestEveryModifier<EveryWeekday>(every: baseEvery);

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
        });
      });
    });

    group('Base every integration', () {
      test('Works with EveryWeekday', () {
        final base = EveryWeekday(Weekday.monday);
        final modified = _TestEveryModifier<EveryWeekday>(every: base);
        expect(modified.every, equals(base));
      });

      test('Works with EveryDueDayMonth', () {
        final base = EveryDueDayMonth(15);
        final modified = _TestEveryModifier<EveryDueDayMonth>(every: base);
        expect(modified.every, equals(base));
      });

      test('Works with other Every implementations', () {
        final base = EveryDueWorkdayMonth(3);
        final modified = _TestEveryModifier<EveryDueWorkdayMonth>(every: base);
        expect(modified.every, equals(base));
      });
    });

    group('Modifier behavior', () {
      test('Delegates to LimitedOrEveryHandler.startDate', () {
        // December 4, 2023 is Monday
        final inputDate = DateTime(2023, DateTime.december, 4);
        expect(modifier, startsAtSameDate.withInput(inputDate));
      });

      test('Processes date with custom logic', () {
        final modifierWithPrevious = _TestEveryModifier<EveryWeekday>(
          every: baseEvery,
          direction: DateDirection.previous,
        );
        final inputDate = DateTime(2023, DateTime.december, 5);
        final expectedDate = DateTime(2023, DateTime.december, 10);
        expect(
          modifierWithPrevious,
          startsAt(expectedDate).withInput(inputDate),
        );
      });

      test('Combination with different directions', () {
        final nextModifier = _TestEveryModifier<EveryWeekday>(
          every: baseEvery,
        );
        final previousModifier = _TestEveryModifier<EveryWeekday>(
          every: baseEvery,
          direction: DateDirection.previous,
        );

        // December 4, 2023 is Monday
        final inputDate = DateTime(2023, DateTime.december, 4);

        // Next modifier should return the same date
        expect(nextModifier, startsAtSameDate.withInput(inputDate));

        // Previous modifier should return one day earlier
        final expectedPrevious = DateTime(2023, DateTime.december, 3);
        expect(
          previousModifier,
          startsAt(expectedPrevious).withInput(inputDate),
        );
      });
    });

    group('Methods', () {
      group('startDate', () {
        test('Returns same date when input is valid', () {
          // December 4, 2023 is Monday
          final validDate = DateTime(2023, DateTime.december, 4);
          expect(modifier, startsAtSameDate.withInput(validDate));
        });

        test('Returns next valid date when input is invalid', () {
          // December 5, 2023 is Tuesday
          final invalidDate = DateTime(2023, DateTime.december, 5);
          // December 11, 2023 is Monday
          final expectedDate = DateTime(2023, DateTime.december, 11);
          expect(modifier, startsAt(expectedDate).withInput(invalidDate));
        });

        test('Always processes the result through processDate', () {
          final modifierWithPrevious = _TestEveryModifier<EveryWeekday>(
            every: baseEvery,
            direction: DateDirection.previous,
          );
          // December 4, 2023 is Monday (valid)
          final validDate = DateTime(2023, DateTime.december, 4);
          // Expected: December 3, 2023 (one day earlier due to processDate)
          final expectedDate = DateTime(2023, DateTime.december, 3);
          expect(
            modifierWithPrevious,
            startsAt(expectedDate).withInput(validDate),
          );
        });
      });

      group('next', () {
        test('Always generates date after input', () {
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

        test('Applies processDate to the result', () {
          final modifierWithPrevious = _TestEveryModifier<EveryWeekday>(
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
        test('Always generates date before input', () {
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

        test('Applies processDate to the result', () {
          final modifierWithPrevious = _TestEveryModifier<EveryWeekday>(
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
      test('Works with LimitedEvery base', () {
        final limitedBase = EverySkipInvalidModifier(
          every: baseEvery,
          invalidator: DateValidatorWeekdayCountInMonth(
            week: Week.first,
            day: Weekday.monday,
          ),
        );
        final modifier = _TestEveryModifier<
            EverySkipInvalidModifier<EveryWeekday, DateValidator>>(
          every: limitedBase,
        );
        expect(modifier.every, equals(limitedBase));
      });

      test('Handles processDate correctly with different directions', () {
        // Test that processDate is called with correct direction parameter
        final modifier = _TestEveryModifier<EveryWeekday>(
          every: baseEvery,
          direction: DateDirection.start,
        );
        // December 4, 2023 is Monday
        final date = DateTime(2023, DateTime.december, 4);
        expect(modifier, startsAtSameDate.withInput(date));
      });

      test('Works with edge dates', () {
        // Test with year boundary
        final date = DateTime(2023, DateTime.december, 31);
        // Should work without throwing
        expect(() => modifier.startDate(date), returnsNormally);
        expect(() => modifier.next(date), returnsNormally);
        expect(() => modifier.previous(date), returnsNormally);
      });
    });
  });
}
