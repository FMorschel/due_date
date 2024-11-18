import 'package:collection/collection.dart';
import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('DayPeriod', () {
    test('Hours', () {
      const generator = DayGenerator();
      const oneHour = Duration(hours: 1);
      final day = generator.of(DateTime(2020));
      final hours = day.hours;
      expect(hours, isA<List<HourPeriod>>());
      expect(hours, hasLength(24));
      expect(hours.none((hour) => hour.duration != oneHour), isTrue);
      expect(
        hours.first,
        equals(
          Period(
            start: DateTime(2020),
            end: DateTime(2020, 1, 1, 0, 59, 59, 999, 999),
          ),
        ),
      );
    });
  });
}
