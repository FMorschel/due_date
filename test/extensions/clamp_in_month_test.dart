import 'package:clock/clock.dart';
import 'package:due_date/src/due_date.dart';
import 'package:due_date/src/everies/every_due_day_month.dart';
import 'package:due_date/src/extensions/clamp_in_month.dart';
import 'package:test/test.dart';
import 'package:time/time.dart';

import '../src/date_time_match.dart';

void main() {
  group('ClampInMonth on DateTime:', () {
    group('dueDateTime getter', () {
      test('Returns DueDateTime with correct date', () {
        // July 11, 2022 is a Monday.
        final date = DateTime.utc(2022, DateTime.july, 11);
        final dueDateTime = date.dueDateTime;

        expect(dueDateTime, isA<DueDateTime>());
        expect(dueDateTime.date, isSameDateTime(date));
      });

      test('Returns DueDateTime with EveryDueDayMonth based on day', () {
        // July 15, 2022 is the 15th day of the month.
        final date = DateTime.utc(2022, DateTime.july, 15);
        final dueDateTime = date.dueDateTime;

        expect(dueDateTime.every, isA<EveryDueDayMonth>());
        expect(dueDateTime.every.dueDay, equals(15));
      });

      test('Works with first day of month', () {
        // July 1, 2022 is the first day of the month.
        final date = DateTime.utc(2022, DateTime.july);
        final dueDateTime = date.dueDateTime;

        expect(dueDateTime.date, isSameDateTime(date));
        expect(dueDateTime.every.dueDay, equals(1));
      });

      test('Works with last day of month', () {
        // July 31, 2022 is the last day of July.
        final date = DateTime.utc(2022, DateTime.july, 31);
        final dueDateTime = date.dueDateTime;

        expect(dueDateTime.date, isSameDateTime(date));
        expect(dueDateTime.every.dueDay, equals(31));
      });

      test('Works with leap year February', () {
        // February 29, 2020 is in a leap year.
        final date = DateTime.utc(2020, DateTime.february, 29);
        final dueDateTime = date.dueDateTime;

        expect(dueDateTime.date, isSameDateTime(date));
        expect(dueDateTime.every.dueDay, equals(29));
      });

      test('Works with different years', () {
        // December 25, 2023 is Christmas.
        final date = DateTime.utc(2023, DateTime.december, 25);
        final dueDateTime = date.dueDateTime;

        expect(dueDateTime.date, isSameDateTime(date));
        expect(dueDateTime.every.dueDay, equals(25));
      });
    });

    group('clampInMonth method', () {
      // July 11, 2022 is a date within July 2022.
      final date = DateTime.utc(2022, DateTime.july, 11);
      // July 1, 2022 is the start of the month.
      final july = DateTime.utc(2022, DateTime.july);

      test('Date in current month returns itself', () {
        expect(date.clampInMonth(july), isSameDateTime(date));
      });

      test('Date before month clamps to first day of month', () {
        // June 30, 2022 is before July 2022.
        final before = DateTime.utc(2022, DateTime.june, 30);
        expect(before.clampInMonth(july), isSameDateTime(july));
      });

      test('Date after month clamps to last day of month', () {
        // August 1, 2022 is after July 2022.
        final after = DateTime.utc(2022, DateTime.august);
        final lastDay = DateTime.utc(2022, DateTime.july, 31);
        expect(after.clampInMonth(july), isSameDateTime(lastDay));
      });

      test('Works with different months', () {
        // Test with February (short month).
        final february = DateTime.utc(2022, DateTime.february);

        // January 31, 2022 is before February.
        final beforeFeb = DateTime.utc(2022, DateTime.january, 31);
        expect(beforeFeb.clampInMonth(february), isSameDateTime(february));

        // March 1, 2022 is after February.
        final afterFeb = DateTime.utc(2022, DateTime.march);
        final lastDayFeb = DateTime.utc(2022, DateTime.february, 28);
        expect(afterFeb.clampInMonth(february), isSameDateTime(lastDayFeb));
      });

      test('Works with leap year February', () {
        // February 2020 is a leap year.
        final february2020 = DateTime.utc(2020, DateTime.february);

        // March 1, 2020 is after February.
        final afterFeb = DateTime.utc(2020, DateTime.march);
        final lastDayFeb = DateTime.utc(2020, DateTime.february, 29);
        expect(afterFeb.clampInMonth(february2020), isSameDateTime(lastDayFeb));
      });

      test('Works with dates far in the past', () {
        // January 1, 2000 is far before July 2022.
        final farPast = DateTime.utc(2000);
        expect(farPast.clampInMonth(july), isSameDateTime(july));
      });

      test('Works with dates far in the future', () {
        // December 31, 2030 is far after July 2022.
        final farFuture = DateTime.utc(2030, DateTime.december, 31);
        final lastDayJuly = DateTime.utc(2022, DateTime.july, 31);
        expect(farFuture.clampInMonth(july), isSameDateTime(lastDayJuly));
      });

      test('Works with same month but different year', () {
        // July 15, 2021 is in July but different year.
        final july2021 = DateTime.utc(2021, DateTime.july, 15);

        // Should clamp to July 1, 2022.
        expect(july2021.clampInMonth(july), isSameDateTime(july));
      });

      test('Preserves time components when clamping', () {
        final julyWithTime = DateTime.utc(2022, DateTime.july, 1, 10, 30, 45);

        // June 30, 2022 with time should clamp to July 1 with same time.
        final beforeWithTime = DateTime.utc(
          2022,
          DateTime.june,
          30,
          15,
          45,
          20,
        );
        final clamped = beforeWithTime.clampInMonth(julyWithTime);

        expect(clamped.year, equals(2022));
        expect(clamped.month, equals(DateTime.july));
        expect(clamped.day, equals(1));
        expect(clamped.hour, equals(15));
        expect(clamped.minute, equals(45));
        expect(clamped.second, equals(20));
      });
    });

    group('Edge Cases', () {
      test('Works with DateTime.now()', () {
        final now = DateTime.now();
        withClock(Clock.fixed(now), () {
          final dueDateTime = now.dueDateTime;

          expect(dueDateTime, isSameDateTime(DueDateTime.now()));
          expect(dueDateTime.every.dueDay, equals(DueDateTime.now().day));
        });
      });

      test('clampInMonth with same date returns same date', () {
        final date = DateTime.utc(2022, DateTime.july, 15);
        final monthReference = DateTime.utc(2022, DateTime.july, 10);

        expect(date.clampInMonth(monthReference), isSameDateTime(date));
      });

      test('clampInMonth with exact month boundaries', () {
        // Test with first day of month.
        final firstDay = DateTime.utc(2022, DateTime.july);
        final monthRef = DateTime.utc(2022, DateTime.july, 15);
        expect(firstDay.clampInMonth(monthRef), isSameDateTime(firstDay));

        // Test with last day of month.
        final lastDay = DateTime.utc(2022, DateTime.july, 31);
        expect(lastDay.clampInMonth(monthRef), isSameDateTime(lastDay));
      });
    });
  });
}
