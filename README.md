# DueDate

A package for working with repeating `DateTime` patterns.

Ever wanted to create a new `DateTime` with, let's say, the same day in month? But the day is 31 and next month only has 30, so you go to 30 and the next day is lost because then you have no variable to save the original's month day? With `DueDateTime` this managing is done for you without any headaches.

Or maybe you have to check if some `DateTime` is inside a certain period of time and always have to manually get, let's say, the start and end of the week and process it yourself. Now you can use `PeriodGenerator`s and `Period` methods to work it out for you.

## Features

Examples of what this package can do:

### DueDateTime

```dart
final date = DateTime(2022, DateTime.january, 31);
DueDateTime dueDate = DueDateTime.fromDate(date);
dueDate = dueDate.addMonths(1); // February 28th, 2022
dueDate = dueDate.addMonths(1); // March 31th, 2022
```

### Period

```dart
final period1 = Period(
  start: DateTime(2022, DateTime.january, 1),
  end: DateTime(2022, DateTime.january, 5),
);
final period2 = Period(
  start: DateTime(2022, DateTime.january, 3),
  end: DateTime(2022, DateTime.january, 7),
);
if (period1.overlapsWith(period2)) {
  print('The two periods overlap.');
} else {
  print('The two periods do not overlap.');
}
```

### PeriodGenerator

```dart
final hourGenerator = HourGenerator();
final secondGenerator = SecondGenerator();
final now = DateTime.now();
final currentHour = hourGenerator.of(now);
final currentSecond = secondGenerator.of(now);
print('The current hour is $currentHour.');
print('The current second is $currentSecond.');
final nextHour = currentHour.getNext(hourGenerator);
final nextSecond = currentSecond.getNext(secondGenerator);
print('The next hour is $nextHour.');
print('The next second is $nextSecond.');
final previousHour = currentHour.getPrevious(hourGenerator);
final previousSecond = currentSecond.getPrevious(secondGenerator);
print('The previous hour is $previousHour.');
print('The previous second is $previousSecond.');
```

## Getting started

On your `pubspec.yaml` file, add this package to your dependencies:

```yaml
  dependencies:
    due_date: ^2.0.0
```

Import one of the, or both, package libraries on your code:

```dart
import 'package:due_date/due_date.dart';
import 'package:due_date/period.dart';
```

## Usage

Longer examples at `/example` folder.

```dart
final date = DateTime(2022, DateTime.january, 31);
DueDateTime dueDate = date.dueDateTime; // 2022-01-31
dueDate = dueDate.next; // 2022-02-28
dueDate = dueDate.next; // 2022-03-31
```

## Additional information

See the API docs [here](https://fmorschel.github.io/due_date/).

Find more information at <https://github.com/FMorschel/due_date>.

Contibute to the package by creating a PR at <https://github.com/FMorschel/due_date/pulls>.

File issues at <https://github.com/FMorschel/due_date/issues>.
