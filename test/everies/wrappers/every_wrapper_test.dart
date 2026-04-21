import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/everies/built_in/every_due_time_of_day.dart';
import 'package:due_date/src/everies/built_in/every_weekday.dart';
import 'package:due_date/src/everies/wrappers/every_skip_count_wrapper.dart';
import 'package:due_date/src/everies/wrappers/every_time_of_day_wrapper.dart';
import 'package:due_date/src/everies/wrappers/every_wrapper.dart';
import 'package:due_date/src/everies/wrappers/limited_every_skip_count_wrapper.dart';
import 'package:due_date/src/everies/wrappers/limited_every_time_of_day_wrapper.dart';
import 'package:test/test.dart';

void main() {
  group('EveryWrapper:', () {
    group('Constructor', () {
      group('skipCount', () {
        test('can be const and returns EverySkipCountWrapper', () {
          const wrapper = EveryWrapper<EveryWeekday>.skipCount(
            every: EveryWeekday(Weekday.monday),
            count: 1,
          );
          expect(wrapper, isA<EverySkipCountWrapper<EveryWeekday>>());
        });
      });

      group('timeOfDay', () {
        test('can be const and returns EveryTimeOfDayWrapper', () {
          const wrapper = EveryWrapper<EveryWeekday>.timeOfDay(
            every: EveryWeekday(Weekday.monday),
            everyTimeOfDay: EveryDueTimeOfDay.midnight,
          );
          expect(wrapper, isA<EveryTimeOfDayWrapper<EveryWeekday>>());
        });
      });

      group('limitedSkipCount', () {
        test('can be const and returns LimitedEverySkipCountWrapper', () {
          const wrapper = EveryWrapper<EveryWeekday>.limitedSkipCount(
            every: EveryWeekday(Weekday.monday),
            count: 1,
          );
          expect(wrapper, isA<LimitedEverySkipCountWrapper<EveryWeekday>>());
        });
      });

      group('limitedTimeOfDay', () {
        test('can be const and returns LimitedEveryTimeOfDayWrapper', () {
          const wrapper = EveryWrapper<EveryWeekday>.limitedTimeOfDay(
            every: EveryWeekday(Weekday.monday),
            everyTimeOfDay: EveryDueTimeOfDay.midnight,
          );
          expect(wrapper, isA<LimitedEveryTimeOfDayWrapper<EveryWeekday>>());
        });
      });
    });
  });
}
