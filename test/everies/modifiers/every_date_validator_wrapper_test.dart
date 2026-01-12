import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/everies/every_weekday.dart';
import 'package:due_date/src/everies/modifiers/date_direction.dart';
import 'package:due_date/src/everies/modifiers/every_date_validator_wrapper.dart';
import 'package:due_date/src/everies/modifiers/every_date_validator_wrapper_mixin.dart';
import 'package:test/test.dart';

import '../../src/every_match.dart';

class EveryDateValidatorWrapperTest extends EveryDateValidatorWrapper
    with EveryDateValidatorWrapperMixin {
  const EveryDateValidatorWrapperTest({required super.every});

  @override
  DateTime processDate(
    DateTime date,
    DateDirection direction, {
    DateTime? limit,
  }) {
    throwIfLimitReached(date, direction, limit: limit);
    if (valid(date)) return date;
    if (direction.isForward) {
      return every.next(date);
    }
    return every.previous(date);
  }

  @override
  bool valid(DateTime date) => every.valid(date);
}

void main() {
  group('EveryDateValidatorWrapper', () {
    const every = EveryDateValidatorWrapperTest(
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
      test('throws when limit is reached', () {
        // Monday, 6th January 2026.
        final invalidDate = DateTime(2026, 1, 6);
        final limitDate = DateTime(2026, 1, 6);
        expect(every, startsLimited.withInput(invalidDate, limit: limitDate));
      });
    });
    group('next', () {
      test('next returns the next valid date', () {
        // Monday, 5th January 2026.
        final inputDate = DateTime(2026, 1, 5);
        // Monday, 12th January 2026.
        final expected = DateTime(2026, 1, 12);
        expect(every, hasNext(expected).withInput(inputDate));
      });
      test('throws when limit is reached', () {
        // Monday, 5th January 2026.
        final invalidDate = DateTime(2026, 1, 5);
        final limitDate = DateTime(2026, 1, 5);
        expect(every, limitedNext.withInput(invalidDate, limit: limitDate));
      });
    });
    group('previous', () {
      test('previous returns the previous valid date', () {
        // Monday, 12th January 2026.
        final inputDate = DateTime(2026, 1, 12);
        // Monday, 5th January 2026.
        final expected = DateTime(2026, 1, 5);
        expect(every, hasPrevious(expected).withInput(inputDate));
      });
      test('throws when limit is reached', () {
        // Monday, 12th January 2026.
        final invalidDate = DateTime(2026, 1, 12);
        final limitDate = DateTime(2026, 1, 12);
        expect(every, limitedPrevious.withInput(invalidDate, limit: limitDate));
      });
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
      test('throws when limit is reached', () {
        // Monday, 6th January 2026.
        final invalidDate = DateTime(2026, 1, 6);
        final limitDate = DateTime(2026, 1, 6);
        expect(every, endsLimited.withInput(invalidDate, limit: limitDate));
      });
    });
  });
}
