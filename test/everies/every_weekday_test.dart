import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('EveryWeekday:', () {
    final august12th2022 = DateTime(2022, DateTime.august, 12);
    final august12th2022Utc = DateTime.utc(2022, DateTime.august, 12);

    group('Test base methods logic', () {
      group('startDate', () {
        final august13th = DateTime(2022, DateTime.august, 13);
        test('If the given date would be generated, return it', () {
          expect(
            Weekday.saturday.every.startDate(august13th),
            equals(august13th),
          );
        });
        test('If the given date would not be generated, use next', () {
          expect(
            Weekday.saturday.every.startDate(august12th2022),
            equals(Weekday.saturday.every.next(august12th2022)),
          );
        });
      });
      group('next', () {
        final august13th = DateTime(2022, DateTime.august, 13);
        final august20th = DateTime(2022, DateTime.august, 20);
        test(
          'If the given date would be generated, generate a new one anyway',
          () {
            expect(
              Weekday.saturday.every.next(august13th),
              equals(august20th),
            );
          },
        );
        test(
          'If the given date would not be generated, generate the next valid '
          'date',
          () {
            expect(
              Weekday.saturday.every.next(august12th2022),
              equals(august13th),
            );
          },
        );
      });
      group('previous', () {
        final august13th = DateTime(2022, DateTime.august, 13);
        final august6th = DateTime(2022, DateTime.august, 6);
        test(
          'If the given date would be generated, generate a new one anyway',
          () {
            expect(
              Weekday.saturday.every.previous(august13th),
              equals(august6th),
            );
          },
        );
        test(
          'If the given date would not be generated, generate the next valid '
          'date',
          () {
            expect(
              Weekday.saturday.every.previous(august12th2022),
              equals(august6th),
            );
          },
        );
      });
    });

    group('Every Saturday', () {
      const everySaturday = EveryWeekday(Weekday.saturday);
      group('Local', () {
        final august13th = DateTime(2022, DateTime.august, 13);
        test('This saturday', () {
          expect(everySaturday.startDate(august12th2022), equals(august13th));
        });
        test('Previous Saturday', () {
          final previousSaturday = DateTime(2022, DateTime.august, 6);
          expect(
            everySaturday.addWeeks(august13th, -1),
            equals(previousSaturday),
          );
        });
        test('Next Saturday', () {
          final nextSaturday = DateTime(2022, DateTime.august, 20);
          expect(
            everySaturday.addWeeks(august13th, 1),
            equals(nextSaturday),
          );
        });
      });
      group('UTC', () {
        final thisSaturdayUtc = DateTime.utc(2022, DateTime.august, 13);
        test('This saturday', () {
          expect(
            everySaturday.startDate(august12th2022Utc),
            equals(thisSaturdayUtc),
          );
        });
        test('Previous Saturday', () {
          final previousSaturdayUtc = DateTime.utc(2022, DateTime.august, 6);
          expect(
            everySaturday.addWeeks(thisSaturdayUtc, -1),
            equals(previousSaturdayUtc),
          );
        });
        test('Next Saturday', () {
          final nextSaturdayUtc = DateTime.utc(2022, DateTime.august, 20);
          expect(
            everySaturday.addWeeks(thisSaturdayUtc, 1),
            equals(nextSaturdayUtc),
          );
        });
      });
    });
    group('Every Wednesday', () {
      const everyWednesday = EveryWeekday(Weekday.wednesday);
      test('Local', () {
        final wednesday = DateTime(2022, DateTime.august, 17);
        expect(everyWednesday.startDate(august12th2022), equals(wednesday));
      });
      test('UTC', () {
        final wednesdayUtc = DateTime.utc(2022, DateTime.august, 17);
        expect(
          everyWednesday.startDate(august12th2022Utc),
          equals(wednesdayUtc),
        );
      });
    });
  });
}
