import 'package:due_date/src/date_validators/built_in/date_validator_day_in_year.dart';
import 'package:due_date/src/date_validators/built_in/date_validator_due_day_month.dart';
import 'package:due_date/src/date_validators/built_in/date_validator_due_workday_month.dart';
import 'package:due_date/src/date_validators/built_in/date_validator_opposite.dart';
import 'package:due_date/src/date_validators/built_in/date_validator_time_of_day.dart';
import 'package:due_date/src/date_validators/built_in/date_validator_weekday.dart';
import 'package:due_date/src/date_validators/built_in/date_validator_weekday_count_in_month.dart';
import 'package:due_date/src/date_validators/date_validator.dart';
import 'package:due_date/src/date_validators/group/date_validator_difference.dart';
import 'package:due_date/src/date_validators/group/date_validator_intersection.dart';
import 'package:due_date/src/date_validators/group/date_validator_union.dart';
import 'package:due_date/src/enums/week.dart';
import 'package:due_date/src/enums/weekday.dart';
import 'package:test/test.dart';

void main() {
  group('DateValidator', () {
    group('Constructors', () {
      group('weekday', () {
        test('can be const and returns DateValidatorWeekday', () {
          const validator = DateValidator.weekday(Weekday.monday);
          expect(validator, isA<DateValidatorWeekday>());
        });
      });

      group('dueDayMonth', () {
        test('can be const and returns DateValidatorDueDayMonth', () {
          const validator = DateValidator.dueDayMonth(1);
          expect(validator, isA<DateValidatorDueDayMonth>());
        });
      });

      group('dayInYear', () {
        test('can be const and returns DateValidatorDayInYear', () {
          const validator = DateValidator.dayInYear(1);
          expect(validator, isA<DateValidatorDayInYear>());
        });
      });

      group('weekdayCountInMonth', () {
        test('can be const and returns DateValidatorWeekdayCountInMonth', () {
          const validator = DateValidator.weekdayCountInMonth(
            week: Week.first,
            day: Weekday.monday,
          );
          expect(validator, isA<DateValidatorWeekdayCountInMonth>());
        });
      });

      group('dueWorkdayMonth', () {
        test('can be const and returns DateValidatorDueWorkdayMonth', () {
          const validator = DateValidator.dueWorkdayMonth(1);
          expect(validator, isA<DateValidatorDueWorkdayMonth>());
        });
      });

      group('timeOfDay', () {
        test('can be const and returns DateValidatorTimeOfDay', () {
          const validator = DateValidator.timeOfDay(Duration.zero);
          expect(validator, isA<DateValidatorTimeOfDay>());
        });
      });

      group('opposite', () {
        test('can be const and returns DateValidatorOpposite', () {
          const validator = DateValidator.opposite(
            DateValidator.weekday(Weekday.monday),
          );
          expect(validator, isA<DateValidatorOpposite>());
        });
      });

      group('union', () {
        test('can be const and returns DateValidatorUnion', () {
          const validator = DateValidator.union([]);
          expect(validator, isA<DateValidatorUnion>());
        });
      });

      group('intersection', () {
        test('can be const and returns DateValidatorIntersection', () {
          const validator = DateValidator.intersection([]);
          expect(validator, isA<DateValidatorIntersection>());
        });
      });

      group('difference', () {
        test('can be const and returns DateValidatorDifference', () {
          const validator = DateValidator.difference([]);
          expect(validator, isA<DateValidatorDifference>());
        });
      });
    });
  });
}
