import 'package:due_date/due_date.dart';
import 'package:due_date/src/helpers/helpers.dart';
import 'package:test/test.dart';

void main() {
  group('WorkdayHelper', () {
    group('getWorkdayNumberInMonth', () {
      test('should throw when date is a weekend', () {
        expect(
          () => WorkdayHelper.getWorkdayNumberInMonth(
            DateTime(2022),
            shouldThrow: true,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
      test(
          'should not throw when date shouldThrow is false and date is a '
          'weekend', () {
        expect(WorkdayHelper.getWorkdayNumberInMonth(DateTime(2022)), 0);
      });
      test('should not throw when date is a workday', () {
        expect(
          WorkdayHelper.getWorkdayNumberInMonth(
            DateTime(2022, DateTime.june, 7),
          ),
          5,
        );
      });
      test('If weekend, should always return 0', () {
        const every = EveryWeekday.weekend;
        for (var date = every.next(DateTime(2021, 12, 31));
            date.month < 2;
            date = every.next(date)) {
          expect(WorkdayHelper.getWorkdayNumberInMonth(date), 0);
        }
      });
      test('If workday, should never return 0', () {
        const every = EveryWeekday.workdays;
        for (var date = every.next(DateTime(2021, 12, 31));
            date.month < 2;
            date = every.next(date)) {
          expect(WorkdayHelper.getWorkdayNumberInMonth(date), isNot(0));
        }
        for (var date = every.next(DateTime(2023, 12, 31));
            date.month < 2;
            date = every.next(date)) {
          expect(WorkdayHelper.getWorkdayNumberInMonth(date), isNot(0));
        }
      });
    });
    group('adjustToWorkday', () {
      group('workday', () {
        test('isNext', () {
          final date = DateTime(2022, DateTime.june, 7);
          expect(
            WorkdayHelper.adjustToWorkday(date, isNext: true),
            equals(date),
          );
        });
        test('isPrevious', () {
          final date = DateTime(2022, DateTime.june, 7);
          expect(
            WorkdayHelper.adjustToWorkday(date, isNext: false),
            equals(date),
          );
        });
      });
      test('should return the next workday', () {
        final date = DateTime(2022, DateTime.june, 5);
        expect(
          WorkdayHelper.adjustToWorkday(date, isNext: true),
          equals(DateTime(2022, DateTime.june, 6)),
        );
      });
      test('should return the previous workday', () {
        final date = DateTime(2024, DateTime.november, 10);
        expect(
          WorkdayHelper.adjustToWorkday(date, isNext: false),
          equals(DateTime(2024, DateTime.november, 8)),
        );
      });
    });
  });
}
