import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('ClampInMonth on DateTime:', () {
    final date = DateTime.utc(2022, DateTime.july, 11);
    final july = DateTime.utc(2022, DateTime.july);
    test('Current month', () {
      expect(date.clampInMonth(july), equals(date));
    });
  });
}
