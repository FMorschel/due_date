import 'package:due_date/due_date.dart';
import 'package:test/test.dart';

void main() {
  group('DateValidatorWeekday:', () {
    group('Monday', () {
      final validator = DateValidatorWeekday(Weekday.monday);
      test('Monday is valid', () {
        expect(validator.valid(DateTime(2022, DateTime.september, 26)), isTrue);
      });

      test('Tuesday is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 27)),
          isFalse,
        );
      });
    });
  });
  group('DateValidatorDueDayMonth:', () {
    group('Day 2', () {
      final validator = DateValidatorDueDayMonth(2);
      test('Is valid', () {
        expect(validator.valid(DateTime(2022, DateTime.september, 2)), isTrue);
      });

      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 27)),
          isFalse,
        );
      });
    });
    group('Day 31 not exact', () {
      final validator = DateValidatorDueDayMonth(31);
      group('Is valid', () {
        test('February', () {
          expect(
            validator.valid(DateTime(2022, DateTime.february, 28)),
            isTrue,
          );
        });
        test('September', () {
          expect(
            validator.valid(DateTime(2022, DateTime.september, 30)),
            isTrue,
          );
        });
      });
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 27)),
          isFalse,
        );
      });
    });
    group('Day 31 exact', () {
      final validator = DateValidatorDueDayMonth(31, exact: true);
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.october, 31)),
          isTrue,
        );
      });
      group('Is not valid', () {
        test('February', () {
          expect(
            validator.valid(DateTime(2022, DateTime.february, 28)),
            isFalse,
          );
        });
        test('September', () {
          expect(
            validator.valid(DateTime(2022, DateTime.september, 27)),
            isFalse,
          );
        });
      });
    });
  });
  group('DateValidatorWeekdayCountInMonth', () {
    group('First Monday', () {
      final validator = DateValidatorWeekdayCountInMonth(
        week: Week.first,
        day: Weekday.monday,
      );
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 5)),
          isTrue,
        );
      });
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 6)),
          isFalse,
        );
      });
    });
    group('Second Tuesday', () {
      final validator = DateValidatorWeekdayCountInMonth(
        day: Weekday.tuesday,
        week: Week.second,
      );
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 13)),
          isTrue,
        );
      });
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 5)),
          isFalse,
        );
      });
    });
    group('Third Wednesday', () {
      final validator = DateValidatorWeekdayCountInMonth(
        day: Weekday.wednesday,
        week: Week.third,
      );
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 21)),
          isTrue,
        );
      });
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 12)),
          isFalse,
        );
      });
    });
    group('Fourth Thursday', () {
      final validator = DateValidatorWeekdayCountInMonth(
        day: Weekday.thursday,
        week: Week.fourth,
      );
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 22)),
          isTrue,
        );
      });
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 19)),
          isFalse,
        );
      });
    });
    group('Last Friday', () {
      final validator = DateValidatorWeekdayCountInMonth(
        day: Weekday.friday,
        week: Week.last,
      );
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 30)),
          isTrue,
        );
      });
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.september, 19)),
          isFalse,
        );
      });
    });
  });
  group('DateValidatorDayInYear', () {
    group('Day 1', () {
      final validator = DateValidatorDayInYear(1);
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.january, 1)),
          isTrue,
        );
      });
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.january, 2)),
          isFalse,
        );
      });
    });
    group('Day 365', () {
      final validator = DateValidatorDayInYear(365);
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.december, 31)),
          isTrue,
        );
      });
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.january, 2)),
          isFalse,
        );
      });
    });
    group('Day 366 not exact', () {
      final validator = DateValidatorDayInYear(366);
      test('Is not valid', () {
        expect(
          validator.valid(DateTime(2022, DateTime.january, 31)),
          isFalse,
        );
      });
      group('Is valid', () {
        test('2022', () {
          expect(
            validator.valid(DateTime(2022, DateTime.december, 31)),
            isTrue,
          );
        });
        test('2020', () {
          expect(
            validator.valid(DateTime(2020, DateTime.december, 31)),
            isTrue,
          );
        });
      });
    });
    group('Day 366 exact', () {
      final validator = DateValidatorDayInYear(366, exact: true);
      test('Is valid', () {
        expect(
          validator.valid(DateTime(2020, DateTime.december, 31)),
          isTrue,
        );
      });
      group('Is not valid', () {
        test('January 2nd', () {
          expect(
            validator.valid(DateTime(2022, DateTime.january, 2)),
            isFalse,
          );
        });
        test('December 31st 2022', () {
          expect(
            validator.valid(DateTime(2022, DateTime.december, 31)),
            isFalse,
          );
        });
      });
    });
  });
  group('DateValidatorIntersection', () {
    final validator = DateValidatorIntersection([
      DateValidatorDueDayMonth(24),
      DateValidatorWeekday(Weekday.saturday),
    ]);
    test('Valid', () {
      final date = DateTime(2022, DateTime.september, 24);
      expect(validator.valid(date), isTrue);
    });
    group('Invalid', () {
      test('Wrong day', () {
        final date = DateTime(2022, DateTime.september, 23);
        expect(validator.valid(date), isFalse);
      });
      test('Wrong weekday', () {
        final date = DateTime(2022, DateTime.august, 24);
        expect(validator.valid(date), isFalse);
      });
    });
  });
  group('DateValidatorUnion', () {
    final validator = DateValidatorUnion([
      DateValidatorDueDayMonth(24),
      DateValidatorWeekday(Weekday.saturday),
    ]);
    group('Valid', () {
      test('All valid', () {
        final date = DateTime(2022, DateTime.september, 24);
        expect(validator.valid(date), isTrue);
      });
      test('Wrong day', () {
        final date = DateTime(2022, DateTime.september, 17);
        expect(validator.valid(date), isTrue);
      });
      test('Wrong weekday', () {
        final date = DateTime(2022, DateTime.august, 24);
        expect(validator.valid(date), isTrue);
      });
    });
    test('Invalid', () {
      final date = DateTime(2022, DateTime.september, 23);
      expect(validator.valid(date), isFalse);
    });
  });
  group('DateValidatorDifference', () {
    final validator = DateValidatorDifference([
      DateValidatorDueDayMonth(24),
      DateValidatorWeekday(Weekday.saturday),
    ]);
    group('Valid', () {
      test('Wrong day', () {
        final date = DateTime(2022, DateTime.september, 17);
        expect(validator.valid(date), isTrue);
      });
      test('Wrong weekday', () {
        final date = DateTime(2022, DateTime.august, 24);
        expect(validator.valid(date), isTrue);
      });
    });
    group('Invalid', () {
      test('All valid', () {
        final date = DateTime(2022, DateTime.september, 24);
        expect(validator.valid(date), isFalse);
      });
      test('All Wrong', () {
        final date = DateTime(2022, DateTime.september, 23);
        expect(validator.valid(date), isFalse);
      });
    });
  });
}
