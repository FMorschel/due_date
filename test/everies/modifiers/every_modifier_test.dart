import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/everies/built_in/every_due_time_of_day.dart';
import 'package:due_date/src/everies/built_in/every_weekday.dart';
import 'package:due_date/src/everies/modifiers/every_modifier.dart';
import 'package:due_date/src/everies/modifiers/every_skip_count_modifier.dart';
import 'package:due_date/src/everies/modifiers/every_time_of_day_modifier.dart';
import 'package:due_date/src/everies/modifiers/limited_every_skip_count_modifier.dart';
import 'package:due_date/src/everies/modifiers/limited_every_time_of_day_modifier.dart';
import 'package:test/test.dart';

void main() {
  group('EveryModifier:', () {
    group('Constructor', () {
      group('skipCount', () {
        test('can be const and returns EverySkipCountModifier', () {
          const modifier = EveryModifier<EveryWeekday>.skipCount(
            every: EveryWeekday(Weekday.monday),
            count: 1,
          );
          expect(modifier, isA<EverySkipCountModifier<EveryWeekday>>());
        });
      });

      group('timeOfDay', () {
        test('can be const and returns EveryTimeOfDayModifier', () {
          const modifier = EveryModifier<EveryWeekday>.timeOfDay(
            every: EveryWeekday(Weekday.monday),
            everyTimeOfDay: EveryDueTimeOfDay.midnight,
          );
          expect(modifier, isA<EveryTimeOfDayModifier<EveryWeekday>>());
        });
      });

      group('limitedSkipCount', () {
        test('can be const and returns LimitedEverySkipCountModifier', () {
          const modifier = EveryModifier<EveryWeekday>.limitedSkipCount(
            every: EveryWeekday(Weekday.monday),
            count: 1,
          );
          expect(modifier, isA<LimitedEverySkipCountModifier<EveryWeekday>>());
        });
      });

      group('limitedTimeOfDay', () {
        test('can be const and returns LimitedEveryTimeOfDayModifier', () {
          const modifier = EveryModifier<EveryWeekday>.limitedTimeOfDay(
            every: EveryWeekday(Weekday.monday),
            everyTimeOfDay: EveryDueTimeOfDay.midnight,
          );
          expect(modifier, isA<LimitedEveryTimeOfDayModifier<EveryWeekday>>());
        });
      });
    });
  });
}
