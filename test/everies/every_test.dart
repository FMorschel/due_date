import 'package:due_date/src/enums/week.dart';
import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/everies/built_in/every_day_in_year.dart';
import 'package:due_date/src/everies/built_in/every_due_day_month.dart';
import 'package:due_date/src/everies/built_in/every_due_time_of_day.dart';
import 'package:due_date/src/everies/built_in/every_due_workday_month.dart';
import 'package:due_date/src/everies/built_in/every_weekday.dart';
import 'package:due_date/src/everies/built_in/every_weekday_count_in_month.dart';
import 'package:due_date/src/everies/every.dart';
import 'package:due_date/src/everies/every_date_validator.dart';
import 'package:due_date/src/everies/group/every_date_validator_difference.dart';
import 'package:due_date/src/everies/group/every_date_validator_intersection.dart';
import 'package:due_date/src/everies/group/every_date_validator_union.dart';
import 'package:test/test.dart';

void main() {
  group('Every:', () {
    group('Constructor', () {
      group('weekday', () {
        test('can be const and returns EveryWeekday', () {
          const every = Every.weekday(Weekday.monday);
          expect(every, isA<EveryWeekday>());
        });
      });

      group('dueDayMonth', () {
        test('can be const and returns EveryDueDayMonth', () {
          const every = Every.dueDayMonth(1);
          expect(every, isA<EveryDueDayMonth>());
        });
      });

      group('dayInYear', () {
        test('can be const and returns EveryDayInYear', () {
          const every = Every.dayInYear(1);
          expect(every, isA<EveryDayInYear>());
        });
      });

      group('weekdayCountInMonth', () {
        test('can be const and returns EveryWeekdayCountInMonth', () {
          const every = Every.weekdayCountInMonth(
            week: Week.first,
            day: Weekday.monday,
          );
          expect(every, isA<EveryWeekdayCountInMonth>());
        });
      });

      group('dueWorkdayMonth', () {
        test('can be const and returns EveryDueWorkdayMonth', () {
          const every = Every.dueWorkdayMonth(1);
          expect(every, isA<EveryDueWorkdayMonth>());
        });
      });

      group('dueTimeOfDay', () {
        test('can be const and returns EveryDueTimeOfDay', () {
          const every = Every.dueTimeOfDay(Duration.zero);
          expect(every, isA<EveryDueTimeOfDay>());
        });
      });

      group('union', () {
        test('can be const and returns EveryDateValidatorUnion', () {
          const every = Every.union(<EveryDateValidator>[
            EveryWeekday(Weekday.monday),
          ]);
          expect(every, isA<EveryDateValidatorUnion>());
        });
      });

      group('intersection', () {
        test('can be const and returns EveryDateValidatorIntersection', () {
          const every = Every.intersection(<EveryDateValidator>[
            EveryWeekday(Weekday.monday),
          ]);
          expect(every, isA<EveryDateValidatorIntersection>());
        });
      });

      group('difference', () {
        test('can be const and returns EveryDateValidatorDifference', () {
          const every = Every.difference(<EveryDateValidator>[
            EveryWeekday(Weekday.monday),
          ]);
          expect(every, isA<EveryDateValidatorDifference>());
        });
      });
    });
  });
}
