import 'package:due_date/src/date_validators/built_in/date_validator_weekday_count_in_month.dart';
import 'package:due_date/src/enums/week.dart';
import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/everies/adapters/every_adapter_invalidator.dart';
import 'package:due_date/src/everies/adapters/every_adapter_invalidator_mixin.dart';
import 'package:due_date/src/everies/built_in/every_weekday.dart';
import 'package:due_date/src/everies/date_direction.dart';

class EveryIncompatibleValidatorAndGeneratorTest extends EveryAdapterInvalidator
    with EveryAdapterInvalidatorMixin {
  EveryIncompatibleValidatorAndGeneratorTest()
      : super(
          validator: DateValidatorWeekdayCountInMonth(
            day: Weekday.monday,
            week: Week.first,
          ),
          every: EveryWeekday(Weekday.monday),
        );

  @override
  bool valid(DateTime date) => validator.valid(date);

  @override
  DateTime processDate(DateTime date, DateDirection direction) {
    if (valid(date)) return date;
    return direction.isForward ? every.next(date) : every.previous(date);
  }
}
