import 'package:due_date/src/everies/date_time_limit_reached_exception.dart';
import 'package:test/test.dart';

void main() {
  group('DateTimeLimitReachedException:', () {
    group('Constructor', () {
      test('Can be created with valid date and limit', () {
        // January 1, 2024.
        final date = DateTime(2024);
        // January 2, 2024.
        final limit = DateTime(2024, 1, 2);

        final exception = DateTimeLimitReachedException(
          date: date,
          limit: limit,
        );

        expect(exception, isNotNull);
        expect(exception.date, equals(date));
        expect(exception.limit, equals(limit));
      });

      group('asserts limits', () {
        test('Date cannot be equal to limit', () {
          // January 1, 2024.
          final sameDate = DateTime(2024);

          expect(
            () => DateTimeLimitReachedException(
              date: sameDate,
              limit: sameDate,
            ),
            throwsA(isA<AssertionError>()),
          );
        });
      });
    });

    group('Properties', () {
      test('date property returns correct value', () {
        // January 1, 2024.
        final date = DateTime(2024);
        // January 2, 2024.
        final limit = DateTime(2024, 1, 2);

        final exception = DateTimeLimitReachedException(
          date: date,
          limit: limit,
        );

        expect(exception.date, equals(date));
      });

      test('limit property returns correct value', () {
        // January 1, 2024.
        final date = DateTime(2024);
        // January 2, 2024.
        final limit = DateTime(2024, 1, 2);

        final exception = DateTimeLimitReachedException(
          date: date,
          limit: limit,
        );

        expect(exception.limit, equals(limit));
      });
    });

    group('toString', () {
      test('Returns correct string representation', () {
        // January 1, 2024.
        final date = DateTime(2024);
        // January 2, 2024.
        final limit = DateTime(2024, 1, 2);

        final exception = DateTimeLimitReachedException(
          date: date,
          limit: limit,
        );

        final result = exception.toString();
        expect(result, contains('DateTimeLimitException'));
        expect(result, contains(date.toString()));
        expect(result, contains(limit.toString()));
        expect(result, contains('has passed'));
      });
    });
  });
}
