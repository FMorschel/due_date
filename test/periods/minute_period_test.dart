import 'package:collection/collection.dart';
import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('MinutePeriod', () {
    test('Seconds', () {
      const generator = MinuteGenerator();
      const oneSecond = Duration(seconds: 1);
      final minute = generator.of(DateTime(2020));
      final seconds = minute.seconds;
      expect(seconds, isA<List<SecondPeriod>>());
      expect(seconds, hasLength(60));
      expect(seconds.none((second) => second.duration != oneSecond), isTrue);
      expect(
        seconds.first,
        equals(
          Period(
            start: DateTime(2020),
            end: DateTime(2020, 1, 1, 0, 0, 0, 999, 999),
          ),
        ),
      );
      expect(
        seconds.last,
        equals(
          Period(
            start: DateTime(2020, 1, 1, 0, 0, 59),
            end: DateTime(2020, 1, 1, 0, 0, 59, 999, 999),
          ),
        ),
      );
    });
  });
}
