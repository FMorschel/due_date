// ignore_for_file: prefer_const_constructors
import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('ClampInMonth on DateTime:', () {
    // July 11, 2022 is a date within July 2022.
    final date = DateTime.utc(2022, DateTime.july, 11);
    // July 1, 2022 is the start of the month.
    final july = DateTime.utc(2022, DateTime.july);

    test('Date in current month returns itself', () {
      expect(date.clampInMonth(july), equals(date));
    });

    test('Date before month clamps to first day of month', () {
      // June 30, 2022 is before July 2022.
      final before = DateTime.utc(2022, DateTime.june, 30);
      expect(before.clampInMonth(july), equals(july));
    });

    test('Date after month clamps to last day of month', () {
      // August 1, 2022 is after July 2022.
      final after = DateTime.utc(2022, DateTime.august);
      final lastDay = DateTime.utc(2022, DateTime.july, 31);
      expect(after.clampInMonth(july), equals(lastDay));
    });
  });
}
