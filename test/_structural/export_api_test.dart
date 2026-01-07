import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  group('Export API Tests', () {
    late AnalysisContextCollection collection;
    late AnalysisContext context;
    late Directory libDir;
    late Directory srcDir;

    setUpAll(() async {
      // Get the project root directory.
      final projectRoot = Directory.current;
      libDir = Directory(path.join(projectRoot.path, 'lib'));
      srcDir = Directory(path.join(libDir.path, 'src'));

      // Create an analysis context collection for the project.
      collection = AnalysisContextCollection(
        includedPaths: [libDir.path],
      );
      context = collection.contexts.first;
    });

    test('All public declarations in lib/src are exported from lib/', () async {
      // Collect all public declarations from lib/src/**/*.dart.
      final srcPublicDeclarations = <String, Set<Element>>{};

      await _collectPublicDeclarations(
        context,
        srcDir,
        srcPublicDeclarations,
      );

      // Collect all exports from lib/*.dart files.
      final exportedDeclarations = <Element>{};

      final libFiles = libDir
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))
          .toList();

      for (final file in libFiles) {
        await _collectExportedDeclarations(
          context,
          file,
          exportedDeclarations,
        );
      }

      // Find missing exports.
      final missingExports = <String, Set<Element>>{};

      for (final entry in srcPublicDeclarations.entries) {
        final filePath = entry.key;
        final declarations = entry.value;

        final missing = <Element>{};
        for (final declaration in declarations) {
          if (!exportedDeclarations.contains(declaration)) {
            missing.add(declaration);
          }
        }

        if (missing.isNotEmpty) {
          missingExports[filePath] = missing;
        }
      }

      // Report missing exports.
      if (missingExports.isNotEmpty) {
        final buffer = StringBuffer()
          ..writeln(
            'Found ${missingExports.length} files with missing exports:',
          )
          ..writeln();

        for (final entry in missingExports.entries) {
          final filePath = entry.key;
          final missing = entry.value;

          buffer
            ..writeln('File: $filePath')
            ..writeln('Missing exports (${missing.length}):');
          final sortedDeclarations = missing.toList()..sort();
          for (final declaration in sortedDeclarations) {
            buffer.writeln('  - ${declaration.displayName}');
          }
          buffer.writeln();
        }

        fail(buffer.toString());
      }
    });
  });
}

/// Collects all public declarations from Dart files in the given directory.
///
/// The [declarations] map stores file paths as keys and sets of public
/// declaration names as values.
Future<void> _collectPublicDeclarations(
  AnalysisContext context,
  Directory directory,
  Map<String, Set<Element>> declarations,
) async {
  final files = directory
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList();

  for (final file in files) {
    final result = await context.currentSession.getResolvedLibrary(file.path);

    if (result is ResolvedLibraryResult) {
      final publicDeclarations = <Element>{};

      // Iterate through all units in the library.
      for (final unit in result.units) {
        // Get the library element which contains all top-level declarations.
        final libraryElement = unit.libraryElement;

        // Collect public top-level declarations.
        _collectPublicDeclarationsFromLibrary(
          libraryElement,
          publicDeclarations,
        );
      }

      if (publicDeclarations.isNotEmpty) {
        // Store relative path from lib/src.
        final relativePath = path.relative(
          file.path,
          from: Directory(path.join(Directory.current.path, 'lib', 'src')).path,
        );
        declarations[relativePath] = publicDeclarations;
      }
    }
  }
}

/// Collects public declarations from a library element.
///
/// Adds names of public top-level declarations to the [declarations] set.
void _collectPublicDeclarationsFromLibrary(
  LibraryElement library,
  Set<Element> declarations,
) {
  // Collect classes.
  library.publicNamespace.definedNames2.values.forEach(declarations.add);
}

/// Collects all declarations exported from a library file.
///
/// This includes both directly exported declarations and declarations from
/// export directives.
Future<void> _collectExportedDeclarations(
  AnalysisContext context,
  File file,
  Set<Element> declarations,
) async {
  final result = await context.currentSession.getResolvedLibrary(file.path);

  if (result is ResolvedLibraryResult) {
    final library = result.element;

    // Collect all exported elements.
    final exportedElements = library.exportNamespace.definedNames2.values;
    declarations.addAll(exportedElements);
  }
}
