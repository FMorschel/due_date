import 'package:essential_lints_annotations/essential_lints_annotations.dart';

import '../date_direction.dart';
import '../every.dart';

/// {@template everyWrapper}
/// Abstract class that, when extended, processes [DateTime] with custom logic.
/// {@endtemplate}
@SubtypeNaming(containing: 'Wrapper', packageOption: PackageOption.private)
abstract class EveryWrapper<T extends Every> extends Every {
  /// {@macro everyWrapper}
  const EveryWrapper({required this.every});

  /// The base generator for this [EveryWrapper].
  final T every;

  /// A method that processes [date] with custom logic.
  DateTime processDate(DateTime date, DateDirection direction);
}
