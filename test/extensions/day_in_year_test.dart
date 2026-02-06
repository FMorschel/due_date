import 'package:due_date/src/extensions/day_in_year.dart';
import 'package:test/test.dart';

void main() {
  group('DayInYear on DateTime', () {
    test('January 1st', () {
      expect(DateTime(2022).dayInYear, 1);
    });
    test('December 31st 2022', () {
      expect(DateTime(2022, DateTime.december, 31).dayInYear, 365);
    });
    test('December 31st 2020', () {
      expect(DateTime(2020, DateTime.december, 31).dayInYear, 366);
    });
  });
}
