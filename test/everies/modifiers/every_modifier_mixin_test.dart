import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/everies/date_direction.dart';
import 'package:due_date/src/everies/every_date_validator.dart';
import 'package:due_date/src/everies/every_weekday.dart';
import 'package:due_date/src/everies/modifiers/every_modifier.dart';
import 'package:due_date/src/everies/modifiers/every_modifier_mixin.dart';
import 'package:test/test.dart';

import '../../src/every_match.dart';

class EveryModifierMixinTest extends EveryModifier with EveryModifierMixin {
  const EveryModifierMixinTest({required super.every}) : _every = every;

  final EveryDateValidator _every;

  @override
  DateTime processDate(DateTime date, DateDirection direction) {
    if (valid(date)) return date;
    if (direction.isForward) {
      return every.next(date);
    }
    return every.previous(date);
  }

  @override
  bool valid(DateTime date) => _every.valid(date);
}

void main() {
  group('EveryModifierMixin', () {
    const every = EveryModifierMixinTest(
      every: EveryWeekday(Weekday.monday),
    );
    group('startDate', () {
      test('returns the same date when valid', () {
        // Monday, 5th January 2026.
        final validDate = DateTime(2026, 1, 5);
        expect(every, startsAtSameDate.withInput(validDate));
      });
      test('returns the next valid date when invalid', () {
        // Monday, 6th January 2026.
        final invalidDate = DateTime(2026, 1, 6);
        // Monday, 12th January 2026.
        final expected = DateTime(2026, 1, 12);
        expect(every, startsAt(expected).withInput(invalidDate));
      });
    });
    test('next returns the next valid date', () {
      // Monday, 5th January 2026.
      final inputDate = DateTime(2026, 1, 5);
      // Monday, 12th January 2026.
      final expected = DateTime(2026, 1, 12);
      expect(every, hasNext(expected).withInput(inputDate));
    });
    test('previous returns the previous valid date', () {
      // Monday, 12th January 2026.
      final inputDate = DateTime(2026, 1, 12);
      // Monday, 5th January 2026.
      final expected = DateTime(2026, 1, 5);
      expect(every, hasPrevious(expected).withInput(inputDate));
    });
    group('endDate', () {
      test('returns the same date when valid', () {
        // Monday, 5th January 2026.
        final validDate = DateTime(2026, 1, 5);
        expect(every, endsAtSameDate.withInput(validDate));
      });
      test('returns the previous valid date when invalid', () {
        // Monday, 6th January 2026.
        final invalidDate = DateTime(2026, 1, 6);
        // Monday, 5th January 2026.
        final expected = DateTime(2026, 1, 5);
        expect(every, endsAt(expected).withInput(invalidDate));
      });
    });
  });
}
