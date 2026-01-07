import 'package:due_date/src/everies/every_due_day_month.dart';
import 'package:due_date/src/everies/every_due_time_of_day.dart';
import 'package:due_date/src/everies/modifiers/every_time_of_day_wrapper.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

import '../../src/every_match.dart';

void main() {
  group('EveryTimeOfDayWrapper', () {
    group('Constructor', () {
      group('Unnamed', () {
        test('Default everyTimeOfDay is midnight', () {
          const wrapper = EveryTimeOfDayWrapper(every: EveryDueDayMonth(1));
          expect(wrapper.everyTimeOfDay, equals(EveryDueTimeOfDay.midnight));
        });
        test('Custom everyTimeOfDay', () {
          const customTimeOfDay = EveryDueTimeOfDay(Duration(hours: 10));
          const wrapper = EveryTimeOfDayWrapper(
            every: EveryDueDayMonth(1),
            everyTimeOfDay: customTimeOfDay,
          );
          expect(wrapper.everyTimeOfDay, equals(customTimeOfDay));
        });
        test('Every', () {
          const every = EveryDueDayMonth(5);
          const wrapper = EveryTimeOfDayWrapper(every: every);
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
      group('next', () {
        final expectedDate = DateTime(2024, 2);
        group('Before', () {
          final previousMicrosecond = duration - microsecond;
          if (!previousMicrosecond.isNegative) {
            final wrapper = EveryTimeOfDayWrapper(
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
            final wrapper = EveryTimeOfDayWrapper(
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
            final wrapper = EveryTimeOfDayWrapper(
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
            final wrapper = EveryTimeOfDayWrapper(
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
      test('next forwards to every.next and sets time of day', () {
        const current = EveryDueDayMonth(10);
        const wrapper = EveryTimeOfDayWrapper(
          every: current,
          everyTimeOfDay: EveryDueTimeOfDay(Duration(hours: 9)),
        );
        final inputDate = DateTime(2024, 1, 5, 15, 0);
        final processedDate = wrapper.next(inputDate);
        expect(processedDate.day, equals(current.dueDay));
        expect(processedDate.timeOfDay, equals(Duration(hours: 9)));
      });
      test('previous forwards to every.previous and sets time of day', () {
        const current = EveryDueDayMonth(10);
        const wrapper = EveryTimeOfDayWrapper(
          every: current,
          everyTimeOfDay: EveryDueTimeOfDay(Duration(hours: 18)),
        );
        final inputDate = DateTime(2024, 1, 15, 8, 0);
        final processedDate = wrapper.previous(inputDate);
        expect(processedDate.day, equals(current.dueDay));
        expect(processedDate.timeOfDay, equals(Duration(hours: 18)));
      });
    });
    group('Explicit datetime tests', () {
      group('Midnight (time before)', () {
        test('Sets time to midnight', () {
          const every = EveryDueDayMonth(1);
          const wrapper = EveryTimeOfDayWrapper(
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
          const wrapper = EveryTimeOfDayWrapper(
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
        const instance = EveryTimeOfDayWrapper(every: EveryDueDayMonth(1));
        expect(instance, equals(instance));
      });
      test('Different instances, same values', () {
        final instance1 = EveryTimeOfDayWrapper(every: EveryDueDayMonth(1));
        final instance2 = EveryTimeOfDayWrapper(every: EveryDueDayMonth(1));
        expect(instance1, equals(instance2));
      });
      test('Different every', () {
        final instance1 = EveryTimeOfDayWrapper(every: EveryDueDayMonth(1));
        final instance2 = EveryTimeOfDayWrapper(every: EveryDueDayMonth(2));
        expect(instance1, isNot(equals(instance2)));
      });
      test('Different everyTimeOfDay', () {
        final instance1 = EveryTimeOfDayWrapper(
          every: EveryDueDayMonth(1),
          everyTimeOfDay: EveryDueTimeOfDay(Duration(hours: 10)),
        );
        final instance2 = EveryTimeOfDayWrapper(
          every: EveryDueDayMonth(1),
          everyTimeOfDay: EveryDueTimeOfDay(Duration(hours: 12)),
        );
        expect(instance1, isNot(equals(instance2)));
      });
    });
  });
}
