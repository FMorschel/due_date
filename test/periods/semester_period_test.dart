import 'package:due_date/period.dart';
import 'package:test/test.dart';

void main() {
  group('SemesterPeriod:', () {
    group('Constructor', () {
      group('Valid cases', () {
        test('Creates SemesterPeriod with valid start and end', () {
          final start = DateTime(2024);
          final end = DateTime(2024, 6, 30, 23, 59, 59, 999, 999);
          expect(SemesterPeriod(start: start, end: end), isNotNull);
        });

        test('Creates SemesterPeriod with UTC dates', () {
          final start = DateTime.utc(2024);
          final end = DateTime.utc(2024, 6, 30, 23, 59, 59, 999, 999);
          expect(SemesterPeriod(start: start, end: end), isNotNull);
        });

        test('Works with second semester', () {
          final start = DateTime(2024, 7);
          final end = DateTime(2024, 12, 31, 23, 59, 59, 999, 999);
          expect(SemesterPeriod(start: start, end: end), isNotNull);
        });
      });

      group('Validation errors', () {
        test('Throws AssertionError if duration is not exactly 6 months', () {
          final start = DateTime(2024);
          // 7 months.
          final end = DateTime(2024, 7, 31, 23, 59, 59, 999, 999);
          expect(
            () => SemesterPeriod(start: start, end: end),
            throwsA(isA<AssertionError>()),
          );
        });

        test('Throws AssertionError if end is not last microsecond of semester',
            () {
          final start = DateTime(2024);
          final end = DateTime(2024, 6, 30, 23, 59, 59, 999, 998);
          expect(
            () => SemesterPeriod(start: start, end: end),
            throwsArgumentError,
          );
        });
      });
    });

    group('Properties', () {
      test('Duration varies by semester due to different month lengths', () {
        // First semester 2024: Jan(31) + Feb(29) + Mar(31) + Apr(30) + May(31)
        // + Jun(30) = 182 days.
        final s1_2024 = SemesterPeriod(
          start: DateTime(2024),
          end: DateTime(2024, 6, 30, 23, 59, 59, 999, 999),
        );
        expect(s1_2024.duration, equals(const Duration(days: 182)));

        // Second semester 2024: Jul(31) + Aug(31) + Sep(30) + Oct(31) +
        // Nov(30) + Dec(31) = 184 days.
        final s2_2024 = SemesterPeriod(
          start: DateTime(2024, 7),
          end: DateTime(2024, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(s2_2024.duration, equals(const Duration(days: 184)));

        // First semester 2023 (non-leap): Jan(31) + Feb(28) + Mar(31) +
        // Apr(30) + May(31) + Jun(30) = 181 days.
        final s1_2023 = SemesterPeriod(
          start: DateTime(2023),
          end: DateTime(2023, 6, 30, 23, 59, 59, 999, 999),
        );
        expect(s1_2023.duration, equals(const Duration(days: 181)));
      });

      test('Start and end are properly set', () {
        final semester = SemesterPeriod(
          start: DateTime(2024),
          end: DateTime(2024, 6, 30, 23, 59, 59, 999, 999),
        );
        expect(semester.start.day, equals(1));
        // First semester starts in January.
        expect(semester.start.month, equals(1));
        expect(semester.end.day, equals(30));
        // First semester ends in June.
        expect(semester.end.month, equals(6));
      });
    });

    group('Months property', () {
      test('Returns 6 MonthPeriod objects', () {
        final semester = SemesterPeriod(
          start: DateTime(2020),
          end: DateTime(2020, 6, 30, 23, 59, 59, 999, 999),
        );
        final months = semester.months;
        expect(months, isA<List<MonthPeriod>>());
        expect(months, hasLength(6));
        expect(months.every((month) => month.start.year == 2020), isTrue);
      });

      test('First month starts at semester start', () {
        final semester = SemesterPeriod(
          start: DateTime(2020),
          end: DateTime(2020, 6, 30, 23, 59, 59, 999, 999),
        );
        final months = semester.months;
        expect(
          months.first,
          equals(
            Period(
              start: DateTime(2020),
              end: DateTime(2020, 1, 31, 23, 59, 59, 999, 999),
            ),
          ),
        );
      });

      test('Last month ends at semester end', () {
        final semester = SemesterPeriod(
          start: DateTime(2020),
          end: DateTime(2020, 6, 30, 23, 59, 59, 999, 999),
        );
        final months = semester.months;
        expect(
          months.last,
          equals(
            Period(
              start: DateTime(2020, 6),
              end: DateTime(2020, 6, 30, 23, 59, 59, 999, 999),
            ),
          ),
        );
      });

      test('Months progress correctly through semester', () {
        // First semester.
        final semester = SemesterPeriod(
          start: DateTime(2024),
          end: DateTime(2024, 6, 30, 23, 59, 59, 999, 999),
        );
        final months = semester.months;

        // January.
        expect(months.first.start.month, equals(1));
        // February.
        expect(months[1].start.month, equals(2));
        // March.
        expect(months[2].start.month, equals(3));
        // April.
        expect(months[3].start.month, equals(4));
        // May.
        expect(months[4].start.month, equals(5));
        // June.
        expect(months[5].start.month, equals(6));
      });

      test('Months cover entire semester with no gaps', () {
        // Second semester.
        final semester = SemesterPeriod(
          start: DateTime(2024, 7),
          end: DateTime(2024, 12, 31, 23, 59, 59, 999, 999),
        );
        final months = semester.months;

        // Check no gaps between consecutive months.
        for (var i = 0; i < months.length - 1; i++) {
          final currentEnd = months[i].end;
          final nextStart = months[i + 1].start;
          expect(
            nextStart.difference(currentEnd),
            equals(const Duration(microseconds: 1)),
          );
        }
      });
    });

    group('Semester progression', () {
      test('First semester contains January through June', () {
        final s1 = SemesterPeriod(
          start: DateTime(2024),
          end: DateTime(2024, 6, 30, 23, 59, 59, 999, 999),
        );
        final months = s1.months;

        for (var i = 0; i < 6; i++) {
          expect(months[i].start.month, equals(i + 1));
        }
      });

      test('Second semester contains July through December', () {
        final s2 = SemesterPeriod(
          start: DateTime(2024, 7),
          end: DateTime(2024, 12, 31, 23, 59, 59, 999, 999),
        );
        final months = s2.months;

        for (var i = 0; i < 6; i++) {
          expect(months[i].start.month, equals(i + 7));
        }
      });
    });

    group('Edge cases', () {
      test('Handles leap year February correctly in first semester', () {
        // Leap year.
        final s1_2024 = SemesterPeriod(
          start: DateTime(2024),
          end: DateTime(2024, 6, 30, 23, 59, 59, 999, 999),
        );
        // Non-leap year.
        final s1_2023 = SemesterPeriod(
          start: DateTime(2023),
          end: DateTime(2023, 6, 30, 23, 59, 59, 999, 999),
        );

        // Extra day for leap year.
        expect(s1_2024.duration.inDays, equals(182));
        // Standard year.
        expect(s1_2023.duration.inDays, equals(181));
      });

      test('Works at year boundaries', () {
        final semester = SemesterPeriod(
          start: DateTime(2024, 7),
          end: DateTime(2024, 12, 31, 23, 59, 59, 999, 999),
        );
        final months = semester.months;

        expect(months, hasLength(6));
        // July.
        expect(months.first.start.month, equals(7));
        // December.
        expect(months[5].start.month, equals(12));
      });

      test('All months have correct year', () {
        final semester = SemesterPeriod(
          start: DateTime(2024),
          end: DateTime(2024, 6, 30, 23, 59, 59, 999, 999),
        );
        final months = semester.months;

        for (final month in months) {
          expect(month.start.year, equals(2024));
          expect(month.end.year, equals(2024));
        }
      });
    });

    group('Equality', () {
      final start1 = DateTime(2024);
      final end1 = DateTime(2024, 6, 30, 23, 59, 59, 999, 999);
      final semester1 = SemesterPeriod(start: start1, end: end1);

      final start2 = DateTime(2024, 7);
      final end2 = DateTime(2024, 12, 31, 23, 59, 59, 999, 999);
      final semester2 = SemesterPeriod(start: start2, end: end2);

      final semester3 = SemesterPeriod(start: start1, end: end1);

      test('Same instance equals itself', () {
        expect(semester1, equals(semester1));
      });

      test('Different semesters are not equal', () {
        expect(semester1, isNot(equals(semester2)));
      });

      test('Same start and end dates are equal', () {
        expect(semester1, equals(semester3));
      });

      test('HashCode is consistent', () {
        expect(semester1.hashCode, equals(semester3.hashCode));
        expect(semester1.hashCode, isNot(equals(semester2.hashCode)));
      });
    });
  });

  group('YearPeriod:', () {
    group('Constructor', () {
      group('Valid cases', () {
        test('Creates YearPeriod with valid start and end', () {
          final start = DateTime(2024);
          final end = DateTime(2024, 12, 31, 23, 59, 59, 999, 999);
          expect(YearPeriod(start: start, end: end), isNotNull);
        });

        test('Creates YearPeriod with UTC dates', () {
          final start = DateTime.utc(2024);
          final end = DateTime.utc(2024, 12, 31, 23, 59, 59, 999, 999);
          expect(YearPeriod(start: start, end: end), isNotNull);
        });
      });

      group('Validation errors', () {
        test('Throws AssertionError if duration is not exactly 12 months', () {
          final start = DateTime(2024);
          // 13 months.
          final end = DateTime(2025, 1, 31, 23, 59, 59, 999, 999);
          expect(
            () => YearPeriod(start: start, end: end),
            throwsA(isA<AssertionError>()),
          );
        });

        test('Throws ArgumentError if end is not last microsecond of year', () {
          final start = DateTime(2024);
          final end = DateTime(2024, 12, 31, 23, 59, 59, 999, 998);
          expect(
            () => YearPeriod(start: start, end: end),
            throwsArgumentError,
          );
        });
      });
    });

    group('Properties', () {
      test('Duration varies by year type', () {
        // Leap year has 366 days.
        final year2024 = YearPeriod(
          start: DateTime(2024),
          end: DateTime(2024, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(year2024.duration, equals(const Duration(days: 366)));

        // Non-leap year has 365 days.
        final year2023 = YearPeriod(
          start: DateTime(2023),
          end: DateTime(2023, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(year2023.duration, equals(const Duration(days: 365)));
      });

      test('Start and end are properly set', () {
        final year = YearPeriod(
          start: DateTime(2024),
          end: DateTime(2024, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(year.start.day, equals(1));
        expect(year.start.month, equals(1));
        expect(year.start.year, equals(2024));
        expect(year.end.day, equals(31));
        expect(year.end.month, equals(12));
        expect(year.end.year, equals(2024));
      });
    });

    group('Months property', () {
      test('Returns 12 MonthPeriod objects', () {
        final year = YearPeriod(
          start: DateTime(2020),
          end: DateTime(2020, 12, 31, 23, 59, 59, 999, 999),
        );
        final months = year.months;
        expect(months, isA<List<MonthPeriod>>());
        expect(months, hasLength(12));
        expect(months.every((month) => month.start.year == 2020), isTrue);
      });

      test('First month starts at year start', () {
        final year = YearPeriod(
          start: DateTime(2020),
          end: DateTime(2020, 12, 31, 23, 59, 59, 999, 999),
        );
        final months = year.months;
        expect(
          months.first,
          equals(
            Period(
              start: DateTime(2020),
              end: DateTime(2020, 1, 31, 23, 59, 59, 999, 999),
            ),
          ),
        );
      });

      test('Last month ends at year end', () {
        final year = YearPeriod(
          start: DateTime(2020),
          end: DateTime(2020, 12, 31, 23, 59, 59, 999, 999),
        );
        final months = year.months;
        expect(
          months.last,
          equals(
            Period(
              start: DateTime(2020, 12),
              end: DateTime(2020, 12, 31, 23, 59, 59, 999, 999),
            ),
          ),
        );
      });

      test('Months progress correctly through year', () {
        final year = YearPeriod(
          start: DateTime(2024),
          end: DateTime(2024, 12, 31, 23, 59, 59, 999, 999),
        );
        final months = year.months;

        for (var i = 0; i < 12; i++) {
          expect(months[i].start.month, equals(i + 1));
          expect(months[i].start.year, equals(2024));
        }
      });

      test('Months cover entire year with no gaps', () {
        final year = YearPeriod(
          start: DateTime(2024),
          end: DateTime(2024, 12, 31, 23, 59, 59, 999, 999),
        );
        final months = year.months;

        // Check no gaps between consecutive months.
        for (var i = 0; i < months.length - 1; i++) {
          final currentEnd = months[i].end;
          final nextStart = months[i + 1].start;
          expect(
            nextStart.difference(currentEnd),
            equals(const Duration(microseconds: 1)),
          );
        }
      });

      test('February has correct number of days in leap/non-leap years', () {
        // Leap year.
        final year2024 = YearPeriod(
          start: DateTime(2024),
          end: DateTime(2024, 12, 31, 23, 59, 59, 999, 999),
        );
        final feb2024 = year2024.months[1];
        // February (index 1).
        expect(feb2024.duration.inDays, equals(29));

        // Non-leap year.
        final year2023 = YearPeriod(
          start: DateTime(2023),
          end: DateTime(2023, 12, 31, 23, 59, 59, 999, 999),
        );
        final feb2023 = year2023.months[1];
        // February (index 1).
        expect(feb2023.duration.inDays, equals(28));
      });
    });

    group('Edge cases', () {
      test('Handles century years correctly', () {
        // 2000 was a leap year (divisible by 400).
        final year2000 = YearPeriod(
          start: DateTime.utc(2000),
          end: DateTime.utc(2000, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(year2000.duration.inDays, equals(366));

        // 1900 was not a leap year (divisible by 100 but not 400).
        final year1900 = YearPeriod(
          start: DateTime.utc(1900),
          end: DateTime.utc(1900, 12, 31, 23, 59, 59, 999, 999),
        );
        expect(year1900.duration.inDays, equals(365));
      });

      test('All months have same year', () {
        final year = YearPeriod(
          start: DateTime(2024),
          end: DateTime(2024, 12, 31, 23, 59, 59, 999, 999),
        );
        final months = year.months;

        for (final month in months) {
          expect(month.start.year, equals(2024));
          expect(month.end.year, equals(2024));
        }
      });
    });

    group('Equality', () {
      final start1 = DateTime(2024);
      final end1 = DateTime(2024, 12, 31, 23, 59, 59, 999, 999);
      final year1 = YearPeriod(start: start1, end: end1);

      final start2 = DateTime(2025);
      final end2 = DateTime(2025, 12, 31, 23, 59, 59, 999, 999);
      final year2 = YearPeriod(start: start2, end: end2);

      final year3 = YearPeriod(start: start1, end: end1);

      test('Same instance equals itself', () {
        expect(year1, equals(year1));
      });

      test('Different years are not equal', () {
        expect(year1, isNot(equals(year2)));
      });

      test('Same start and end dates are equal', () {
        expect(year1, equals(year3));
      });

      test('HashCode is consistent', () {
        expect(year1.hashCode, equals(year3.hashCode));
        expect(year1.hashCode, isNot(equals(year2.hashCode)));
      });
    });
  });
}
