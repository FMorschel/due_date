# CHANGELOG

## 2.3.0 - 2025.07.16

### API Changes - Return values upgraded to more specific type

- **`Weekday.validator`**: The return type of the `validator` getter on the `Weekday` enum has been narrowed from the general `DateValidator` to the more specific `DateValidatorWeekday`. This improves type safety but may require casting in existing code if you were relying on the broader type.
- **`ClampInMonth.dueDateTime`**: The return type of the `dueDateTime` getter on the `ClampInMonth` extension has been changed from `DueDateTime<Every>` to `DueDateTime<EveryDueDayMonth>`. This provides a more accurate type for the created object.
- **`DueDateTime.next`**: The return type of the `next` getter on the `DueDateTime` class has been changed from `DueDateTime<Every>` to `DueDateTime<T>`.
- **`DueDateTime.previous`**: The return type of the `previous` getter on the `DueDateTime` class has been changed from `DueDateTime<Every>` to `DueDateTime<T>`.

### New Features & Improvements

- **Period Bundles**: Added new abstract base classes for period grouping:
  - **`SemesterPeriodBundle`**: A base class that represents a bundle of semesters, extending `TrimesterPeriodBundle`.
  - **`TrimesterPeriodBundle`**: A base class that represents a bundle of trimesters, extending `MonthPeriodBundle`.
- **Timezone on Periods**: The `Period` class and all its subclasses (e.g., `WeekPeriod`, `DayPeriod`, `MonthPeriod`, etc) now include `isUtc`, `isLocal`, `toUtc()`, and `toLocal()` for better timezone awareness and conversion.
- **`DueDateTime.copyWith`**: Added an optional `utc` boolean parameter to `copyWith` to allow for easy conversion to/from UTC when copying an instance. This will keep the exact timings and not convert the date.
- **`DateValidatorDayInYear`**:

  - Added an `inexact` field.
  - Now implements the new `ExactDateValidator` interface.

- **`EveryDayInYear`**:

  - Added an `inexact` field.
  - Now implements `ExactDateValidator` and the new `ExactEvery` interface.

- **`EveryDueDayMonth` & `EveryDueWorkdayMonth`**: Now implement the new `ExactEvery` interface.

**Internal**:

- **`WorkdayHelper`**: Now exposes a `dateValidator` field.
- **`ObjectExt`**: Added new utility methods `when2` and `whenn`.
- Added new interface `_When`, and a helper function `boolCompareTo` for internal use.

### Dependencies

- Updated `equatable` from `^2.0.0` to `^2.0.3`. This should fix analysis issues with `pub downgrade`.

## 2.2.2 - 2024.11.27

- Loosened the constraints of the dependencies.

## 2.2.1 - 2024.11.19

- Thightened the constraints of the dependencies.

## 2.2.0 - 2024.11.19

- Added [EveryDueTimeOfDay] and [EveryDueWorkdayMonth] and their respective implementations for [DateValidator].

## 2.0.0 - 2023.03.28

- Added [DateValidator] and some implementations.
- Implemented [DateValidator] in all implementations of [Every].
- Created [Period] and some implementations.
- Created [PeriodGeneratorMixin] and some implementations.

### Breaking changes

- API changes to always use optional named parameters.
- API changes replacing optional positional parameters for optional named parameters.

## 1.0.4 - 2022.08.23

- Fixed typo on changelog.
- Updated dependency `time` to fix issues.

## 1.0.3 - 2022.08.23

- Fixed repository and issues pointing to wrong package.
- Fixed example README.

## 1.0.2 - 2022.08.23

- Renamed `isWorkDay` -> `isWorkday`. Since is the same day of release, I won't consider this a breaking change.

## 1.0.1 - 2022.08.23

- Fixed Dart Conventions, added more description to the `pubspec.yaml`.

## 1.0.0 - 2022.08.23

- Initial stable release.
