// ignore_for_file: prefer_const_constructors

import 'package:due_date/src/helpers/date_reducer.dart';
import 'package:test/test.dart';

void main() {
  group('DateReducer:', () {
    group('reduceFuture', () {
      // Oldest date should be returned.
      test('Returns the oldest date', () {
        final a = DateTime(2024, 7, 4);
        final b = DateTime(2024, 7, 5);
        expect(DateReducer.reduceFuture(a, b), equals(a));
        expect(DateReducer.reduceFuture(b, a), equals(a));
      });
      // If dates are equal, returns either.
      test('Returns the date itself if equal', () {
        final a = DateTime(2024, 7, 4);
        final b = DateTime(2024, 7, 4);
        expect(DateReducer.reduceFuture(a, b), equals(a));
        expect(DateReducer.reduceFuture(a, b), equals(b));
      });
    });
    group('reducePast', () {
      // Newest date should be returned.
      test('Returns the newest date', () {
        final a = DateTime(2024, 7, 4);
        final b = DateTime(2024, 7, 5);
        expect(DateReducer.reducePast(a, b), equals(b));
        expect(DateReducer.reducePast(b, a), equals(b));
      });
      // If dates are equal, returns either.
      test('Returns the date itself if equal', () {
        final a = DateTime(2024, 7, 4);
        final b = DateTime(2024, 7, 4);
        expect(DateReducer.reducePast(a, b), equals(a));
        expect(DateReducer.reducePast(a, b), equals(b));
      });
    });
    group('Edge cases', () {
      // Handles DateTime with time components.
      test('Handles time components', () {
        final a = DateTime(2024, 7, 4, 10, 30);
        final b = DateTime(2024, 7, 4, 12);
        expect(DateReducer.reduceFuture(a, b), equals(a));
        expect(DateReducer.reducePast(a, b), equals(b));
      });
      // Handles UTC and local DateTime.
      // Handles UTC and local DateTime.
      test('Handles UTC and local DateTime', () {
        final local = DateTime(2024, 7, 4, 10, 30);
        final utc = DateTime.utc(2024, 7, 4, 10, 30);
        // They are not equal, so the one with isUtc: false is considered after.
        expect(
          DateReducer.reduceFuture(local, utc),
          equals(utc.isBefore(local) ? utc : local),
        );
        expect(
          DateReducer.reducePast(local, utc),
          equals(local.isAfter(utc) ? local : utc),
        );
      });
    });
  });
}
