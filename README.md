# DueDate

A package for working with repeating DateTime patterns.

Ever wanted to create a new DateTime with, let's say, the same day in month? But the day is 31 and next month only has 30, so you go to 30 and the next day is lost because then you have no variable to save the original's month day? With DueDateTime this managing is done for you without any headaches.

## Features

Examples of what this package can do:

```dart
final date = DateTime(2022, DateTime.january, 31);
DueDateTime dueDate = DueDateTime.fromDate(date);
dueDate = dueDate.addMonths(1); // February 28th, 2022
dueDate = dueDate.addMonths(1); // March 31th, 2022
```

## Getting started

On your `pubspec.yaml` file, add this package to your dependencies:

```yaml
  dependencies:
    due_date: ^1.0.0
```

Import the package library on your code:

```dart
import 'package:due_date/due_date.dart';
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
