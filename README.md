# DueDate

[![pub package](https://img.shields.io/pub/v/due_date.svg)](https://pub.dev/packages/due_date)
[![GitHub License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/FMorschel/due_date/main/LICENSE)
<!--- Prepare for future badges when the package is more mature and has more users
<a href="https://pub.dev/packages/due_date"><img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/FMorschel/due_date"></a>
<a href="https://github.com/FMorschel/due_date/graphs/contributors"><img alt="GitHub contributors" src="https://img.shields.io/github/contributors/FMorschel/due_date"></a>
<a href="https://githubc.com/FMorschel/due_date/issues?q=is%3Aissue+is%3Aclosed"><img src="https://img.shields.io/github/issues-closed-raw/FMorschel/due_date" alt="GitHub closed issues"></a>
[![GitHub Forks](https://img.shields.io/github/forks/FMorschel/due_date.svg)](https://github.com/FMorschel/due_date/network)
--->
[![GitHub Sponsors](https://img.shields.io/github/sponsors/FMorschel)](https://github.com/sponsors/FMorschel)
<span class="badge-buymeacoffee">
<a href="https://www.buymeacoffee.com/fmorschel" title="Donate to this project using Buy Me A Coffee"><img src="https://img.shields.io/badge/buy%20me%20a%20coffee-donate-yellow.svg" alt="Buy Me A Coffee donate button" /></a>
</span>

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
    due_date: ^2.2.1
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

Contribute to the package by creating a PR at <https://github.com/FMorschel/due_date/pulls>.

File issues at <https://github.com/FMorschel/due_date/issues>.

Discuss related topics at <https://github.com/FMorschel/due_date/discussions>.

## Alternatives/Inspiration

- [pub.dev -> time](https://pub.dev/packages/time)
  - Made me start thinking about this package and how I could improve it with issues and discussions on the GitHub repo.

- [DateUtils -> Flutter](https://api.flutter.dev/flutter/material/DateUtils-class.html)
  - Inspired me to create the `Period` class and its methods. As well as some `Every` classes.

## What makes this different

This package is focused on working with `DateTime` objects and their patterns. It is not a calendar package, but it can be used to create one.
It is also not a package to work with timezones. It is focused on the `DateTime` object itself. It does not have any timezone related methods. For that, you may want to check out the [timezone](https://pub.dev/packages/timezone) package.

This is not a package to work with `Duration` objects. It is focused on `DateTime` objects and their patterns. For that, you may want to check out the [time](https://pub.dev/packages/time) package.

This package is not a package to work with `DateTime` objects and their formatting. It is focused on `DateTime` objects and their patterns. For that, you may want to check out the [intl](https://pub.dev/packages/intl) package.

This package is not intended to be a replacement for the `DateTime` class. It is intended to be a complement to it.

The [time](https://pub.dev/packages/time) package is a great package to work with `Duration` and `DateTime` objects. It uses extension methods to add functionality to the `DateTime` class. This package is not intended to be a replacement for the `time` package. It is intended to be a complement to it.

## License

This package is licensed under the MIT license. See the [LICENSE](<https://pub.dev/packages/due_date/license>) file for details.
