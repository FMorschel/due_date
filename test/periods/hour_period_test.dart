import 'package:collection/collection.dart';
import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('HourPeriod', () {
    test('Minutes', () {
      const generator = HourGenerator();
      const oneMinute = Duration(minutes: 1);
      final hour = generator.of(DateTime(2020));
      final minutes = hour.minutes;
      expect(minutes, isA<List<MinutePeriod>>());
      expect(minutes, hasLength(60));
      expect(minutes.none((minute) => minute.duration != oneMinute), isTrue);
      expect(
        minutes.first,
        equals(
          Period(
            start: DateTime(2020),
            end: DateTime(2020, 1, 1, 0, 0, 59, 999, 999),
          ),
        ),
      );
      expect(
        minutes.last,
        equals(
          Period(
            start: DateTime(2020, 1, 1, 0, 59),
            end: DateTime(2020, 1, 1, 0, 59, 59, 999, 999),
          ),
        ),
      );
    });
  });
}
