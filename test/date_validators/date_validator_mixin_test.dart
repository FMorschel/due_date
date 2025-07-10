// ignore_for_file: prefer_const_constructors

import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

import '../src/date_validator_match.dart';

/// A simple test implementation of DateValidator using the mixin.
class _TestDateValidator with DateValidatorMixin {
  const _TestDateValidator(this.validWeekday);

  final int validWeekday;

  @override
  bool valid(DateTime date) => date.weekday == validWeekday;
}

void main() {
  group('DateValidatorMixin:', () {
    group('invalid method:', () {
      test('Returns opposite of valid method', () {
        // July 1, 2024 is Monday (weekday = 1).
        final mondayValidator = _TestDateValidator(DateTime.monday);
        final monday = DateTime(2024, 7);
        final tuesday = DateTime(2024, 7, 2);

        expect(mondayValidator.valid(monday), isTrue);
        expect(mondayValidator.invalid(monday), isFalse);

        expect(mondayValidator.valid(tuesday), isFalse);
        expect(mondayValidator.invalid(tuesday), isTrue);
      });

      test('Works with different validators', () {
        // July 3, 2024 is Wednesday (weekday = 3).
        final wednesdayValidator = _TestDateValidator(DateTime.wednesday);
        final wednesday = DateTime(2024, 7, 3);
        final thursday = DateTime(2024, 7, 4);

        expect(wednesdayValidator.valid(wednesday), isTrue);
        expect(wednesdayValidator.invalid(wednesday), isFalse);

        expect(wednesdayValidator.valid(thursday), isFalse);
        expect(wednesdayValidator.invalid(thursday), isTrue);
      });
    });

    group('validsIn method (deprecated):', () {
      test('Returns valid dates from collection', () {
        // July 1, 2024 is Monday.
        final mondayValidator = _TestDateValidator(DateTime.monday);
        final dates = [
          DateTime(2024, 7), // Monday
          DateTime(2024, 7, 2), // Tuesday
          DateTime(2024, 7, 8), // Monday
          DateTime(2024, 7, 9), // Tuesday
        ];

        // ignore: deprecated_member_use_from_same_package
        final validDates = mondayValidator.validsIn(dates).toList();

        expect(validDates, hasLength(2));
        expect(validDates[0], equals(DateTime(2024, 7)));
        expect(validDates[1], equals(DateTime(2024, 7, 8)));
      });

      test('Returns empty iterable when no valid dates', () {
        // July 2, 2024 is Tuesday.
        final tuesdayValidator = _TestDateValidator(DateTime.tuesday);
        final dates = [
          DateTime(2024, 7), // Monday
          DateTime(2024, 7, 3), // Wednesday
          DateTime(2024, 7, 8), // Monday
        ];

        // ignore: deprecated_member_use_from_same_package
        final validDates = tuesdayValidator.validsIn(dates).toList();

        expect(validDates, isEmpty);
      });

      test('Returns all dates when all are valid', () {
        // July 1, 2024 is Monday.
        final mondayValidator = _TestDateValidator(DateTime.monday);
        final dates = [
          DateTime(2024, 7), // Monday
          DateTime(2024, 7, 8), // Monday
          DateTime(2024, 7, 15), // Monday
        ];

        // ignore: deprecated_member_use_from_same_package
        final validDates = mondayValidator.validsIn(dates).toList();

        expect(validDates, hasLength(3));
        expect(validDates[0], equals(DateTime(2024, 7)));
        expect(validDates[1], equals(DateTime(2024, 7, 8)));
        expect(validDates[2], equals(DateTime(2024, 7, 15)));
      });

      test('Handles empty input collection', () {
        final mondayValidator = _TestDateValidator(DateTime.monday);
        final dates = <DateTime>[];

        // ignore: deprecated_member_use_from_same_package
        final validDates = mondayValidator.validsIn(dates).toList();

        expect(validDates, isEmpty);
      });
    });

    group('filterValidDates method:', () {
      test('Returns valid dates from collection', () {
        // July 1, 2024 is Monday.
        final mondayValidator = _TestDateValidator(DateTime.monday);
        final dates = [
          DateTime(2024, 7), // Monday
          DateTime(2024, 7, 2), // Tuesday
          DateTime(2024, 7, 8), // Monday
          DateTime(2024, 7, 9), // Tuesday
        ];

        final validDates = mondayValidator.filterValidDates(dates).toList();

        expect(validDates, hasLength(2));
        expect(validDates[0], equals(DateTime(2024, 7)));
        expect(validDates[1], equals(DateTime(2024, 7, 8)));
      });

      test('Returns empty iterable when no valid dates', () {
        // July 2, 2024 is Tuesday.
        final tuesdayValidator = _TestDateValidator(DateTime.tuesday);
        final dates = [
          DateTime(2024, 7), // Monday
          DateTime(2024, 7, 3), // Wednesday
          DateTime(2024, 7, 8), // Monday
        ];

        final validDates = tuesdayValidator.filterValidDates(dates).toList();

        expect(validDates, isEmpty);
      });

      test('Returns all dates when all are valid', () {
        // July 1, 2024 is Monday.
        final mondayValidator = _TestDateValidator(DateTime.monday);
        final dates = [
          DateTime(2024, 7), // Monday
          DateTime(2024, 7, 8), // Monday
          DateTime(2024, 7, 15), // Monday
        ];

        final validDates = mondayValidator.filterValidDates(dates).toList();

        expect(validDates, hasLength(3));
        expect(validDates[0], equals(DateTime(2024, 7)));
        expect(validDates[1], equals(DateTime(2024, 7, 8)));
        expect(validDates[2], equals(DateTime(2024, 7, 15)));
      });

      test('Handles empty input collection', () {
        final mondayValidator = _TestDateValidator(DateTime.monday);
        final dates = <DateTime>[];

        final validDates = mondayValidator.filterValidDates(dates).toList();

        expect(validDates, isEmpty);
      });

      test('Works with different weekday validators', () {
        // July 5, 2024 is Friday.
        final fridayValidator = _TestDateValidator(DateTime.friday);
        final dates = [
          DateTime(2024, 7), // Monday
          DateTime(2024, 7, 5), // Friday
          DateTime(2024, 7, 12), // Friday
          DateTime(2024, 7, 15), // Monday
        ];

        final validDates = fridayValidator.filterValidDates(dates).toList();

        expect(validDates, hasLength(2));
        expect(validDates[0], equals(DateTime(2024, 7, 5)));
        expect(validDates[1], equals(DateTime(2024, 7, 12)));
      });

      test('Is lazy and yields results one by one', () {
        final mondayValidator = _TestDateValidator(DateTime.monday);
        final dates = [
          DateTime(2024, 7), // Monday
          DateTime(2024, 7, 2), // Tuesday
          DateTime(2024, 7, 8), // Monday
        ];

        final validDatesIterable = mondayValidator.filterValidDates(dates);

        // Test that it's a lazy iterable by taking only the first result
        final firstValid = validDatesIterable.first;
        expect(firstValid, equals(DateTime(2024, 7)));
      });
    });

    group('validsIn and filterValidDates consistency:', () {
      test('Both methods return same results', () {
        // July 6, 2024 is Saturday.
        final saturdayValidator = _TestDateValidator(DateTime.saturday);
        final dates = [
          DateTime(2024, 7), // Monday
          DateTime(2024, 7, 6), // Saturday
          DateTime(2024, 7, 7), // Sunday
          DateTime(2024, 7, 13), // Saturday
          DateTime(2024, 7, 20), // Saturday
        ];

        // ignore: deprecated_member_use_from_same_package
        final validsInResult = saturdayValidator.validsIn(dates).toList();
        final filterValidDatesResult =
            saturdayValidator.filterValidDates(dates).toList();

        expect(validsInResult, equals(filterValidDatesResult));
        expect(validsInResult, hasLength(3));
        expect(validsInResult[0], equals(DateTime(2024, 7, 6)));
        expect(validsInResult[1], equals(DateTime(2024, 7, 13)));
        expect(validsInResult[2], equals(DateTime(2024, 7, 20)));
      });
    });

    group('Integration with DateValidator matchers:', () {
      test('Works with isValid matcher', () {
        // July 7, 2024 is Sunday.
        final sundayValidator = _TestDateValidator(DateTime.sunday);
        final sunday = DateTime(2024, 7, 7);

        expect(sundayValidator, isValid(sunday));
      });

      test('Works with isInvalid matcher', () {
        // July 7, 2024 is Sunday.
        final sundayValidator = _TestDateValidator(DateTime.sunday);
        final monday = DateTime(2024, 7);

        expect(sundayValidator, isInvalid(monday));
      });
    });

    group('Edge cases:', () {
      test('Handles leap year dates', () {
        // February 29, 2024 is Thursday (leap year).
        final thursdayValidator = _TestDateValidator(DateTime.thursday);
        final leapYearDate = DateTime(2024, 2, 29);

        expect(thursdayValidator.valid(leapYearDate), isTrue);
        expect(thursdayValidator.invalid(leapYearDate), isFalse);
      });

      test('Handles year boundaries', () {
        // December 31, 2023 is Sunday.
        // January 1, 2024 is Monday.
        final sundayValidator = _TestDateValidator(DateTime.sunday);
        final lastDayOfYear = DateTime(2023, 12, 31);
        final firstDayOfYear = DateTime(2024);

        expect(sundayValidator.valid(lastDayOfYear), isTrue);
        expect(sundayValidator.valid(firstDayOfYear), isFalse);
      });

      test('Handles different time components', () {
        // July 1, 2024 is Monday regardless of time.
        final mondayValidator = _TestDateValidator(DateTime.monday);
        final morningMonday = DateTime(2024, 7, 1, 8, 30);
        final eveningMonday = DateTime(2024, 7, 1, 20, 45, 30);

        expect(mondayValidator.valid(morningMonday), isTrue);
        expect(mondayValidator.valid(eveningMonday), isTrue);
      });
    });
  });
}
