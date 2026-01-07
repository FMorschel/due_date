import 'package:due_date/src/everies/every_due_day_month.dart';
import 'package:due_date/src/everies/every_due_time_of_day.dart';
import 'package:due_date/src/everies/modifiers/every_date_validator_time_of_day_wrapper.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

import '../../src/date_validator_match.dart';
import '../../src/every_match.dart';

void main() {
  group('EveryTimeOfDayModifier', () {
    group('Constructor', () {
      group('Unnamed', () {
        test('Default everyTimeOfDay is midnight', () {
          const wrapper =
              EveryDateValidatorTimeOfDayWrapper(every: EveryDueDayMonth(1));
          expect(wrapper.everyTimeOfDay, equals(EveryDueTimeOfDay.midnight));
        });
        test('Custom everyTimeOfDay', () {
          const customTimeOfDay = EveryDueTimeOfDay(Duration(hours: 10));
          const wrapper = EveryDateValidatorTimeOfDayWrapper(
            every: EveryDueDayMonth(1),
            everyTimeOfDay: customTimeOfDay,
          );
          expect(wrapper.everyTimeOfDay, equals(customTimeOfDay));
        });
        test('Every', () {
          const every = EveryDueDayMonth(5);
          const wrapper = EveryDateValidatorTimeOfDayWrapper(every: every);
          expect(wrapper.every, equals(every));
        });
      });
    });
    group('Methods', () {
      const microsecond = Duration(microseconds: 1);
      final day = DateTime(2024);
      const every = EveryDueDayMonth(1);
      const duration = Duration(
        hours: 12,
        minutes: 30,
        seconds: 15,
        milliseconds: 500,
        microseconds: 001,
      );
      group('valid', () {
        test('for both every and everyTimeOfDay', () {
          final wrapper = EveryDateValidatorTimeOfDayWrapper(
            every: every,
            everyTimeOfDay: EveryDueTimeOfDay(duration),
          );
          final validDate = day.add(duration);
          expect(wrapper, isValid(validDate));
          final invalidDateEvery = day.add(const Duration(hours: 10));
          expect(wrapper, isInvalid(invalidDateEvery));
          final invalidDateTimeOfDay = day.add(const Duration(hours: 12));
          expect(wrapper, isInvalid(invalidDateTimeOfDay));
        });
      });
      group('startDate', () {
        test('valid date invalid time', () {
          final wrapper = EveryDateValidatorTimeOfDayWrapper(
            every: every,
            everyTimeOfDay: EveryDueTimeOfDay(duration),
          );
          final inputDate = day.add(const Duration(hours: 10));
          expect(
            wrapper,
            startsAt(day.add(duration)).withInput(inputDate),
          );
        });
        test('valid datetime', () {
          final wrapper = EveryDateValidatorTimeOfDayWrapper(
            every: every,
            everyTimeOfDay: EveryDueTimeOfDay(duration),
          );
          final inputDate = day.add(duration);
          expect(
            wrapper,
            startsAtSameDate.withInput(inputDate),
          );
        });
        group('Before', () {
          final previousMicrosecond = duration - microsecond;
          if (!previousMicrosecond.isNegative) {
            final wrapper = EveryDateValidatorTimeOfDayWrapper(
              every: every,
              everyTimeOfDay: EveryDueTimeOfDay(previousMicrosecond),
            );
            test('$previousMicrosecond', () {
              final inputDate = day.add(duration);
              expect(
                wrapper,
                startsAt(day.add(previousMicrosecond)).withInput(inputDate),
              );
            });
          }
        });
        group('After', () {
          final nextMicrosecond = duration + microsecond;
          if (nextMicrosecond < Duration(days: 1)) {
            final wrapper = EveryDateValidatorTimeOfDayWrapper(
              every: every,
              everyTimeOfDay: EveryDueTimeOfDay(nextMicrosecond),
            );
            test('$nextMicrosecond', () {
              final inputDate = day.add(duration);
              expect(
                wrapper,
                startsAt(day.add(nextMicrosecond)).withInput(inputDate),
              );
            });
          }
        });
      });
      group('next', () {
        final expectedDate = DateTime(2024, 2);
        group('Before', () {
          final previousMicrosecond = duration - microsecond;
          if (!previousMicrosecond.isNegative) {
            final wrapper = EveryDateValidatorTimeOfDayWrapper(
              every: every,
              everyTimeOfDay: EveryDueTimeOfDay(previousMicrosecond),
            );

            test('$previousMicrosecond', () {
              final inputDate = day.add(duration);
              expect(
                wrapper,
                hasNext(expectedDate.add(previousMicrosecond))
                    .withInput(inputDate),
              );
            });
          }
        });
        group('After', () {
          final nextMicrosecond = duration + microsecond;
          if (nextMicrosecond < Duration(days: 1)) {
            final wrapper = EveryDateValidatorTimeOfDayWrapper(
              every: every,
              everyTimeOfDay: EveryDueTimeOfDay(nextMicrosecond),
            );
            test('$nextMicrosecond', () {
              final inputDate = day.add(duration);
              expect(
                wrapper,
                hasNext(expectedDate.add(nextMicrosecond)).withInput(inputDate),
              );
            });
          }
        });
      });
      group('previous', () {
        final expectedDate = DateTime(2023, 12);
        group('Before', () {
          final previousMicrosecond = duration - microsecond;
          if (!previousMicrosecond.isNegative) {
            final wrapper = EveryDateValidatorTimeOfDayWrapper(
              every: every,
              everyTimeOfDay: EveryDueTimeOfDay(previousMicrosecond),
            );
            test('$previousMicrosecond', () {
              final inputDate = day.add(duration);
              expect(
                wrapper,
                hasPrevious(expectedDate.add(previousMicrosecond))
                    .withInput(inputDate),
              );
            });
          }
        });
        group('After', () {
          final nextMicrosecond = duration + microsecond;
          if (nextMicrosecond < Duration(days: 1)) {
            final wrapper = EveryDateValidatorTimeOfDayWrapper(
              every: every,
              everyTimeOfDay: EveryDueTimeOfDay(nextMicrosecond),
            );
            test('$nextMicrosecond', () {
              final inputDate = day.add(duration);
              expect(
                wrapper,
                hasPrevious(expectedDate.add(nextMicrosecond))
                    .withInput(inputDate),
              );
            });
          }
        });
      });
      group('endDate', () {
        test('valid date invalid time', () {
          final wrapper = EveryDateValidatorTimeOfDayWrapper(
            every: every,
            everyTimeOfDay: EveryDueTimeOfDay(duration),
          );
          final inputDate = day.add(const Duration(hours: 10));
          expect(
            wrapper,
            endsAt(day.add(duration)).withInput(inputDate),
          );
        });
        test('valid datetime', () {
          final wrapper = EveryDateValidatorTimeOfDayWrapper(
            every: every,
            everyTimeOfDay: EveryDueTimeOfDay(duration),
          );
          final inputDate = day.add(duration);
          expect(wrapper, endsAtSameDate.withInput(inputDate));
        });
        group('Before', () {
          final previousMicrosecond = duration - microsecond;
          if (!previousMicrosecond.isNegative) {
            final wrapper = EveryDateValidatorTimeOfDayWrapper(
              every: every,
              everyTimeOfDay: EveryDueTimeOfDay(previousMicrosecond),
            );
            test('$previousMicrosecond', () {
              final inputDate = day.add(duration);
              expect(
                wrapper,
                endsAt(day.add(previousMicrosecond)).withInput(inputDate),
              );
            });
          }
        });
        group('After', () {
          final nextMicrosecond = duration + microsecond;
          if (nextMicrosecond < Duration(days: 1)) {
            final wrapper = EveryDateValidatorTimeOfDayWrapper(
              every: every,
              everyTimeOfDay: EveryDueTimeOfDay(nextMicrosecond),
            );
            test('$nextMicrosecond', () {
              final inputDate = day.add(duration);
              expect(
                wrapper,
                endsAt(day.add(nextMicrosecond)).withInput(inputDate),
              );
            });
          }
        });
      });
      test('next forwards to every.next and sets time of day', () {
        const timeOfDay = Duration(hours: 9);
        const wrapper = EveryDateValidatorTimeOfDayWrapper(
          every: EveryDueDayMonth(10),
          everyTimeOfDay: EveryDueTimeOfDay(timeOfDay),
        );
        final inputDate = DateTime(2024, 1, 5, 15, 0);
        expect(
          wrapper,
          hasNext(day.copyWith(day: 10).add(timeOfDay)).withInput(inputDate),
        );
      });
      test('previous forwards to every.previous and sets time of day', () {
        const timeOfDay = Duration(hours: 18);
        const wrapper = EveryDateValidatorTimeOfDayWrapper(
          every: EveryDueDayMonth(10),
          everyTimeOfDay: EveryDueTimeOfDay(timeOfDay),
        );
        final inputDate = DateTime(2024, 1, 15, 8, 0);
        expect(
          wrapper,
          hasPrevious(day.copyWith(day: 10).add(timeOfDay))
              .withInput(inputDate),
        );
      });
    });
    group('Explicit datetime tests', () {
      group('Midnight (time before)', () {
        test('Sets time to midnight', () {
          const every = EveryDueDayMonth(1);
          const wrapper = EveryDateValidatorTimeOfDayWrapper(
            every: every,
            everyTimeOfDay: EveryDueTimeOfDay.midnight,
          );
          final inputDate = DateTime(2024, 1, 1, 15, 30);
          final processedDate = wrapper.next(inputDate);
          expect(
            processedDate.day,
            equals(every.dueDay),
          );
          expect(processedDate.timeOfDay, equals(Duration.zero));
        });
      });
      group('Last microsecond of the day (time after)', () {
        test('Sets time to last microsecond of the day', () {
          const every = EveryDueDayMonth(1);
          const wrapper = EveryDateValidatorTimeOfDayWrapper(
            every: every,
            everyTimeOfDay: EveryDueTimeOfDay.lastMicrosecond,
          );
          final inputDate = DateTime(2024, 1, 1, 10, 0);
          final processedDate = wrapper.next(inputDate);
          expect(
            processedDate.day,
            equals(every.dueDay),
          );
          expect(
            processedDate.timeOfDay,
            equals(
              EveryDueTimeOfDay.lastMicrosecond.timeOfDay,
            ),
          );
        });
      });
    });
    group('Equality', () {
      test('Same instance', () {
        const instance =
            EveryDateValidatorTimeOfDayWrapper(every: EveryDueDayMonth(1));
        expect(instance, equals(instance));
      });
      test('Different instances, same values', () {
        final instance1 =
            EveryDateValidatorTimeOfDayWrapper(every: EveryDueDayMonth(1));
        final instance2 =
            EveryDateValidatorTimeOfDayWrapper(every: EveryDueDayMonth(1));
        expect(instance1, equals(instance2));
      });
      test('Different every', () {
        final instance1 =
            EveryDateValidatorTimeOfDayWrapper(every: EveryDueDayMonth(1));
        final instance2 =
            EveryDateValidatorTimeOfDayWrapper(every: EveryDueDayMonth(2));
        expect(instance1, isNot(equals(instance2)));
      });
      test('Different everyTimeOfDay', () {
        final instance1 = EveryDateValidatorTimeOfDayWrapper(
          every: EveryDueDayMonth(1),
          everyTimeOfDay: EveryDueTimeOfDay(Duration(hours: 10)),
        );
        final instance2 = EveryDateValidatorTimeOfDayWrapper(
          every: EveryDueDayMonth(1),
          everyTimeOfDay: EveryDueTimeOfDay(Duration(hours: 12)),
        );
        expect(instance1, isNot(equals(instance2)));
      });
    });
  });
}
