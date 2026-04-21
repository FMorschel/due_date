import 'package:due_date/src/date_validators/built_in/date_validator_weekday.dart';
import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/everies/adapters/every_adapter.dart';
import 'package:due_date/src/everies/adapters/every_override_adapter.dart';
import 'package:due_date/src/everies/adapters/every_skip_count_adapter.dart';
import 'package:due_date/src/everies/adapters/every_skip_invalid_adapter.dart';
import 'package:due_date/src/everies/adapters/every_time_of_day_adapter.dart';
import 'package:due_date/src/everies/adapters/limited_every_override_adapter.dart';
import 'package:due_date/src/everies/adapters/limited_every_skip_count_adapter.dart';
import 'package:due_date/src/everies/adapters/limited_every_skip_invalid_adapter.dart';
import 'package:due_date/src/everies/adapters/limited_every_time_of_day_adapter.dart';
import 'package:due_date/src/everies/built_in/every_due_time_of_day.dart';
import 'package:due_date/src/everies/built_in/every_weekday.dart';
import 'package:test/test.dart';

void main() {
  group('EveryAdapter:', () {
    group('Constructor', () {
      group('skipCount', () {
        test('can be const and returns EverySkipCountAdapter', () {
          const adapter =
              EveryAdapter<EveryWeekday, DateValidatorWeekday>.skipCount(
            every: EveryWeekday(Weekday.monday),
            validator: DateValidatorWeekday(Weekday.monday),
            count: 1,
          );
          expect(
            adapter,
            isA<EverySkipCountAdapter<EveryWeekday, DateValidatorWeekday>>(),
          );
        });
      });

      group('timeOfDay', () {
        test('can be const and returns EveryTimeOfDayAdapter', () {
          const adapter =
              EveryAdapter<EveryWeekday, DateValidatorWeekday>.timeOfDay(
            every: EveryWeekday(Weekday.monday),
            validator: DateValidatorWeekday(Weekday.monday),
            everyTimeOfDay: EveryDueTimeOfDay.midnight,
          );
          expect(
            adapter,
            isA<EveryTimeOfDayAdapter<EveryWeekday, DateValidatorWeekday>>(),
          );
        });
      });

      group('skipInvalid', () {
        test('can be const and returns EverySkipInvalidAdapter', () {
          const adapter =
              EveryAdapter<EveryWeekday, DateValidatorWeekday>.skipInvalid(
            every: EveryWeekday(Weekday.monday),
            validator: DateValidatorWeekday(Weekday.monday),
          );
          expect(
            adapter,
            isA<EverySkipInvalidAdapter<EveryWeekday, DateValidatorWeekday>>(),
          );
        });
      });

      group('override', () {
        test('can be const and returns EveryOverrideAdapter', () {
          const adapter =
              EveryAdapter<EveryWeekday, DateValidatorWeekday>.override(
            every: EveryWeekday(Weekday.monday),
            validator: DateValidatorWeekday(Weekday.monday),
            overrider: EveryWeekday(Weekday.tuesday),
          );
          expect(
            adapter,
            isA<EveryOverrideAdapter<EveryWeekday, DateValidatorWeekday>>(),
          );
        });
      });

      group('limitedSkipCount', () {
        test('can be const and returns LimitedEverySkipCountAdapter', () {
          const adapter =
              EveryAdapter<EveryWeekday, DateValidatorWeekday>.limitedSkipCount(
            every: EveryWeekday(Weekday.monday),
            validator: DateValidatorWeekday(Weekday.monday),
            count: 1,
          );
          expect(
            adapter,
            isA<
                LimitedEverySkipCountAdapter<EveryWeekday,
                    DateValidatorWeekday>>(),
          );
        });
      });

      group('limitedTimeOfDay', () {
        test('can be const and returns LimitedEveryTimeOfDayAdapter', () {
          const adapter =
              EveryAdapter<EveryWeekday, DateValidatorWeekday>.limitedTimeOfDay(
            every: EveryWeekday(Weekday.monday),
            validator: DateValidatorWeekday(Weekday.monday),
            everyTimeOfDay: EveryDueTimeOfDay.midnight,
          );
          expect(
            adapter,
            isA<
                LimitedEveryTimeOfDayAdapter<EveryWeekday,
                    DateValidatorWeekday>>(),
          );
        });
      });

      group('limitedSkipInvalid', () {
        test('can be const and returns LimitedEverySkipInvalidAdapter', () {
          const adapter = EveryAdapter<EveryWeekday,
              DateValidatorWeekday>.limitedSkipInvalid(
            every: EveryWeekday(Weekday.monday),
            validator: DateValidatorWeekday(Weekday.monday),
          );
          expect(
            adapter,
            isA<
                LimitedEverySkipInvalidAdapter<EveryWeekday,
                    DateValidatorWeekday>>(),
          );
        });
      });

      group('limitedOverride', () {
        test('can be const and returns LimitedEveryOverrideAdapter', () {
          const adapter =
              EveryAdapter<EveryWeekday, DateValidatorWeekday>.limitedOverride(
            every: EveryWeekday(Weekday.monday),
            validator: DateValidatorWeekday(Weekday.monday),
            overrider: EveryWeekday(Weekday.tuesday),
          );
          expect(
            adapter,
            isA<
                LimitedEveryOverrideAdapter<EveryWeekday,
                    DateValidatorWeekday>>(),
          );
        });
      });
    });
  });
}
