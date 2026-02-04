import 'package:due_date/src/date_validators/date_validator.dart';
import 'package:due_date/src/date_validators/date_validator_weekday_count_in_month.dart';
import 'package:due_date/src/enums/week.dart';
import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/everies/adapters/every_skip_invalid_adapter.dart';
import 'package:due_date/src/everies/built_in/every_due_day_month.dart';
import 'package:due_date/src/everies/built_in/every_due_workday_month.dart';
import 'package:due_date/src/everies/built_in/every_weekday.dart';
import 'package:due_date/src/everies/date_direction.dart';
import 'package:due_date/src/everies/every.dart';
import 'package:due_date/src/everies/wrappers/every_wrapper.dart';
import 'package:due_date/src/everies/wrappers/every_wrapper_mixin.dart';
import 'package:test/test.dart';

import '../../src/every_match.dart';

/// Test implementation of [EveryWrapper] with [EveryWrapperMixin].
class _TestEveryModifier<T extends Every> extends EveryWrapper<T>
    with EveryWrapperMixin<T> {
  const _TestEveryModifier({
    required super.every,
    this.forward = true,
  });

  /// The direction to use when processing dates.
  final bool forward;

  @override
  DateTime processDate(DateTime date, DateDirection actualDirection) {
    // For testing, we can modify the date based on direction
    // This is a simple test implementation.
    if (forward) return date;
    // Subtract one day for testing purposes.
    return date.subtract(Duration(days: 1));
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
          expect(modifier.forward, equals(true));
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
    group('Methods', () {
      group('next', () {
        test('Always generates date after input', () {
          // December 4, 2023 is Monday.
          final date = DateTime(2023, DateTime.december, 4);
          expect(modifier, nextIsAfter.withInput(date));
        });

        test('Returns next occurrence with processDate applied', () {
          // December 4, 2023 is Monday.
          final date = DateTime(2023, DateTime.december, 4);
          // December 11, 2023 is Monday (next occurrence).
          final expectedDate = DateTime(2023, DateTime.december, 11);
          expect(modifier, hasNext(expectedDate).withInput(date));
        });

        test('Applies processDate to the result', () {
          final modifierWithPrevious = _TestEveryModifier<EveryWeekday>(
            every: baseEvery,
            forward: false,
          );
          // December 4, 2023 is Monday.
          final date = DateTime(2023, DateTime.december, 4);
          // December 10, 2023 (December 11 minus one day due to processDate).
          final expectedDate = DateTime(2023, DateTime.december, 10);
          expect(modifierWithPrevious, hasNext(expectedDate).withInput(date));
        });
      });

      group('previous', () {
        test('Always generates date before input', () {
          // December 11, 2023 is Monday.
          final date = DateTime(2023, DateTime.december, 11);
          expect(modifier, previousIsBefore.withInput(date));
        });

        test('Returns previous occurrence with processDate applied', () {
          // December 11, 2023 is Monday.
          final date = DateTime(2023, DateTime.december, 11);
          // December 4, 2023 is Monday (previous occurrence).
          final expectedDate = DateTime(2023, DateTime.december, 4);
          expect(modifier, hasPrevious(expectedDate).withInput(date));
        });

        test('Applies processDate to the result', () {
          final modifierWithPrevious = _TestEveryModifier<EveryWeekday>(
            every: baseEvery,
            forward: false,
          );
          // December 11, 2023 is Monday.
          final date = DateTime(2023, DateTime.december, 11);
          // December 3, 2023 (December 4 minus one day due to processDate).
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
        final limitedBase = EverySkipInvalidAdapter(
          every: baseEvery,
          validator: DateValidatorWeekdayCountInMonth(
            week: Week.first,
            day: Weekday.monday,
          ),
        );
        final current = _TestEveryModifier<
            EverySkipInvalidAdapter<EveryWeekday, DateValidator>>(
          every: limitedBase,
        );
        expect(current.every, equals(limitedBase));
      });
      test('Works with edge dates', () {
        // Test with year boundary.
        final date = DateTime(2023, DateTime.december, 31);
        // Should work without throwing.
        expect(() => modifier.next(date), returnsNormally);
        expect(() => modifier.previous(date), returnsNormally);
      });
    });
  });
}
