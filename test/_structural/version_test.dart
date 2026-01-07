import 'dart:io';

import 'package:test/test.dart';

void main() {
  group('Version consistency', () {
    test(
        'pubspec.yaml, CHANGELOG.md, and README.md all contain the same '
        'version', () async {
      // Read pubspec.yaml version.
      final pubspec = await File('pubspec.yaml').readAsString();
      final versionMatch =
          RegExp(r'^version:\s*([\d.]+)', multiLine: true).firstMatch(pubspec);
      expect(
        versionMatch,
        isNotNull,
        reason: 'No version found in pubspec.yaml',
      );
      final version = versionMatch!.group(1);

      // Check CHANGELOG.md.
      final changelog = await File('CHANGELOG.md').readAsString();
      final changelogMatch =
          RegExp(r'^##\s*([\d.]+)', multiLine: true).firstMatch(changelog);
      expect(
        changelogMatch,
        isNotNull,
        reason: 'No version found in CHANGELOG.md',
      );
      expect(
        changelogMatch!.group(1),
        version,
        reason: 'CHANGELOG.md version does not match pubspec.yaml',
      );

      // Check README.md.
      final readme = await File('README.md').readAsString();
      final readmeMatch =
          RegExp(r'due_date: \^\s*([\d.]+)', caseSensitive: false)
              .firstMatch(readme);
      // README may not have a version, but if it does, it must match.
      if (readmeMatch != null) {
        expect(
          readmeMatch.group(1),
          version,
          reason: 'README.md version does not match pubspec.yaml',
        );
      }
    });
  });
}
