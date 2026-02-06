import 'package:due_date/src/enums/weekday.dart';
import 'package:due_date/src/extensions/week_calc.dart';
import 'package:test/test.dart';

void main() {
  group('WeekCalc on DateTime:', () {
    group('Next Weekday', () {
      final august = DateTime.utc(2022, DateTime.august);
      test('Monday', () {
        expect(
          august.nextWeekday(Weekday.monday),
          equals(DateTime.utc(2022, DateTime.august)),
        );
      });
      test('Tuesday', () {
        expect(
          august.nextWeekday(Weekday.tuesday),
          equals(DateTime.utc(2022, DateTime.august, 2)),
        );
      });
      test('Wednesday', () {
        expect(
          august.nextWeekday(Weekday.wednesday),
          equals(DateTime.utc(2022, DateTime.august, 3)),
        );
      });
      test('Thursday', () {
        expect(
          august.nextWeekday(Weekday.thursday),
          equals(DateTime.utc(2022, DateTime.august, 4)),
        );
      });
      test('Friday', () {
        expect(
          august.nextWeekday(Weekday.friday),
          equals(DateTime.utc(2022, DateTime.august, 5)),
        );
      });
      test('Saturday', () {
        expect(
          august.nextWeekday(Weekday.saturday),
          equals(DateTime.utc(2022, DateTime.august, 6)),
        );
      });
      test('Sunday', () {
        expect(
          august.nextWeekday(Weekday.sunday),
          equals(DateTime.utc(2022, DateTime.august, 7)),
        );
      });
    });
    group('Previous Weekday', () {
      final august = DateTime.utc(2022, DateTime.august);
      test('Monday', () {
        expect(
          august.previousWeekday(Weekday.monday),
          equals(DateTime.utc(2022, DateTime.august)),
        );
      });
      test('Tuesday', () {
        expect(
          august.previousWeekday(Weekday.tuesday),
          equals(DateTime.utc(2022, DateTime.july, 26)),
        );
      });
      test('Wednesday', () {
        expect(
          august.previousWeekday(Weekday.wednesday),
          equals(DateTime.utc(2022, DateTime.july, 27)),
        );
      });
      test('Thursday', () {
        expect(
          august.previousWeekday(Weekday.thursday),
          equals(DateTime.utc(2022, DateTime.july, 28)),
        );
      });
      test('Friday', () {
        expect(
          august.previousWeekday(Weekday.friday),
          equals(DateTime.utc(2022, DateTime.july, 29)),
        );
      });
      test('Saturday', () {
        expect(
          august.previousWeekday(Weekday.saturday),
          equals(DateTime.utc(2022, DateTime.july, 30)),
        );
      });
      test('Sunday', () {
        expect(
          august.previousWeekday(Weekday.sunday),
          equals(DateTime.utc(2022, DateTime.july, 31)),
        );
      });
    });
  });
}
