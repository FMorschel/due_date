import 'package:due_date/src/helpers/date_reducer.dart';
import 'package:test/test.dart';

import '../src/date_time_match.dart';

void main() {
  group('DateReducer:', () {
    group('reduceFuture', () {
      // Oldest date should be returned.
      test('Returns the oldest date', () {
        final a = DateTime(2024, 7, 4);
        final b = DateTime(2024, 7, 5);
        expect(DateReducer.reduceFuture(a, b), isSameDateTime(a));
        expect(DateReducer.reduceFuture(b, a), isSameDateTime(a));
      });
      // If dates are equal, returns either.
      test('Returns the date itself if equal', () {
        final a = DateTime(2024, 7, 4);
        final b = DateTime(2024, 7, 4);
        expect(DateReducer.reduceFuture(a, b), isSameDateTime(a));
        expect(DateReducer.reduceFuture(a, b), isSameDateTime(b));
      });
    });
    group('reducePast', () {
      // Newest date should be returned.
      test('Returns the newest date', () {
        final a = DateTime(2024, 7, 4);
        final b = DateTime(2024, 7, 5);
        expect(DateReducer.reducePast(a, b), isSameDateTime(b));
        expect(DateReducer.reducePast(b, a), isSameDateTime(b));
      });
      // If dates are equal, returns either.
      test('Returns the date itself if equal', () {
        final a = DateTime(2024, 7, 4);
        final b = DateTime(2024, 7, 4);
        expect(DateReducer.reducePast(a, b), isSameDateTime(a));
        expect(DateReducer.reducePast(a, b), isSameDateTime(b));
      });
    });
    group('Edge cases', () {
      // Handles DateTime with time components.
      test('Handles time components', () {
        final a = DateTime(2024, 7, 4, 10, 30);
        final b = DateTime(2024, 7, 4, 12);
        expect(DateReducer.reduceFuture(a, b), isSameDateTime(a));
        expect(DateReducer.reducePast(a, b), isSameDateTime(b));
      });
      // Handles UTC and local DateTime.
      test('Handles UTC and local DateTime', () {
        // Create clearly different UTC and local times to avoid timezone
        // ambiguity.
        final earlierUtc = DateTime.utc(2024, 7, 4, 8);
        final laterLocal = DateTime(2024, 7, 4, 20);

        // Test with clearly earlier UTC time.
        expect(
          DateReducer.reduceFuture(earlierUtc, laterLocal),
          isSameDateTime(earlierUtc),
        );
        expect(
          DateReducer.reducePast(earlierUtc, laterLocal),
          isSameDateTime(laterLocal),
        );

        // Test with reversed order to ensure consistent behavior.
        expect(
          DateReducer.reduceFuture(laterLocal, earlierUtc),
          isSameDateTime(earlierUtc),
        );
        expect(
          DateReducer.reducePast(laterLocal, earlierUtc),
          isSameDateTime(laterLocal),
        );
      });
    });
  });
}
