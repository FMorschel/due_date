import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/everies/every_date_validator.dart';
import 'package:due_date/src/everies/every_weekday.dart';
import 'package:due_date/src/everies/limited_every_mixin.dart';
import 'package:due_date/src/everies/modifiers/date_direction.dart';
import 'package:due_date/src/everies/modifiers/limited_every_modifier.dart';
import 'package:due_date/src/everies/modifiers/limited_every_modifier_mixin.dart';
import 'package:due_date/src/helpers/limited_or_every_handler.dart';
import 'package:test/test.dart';

import '../../src/every_match.dart';

class LimitedEveryModifierTest extends LimitedEveryModifier
    with LimitedEveryModifierMixin, LimitedEveryMixin {
  const LimitedEveryModifierTest({required EveryDateValidator super.every})
      : _every = every;

  final EveryDateValidator _every;

  @override
  DateTime processDate(
    DateTime date,
    DateDirection direction, {
    DateTime? limit,
  }) {
    throwIfLimitReached(date, direction, limit: limit);
    if (valid(date)) return date;
    if (direction.isForward) {
      return LimitedOrEveryHandler.next(every, date, limit: limit);
    }
    return LimitedOrEveryHandler.previous(every, date, limit: limit);
  }

  @override
  bool valid(DateTime date) => _every.valid(date);
}

void main() {
  group('LimitedEveryModifier', () {
    const every = LimitedEveryModifierTest(
      every: EveryWeekday(Weekday.monday),
    );
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
  });
}
