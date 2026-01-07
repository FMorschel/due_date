import '../date_validators/date_validator.dart';
import '../date_validators/date_validator_mixin.dart';
import 'every.dart';

/// A base class that represents an [Every] with a [DateValidator].
abstract class EveryDateValidator extends Every with DateValidatorMixin {
  /// A base class that represents an [Every] with a [DateValidator].
  const EveryDateValidator();

  /// {@template startDate}
  /// Returns the next [DateTime] that matches the [Every] pattern.
  ///
  /// If the [date] is a [DateTime] that matches the [Every] pattern, it will
  /// be returned.
  ///
  /// If the [date] is not a [DateTime] that matches the [Every] pattern, [next]
  /// will be called to generate a new one.
  /// {@endtemplate}
  DateTime startDate(DateTime date);

  /// {@template endDate}
  /// Returns the previous [DateTime] that matches the [Every] pattern.
  ///
  /// If the [date] is a [DateTime] that matches the [Every] pattern, it will
  /// be returned.
  ///
  /// If the [date] is not a [DateTime] that matches the [Every] pattern,
  /// [previous] will be called to generate a new one.
  /// {@endtemplate}
  DateTime endDate(DateTime date);
}
