import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('ExactTimeOfDay on DateTime', () {
    test('Midnight', () {
      final date = DateTime(2023);
      expect(date.exactTimeOfDay, Duration.zero);
    });
    test('Noon', () {
      final date = DateTime(2023, 1, 1, 12);
      expect(date.exactTimeOfDay, const Duration(hours: 12));
    });
    test('Random time', () {
      final date = DateTime(2023, 1, 1, 15, 30, 45, 123, 456);
      expect(
        date.exactTimeOfDay,
        const Duration(
          hours: 15,
          minutes: 30,
          seconds: 45,
          milliseconds: 123,
          microseconds: 456,
        ),
      );
    });
  });
}
