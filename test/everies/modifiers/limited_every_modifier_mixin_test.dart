import 'package:due_date/due_date.dart';
import 'package:due_date/src/everies/modifiers/limited_every_modifier.dart';
import 'package:test/test.dart';

import '../../src/every_match.dart';

/// Test implementation of [LimitedEveryModifier] with
/// [LimitedEveryModifierMixin].
class _TestLimitedEveryModifier<T extends Every> extends LimitedEveryModifier<T>
    with LimitedEveryModifierMixin<T> {
  const _TestLimitedEveryModifier({
    required super.every,
    this.forward = true,
  });

  /// The direction to use when processing dates.
  final bool forward;

  @override
  DateTime processDate(
    DateTime date,
    DateDirection actualDirection, {
    DateTime? limit,
  }) {
    if (forward) return date;
    // Subtract one day for testing purposes
    return date.subtract(Duration(days: 1));
  }
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
          expect(modifier.forward, equals(true));
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

    group('Methods', () {
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

        test('Applies processDate to the result', () {
          final modifierWithPrevious = _TestLimitedEveryModifier<EveryWeekday>(
            every: baseEvery,
            forward: false,
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

        test('Applies processDate to the result', () {
          final modifierWithPrevious = _TestLimitedEveryModifier<EveryWeekday>(
            every: baseEvery,
            forward: false,
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
      test('Works with edge dates and limits', () {
        // Test with year boundary
        final date = DateTime(2023, DateTime.december, 31);
        final limit = DateTime(2024, DateTime.february);
        // Should work without throwing
        expect(() => modifier.next(date, limit: limit), returnsNormally);
        expect(() => modifier.previous(date, limit: limit), returnsNormally);
      });
    });

    group('LimitedEvery interface compliance', () {
      test('All methods accept limit parameter', () {
        // Verify that all three methods accept the limit parameter
        final date = DateTime(2023, DateTime.december, 4);
        final limit = DateTime(2024);

        // These should all compile and run without error
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
