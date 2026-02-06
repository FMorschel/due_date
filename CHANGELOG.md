# CHANGELOG

## 3.0.0

Released on 2026.02.06.

### Breaking Changes

- **Removed interfaces**:
  - `ExactEvery`, `ExactTimeOfDay`, `EveryOverrideWrapper`, `EveryModifierInvalidator`, and `EverySkipInvalidModifier` have been removed. Use the new Adapter equivalents (`EveryOverrideAdapter`, `EveryAdapterInvalidator`, `EverySkipInvalidAdapter`) instead.
  - `EveryDateValidatorListMixin` has changed the signature.

- **`validsIn` removed**: The `validsIn` method has been removed from all [DateValidator] and [EveryDateValidator] implementations.

- **`startDate` narrowed**: The `startDate` method has been removed from [Every], [EveryMonth], [EveryYear], [EveryWeek], [LimitedEvery], and [EverySkipCountWrapper]. It now lives exclusively on [EveryDateValidator] and its subtypes.

- **`Weekday.occrurencesIn` removed**: Renamed to `occurrencesIn` (typo fix).

- **`ExactEvery` super type removed** from [EveryDayInYear], [EveryDueDayMonth], and [EveryDueWorkdayMonth].

- **`EverySkipCountWrapper` reparented**: No longer extends [LimitedEvery] or mixes in [LimitedEveryModifierMixin]. Now extends [EveryWrapper] with [EveryWrapperMixin].

- **Constructor parameter renames**: `validators` → `base` on [DateValidatorDifference], [DateValidatorIntersection], and [DateValidatorUnion]. `everyDateValidators` → `base` on [EveryDateValidatorUnion], [EveryDateValidatorDifference], and [EveryDateValidatorIntersection].

- **Entry point changes**: Many classes previously exported from `period.dart` are no longer available through that entry point (e.g. [Every], [EveryMonth], [EveryYear], [EveryWeek], [LimitedEvery], [WeekdayOccurrence], extensions, and modifier mixins). [PeriodGenerator] is no longer exported from `due_date.dart`.

### New Features & Improvements

- **`DateValidator.operator -`**: Added unary negation operator (`-`) to all [DateValidator] classes. Returns a [DateValidatorOpposite] that inverts validation.

- **`DateValidatorOpposite`**: A new [DateValidator] that negates the result of another validator.

- **`endDate`**: Added `endDate` method to [EveryDateValidator] and all its implementations for reverse boundary resolution.

- **`Period.of`**: Added a new factory constructor on [Period].

- **New Adapter layer**: Introduced a full set of adapter classes for wrapping [Every] / [LimitedEvery] instances with custom behavior:
  - [EveryAdapter], [EveryAdapterMixin], [LimitedEveryAdapter], [LimitedEveryAdapterMixin].
  - [EveryAdapterInvalidator], [EveryAdapterInvalidatorMixin], [LimitedEveryAdapterInvalidator].
  - [EveryOverrideAdapter], [LimitedEveryOverrideAdapter].
  - [EverySkipInvalidAdapter], [LimitedEverySkipInvalidAdapter].
  - [EverySkipCountAdapter], [LimitedEverySkipCountAdapter].
  - [EveryTimeOfDayAdapter], [LimitedEveryTimeOfDayAdapter].

- **New Modifier interfaces**:
  - [EverySkipCountModifier], [LimitedEverySkipCountModifier].
  - [EveryTimeOfDayModifier], [LimitedEveryTimeOfDayModifier].
  - [LimitedEveryModifier].

- **New Wrapper interfaces**:
  - [EveryWrapper], [EveryWrapperMixin], [LimitedEveryWrapper], [LimitedEveryWrapperMixin].
  - [EveryTimeOfDayWrapper], [LimitedEveryTimeOfDayWrapper].
  - [LimitedEverySkipCountWrapper].

- **New DateValidator / EveryDateValidator mixins and interfaces**:
  - [EveryDateValidatorMixin], [LimitedEveryDateValidatorMixin], [EveryDateValidatorListMixin].
  - [LimitedEveryDateValidatorListMixin], [LimitedEveryDateValidator], [LimitedEveryMixin].

- **`EveryModifier` & `EveryModifierMixin`**: Now implement [EveryDateValidator] (previously only [Every]). Added `valid`, `invalid`, and `filterValidDates` methods.

- **`LimitedEveryModifierMixin`**: Now implements [LimitedEveryDateValidator] and [LimitedEveryModifier]. Added `throwIfLimitReached`, `valid`, `invalid`, and `filterValidDates` methods.

- **`throwIfLimitReached`**: Added to [LimitedEvery], [EveryDateValidatorUnion], [EveryDateValidatorDifference], and [EveryDateValidatorIntersection].

- **`EveryDueTimeOfDay`**: Added `midnight` and `lastMicrosecond` fields.

- **`DateDirection`**: Added `end`, `isEnd`, `isForward`, `isBackward`, and `couldStayEqual` fields.

- **`LimitedOrEveryHandler`**: Added `startDateAdapter`, `endDate`, and `endDateAdapter` methods.

- **Period Bundles**: Added [TrimesterPeriodBundle] and [SemesterPeriodBundle].

### Dependencies

- Updated `time` from `^2.1.5` to `^2.1.6`.

## 2.3.0

Released on 2025.07.16.

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

## 2.2.2

Released on 2024.11.27.

- Loosened the constraints of the dependencies.

## 2.2.1

Released on 2024.11.19.

- Thightened the constraints of the dependencies.

## 2.2.0

Released on 2024.11.19.

- Added [EveryDueTimeOfDay] and [EveryDueWorkdayMonth] and their respective implementations for [DateValidator].

## 2.0.0

Released on 2023.03.28.

- Added [DateValidator] and some implementations.
- Implemented [DateValidator] in all implementations of [Every].
- Created [Period] and some implementations.
- Created [PeriodGeneratorMixin] and some implementations.

### Breaking changes

- API changes to always use optional named parameters.
- API changes replacing optional positional parameters for optional named parameters.

## 1.0.4

Released on 2022.08.23.

- Fixed typo on changelog.
- Updated dependency `time` to fix issues.

## 1.0.3 - 2022.08.23

- Fixed repository and issues pointing to wrong package.
- Fixed example README.

## 1.0.2

Released on 2022.08.23.

- Renamed `isWorkDay` -> `isWorkday`. Since is the same day of release, I won't consider this a breaking change.

## 1.0.1

Released on 2022.08.23.

- Fixed Dart Conventions, added more description to the `pubspec.yaml`.

## 1.0.0

Released on 2022.08.23.

- Initial stable release.
