import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('EndOfDay', () {
    group('2022-07-11', () {
      test('utc', () {
        final date = DateTime.utc(2022, DateTime.july, 11);
        final result = DateTime.utc(
          2022,
          DateTime.july,
          11,
          23,
          59,
          59,
          999,
          999,
        );
        expect(date.endOfDay, equals(result));
      });
      test('local', () {
        final date = DateTime(2022, DateTime.july, 11);
        final result = DateTime(
          2022,
          DateTime.july,
          11,
          23,
          59,
          59,
          999,
          999,
        );
        expect(date.endOfDay, equals(result));
      });
    });
    group('2022-07-11 23:59:59:999:999', () {
      test('utc', () {
        final date = DateTime.utc(
          2022,
          DateTime.july,
          11,
          23,
          59,
          59,
          999,
          999,
        );
        final result = date;
        expect(date.endOfDay, equals(result));
      });
      test('local', () {
        final date = DateTime(
          2022,
          DateTime.july,
          11,
          23,
          59,
          59,
          999,
          999,
        );
        final result = date;
        expect(date.endOfDay, equals(result));
      });
    });
  });
}
