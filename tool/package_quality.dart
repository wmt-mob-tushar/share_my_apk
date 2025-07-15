#!/usr/bin/env dart

/// Package quality analyzer for pub.dev readiness
library;

import 'dart:io';
import 'dart:convert';

void main() async {
  stdout.writeln('📦 Analyzing package quality for pub.dev...\n');

  await _checkPubspec();
  await _checkLicense();
  await _checkChangelog();
  await _checkReadme();
  await _checkExamples();
  await _checkPubPoints();

  stdout.writeln('\n✅ Package quality analysis complete!');
}

Future<void> _checkPubspec() async {
  stdout.writeln('📄 Checking pubspec.yaml...');

  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    stdout.writeln('  ❌ pubspec.yaml not found');
    return;
  }

  final content = await pubspecFile.readAsString();
  final issues = <String>[];

  // Check required fields for pub.dev
  if (!content.contains('description:')) issues.add('Missing description');
  if (!content.contains('homepage:')) issues.add('Missing homepage');
  if (!content.contains('repository:')) issues.add('Missing repository');
  if (!content.contains('topics:')) issues.add('Missing topics');

  // Check version format
  final versionRegex = RegExp(r'version:\s*(\d+\.\d+\.\d+)');
  if (!versionRegex.hasMatch(content)) {
    issues.add('Invalid version format');
  }

  // Check SDK constraints
  if (!content.contains('sdk:')) issues.add('Missing SDK constraint');

  if (issues.isEmpty) {
    stdout.writeln('  ✅ pubspec.yaml looks good');
  } else {
    stdout.writeln('  ⚠️  Issues found:');
    for (final issue in issues) {
      stdout.writeln('    • $issue');
    }
  }
}

Future<void> _checkLicense() async {
  stdout.writeln('\n📜 Checking LICENSE file...');

  final licenseFiles = ['LICENSE', 'LICENSE.txt', 'LICENSE.md'];
  bool found = false;

  for (final filename in licenseFiles) {
    if (File(filename).existsSync()) {
      found = true;
      stdout.writeln('  ✅ Found $filename');
      break;
    }
  }

  if (!found) {
    stdout.writeln('  ⚠️  No LICENSE file found (recommended for pub.dev)');
  }
}

Future<void> _checkChangelog() async {
  stdout.writeln('\n📝 Checking CHANGELOG...');

  final changelogFiles = ['CHANGELOG.md', 'CHANGELOG.txt', 'CHANGELOG'];
  bool found = false;

  for (final filename in changelogFiles) {
    if (File(filename).existsSync()) {
      found = true;
      stdout.writeln('  ✅ Found $filename');
      break;
    }
  }

  if (!found) {
    stdout.writeln('  ⚠️  No CHANGELOG found (recommended for pub.dev)');
  }
}

Future<void> _checkReadme() async {
  stdout.writeln('\n📖 Checking README...');

  final readmeFile = File('README.md');
  if (!readmeFile.existsSync()) {
    stdout.writeln('  ❌ README.md not found');
    return;
  }

  final content = await readmeFile.readAsString();
  final sections = <String>[];

  // Check for important sections
  if (content.toLowerCase().contains('## usage')) sections.add('Usage');
  if (content.toLowerCase().contains('## installation')) {
    sections.add('Installation');
  }
  if (content.toLowerCase().contains('## example')) sections.add('Examples');
  if (content.toLowerCase().contains('## feature')) sections.add('Features');

  stdout.writeln('  ✅ README.md found');
  stdout.writeln('  📋 Sections detected: ${sections.join(', ')}');

  if (sections.length < 2) {
    stdout.writeln(
      '  ⚠️  Consider adding more sections (Usage, Installation, Examples)',
    );
  }
}

Future<void> _checkExamples() async {
  stdout.writeln('\n🚀 Checking examples...');

  final exampleDir = Directory('example');
  if (!exampleDir.existsSync()) {
    stdout.writeln('  ⚠️  No example/ directory found');
    return;
  }

  final dartFiles = await exampleDir
      .list()
      .where((entity) => entity.path.endsWith('.dart'))
      .length;

  if (dartFiles > 0) {
    stdout.writeln('  ✅ Found $dartFiles example file(s)');
  } else {
    stdout.writeln('  ⚠️  No .dart files in example/ directory');
  }
}

Future<void> _checkPubPoints() async {
  stdout.writeln('\n🏆 Running pub.dev quality checks...');

  // Run pub publish dry-run to check package
  final result = await Process.run('dart', [
    'pub',
    'publish',
    '--dry-run',
  ], workingDirectory: '.');

  final output = result.stderr as String;
  final stdoutOutput = result.stdout as String;

  // Debug: Check both outputs
  stdout.writeln('  🔍 Debug - stderr length: ${output.length}');
  stdout.writeln('  🔍 Debug - stdout length: ${stdoutOutput.length}');

  if (output.contains('Package has')) {
    // Count warnings and hints - format: "Package has X warning and Y hint"
    final packageMatch = RegExp(
      r'Package has (\d+) warning and (\d+) hint',
    ).firstMatch(output);

    final warnings = packageMatch?.group(1) ?? '0';
    final hints = packageMatch?.group(2) ?? '0';

    stdout.writeln(
      '  📊 Package validation: $warnings warning(s), $hints hint(s)',
    );

    if (output.contains('checked-in files are modified')) {
      stdout.writeln(
        '  ⚠️  Uncommitted changes detected (normal during development)',
      );
    }

    if (output.contains('not publishing an incremental update')) {
      stdout.writeln('  ℹ️  Version increment suggestion available');
    }

    // Check if warnings are only about git state (acceptable in dev)
    final hasOnlyGitWarnings =
        output.contains('checked-in files are modified') && warnings == '1';

    if (warnings == '0' || hasOnlyGitWarnings) {
      stdout.writeln('  ✅ Package validation passed');
    } else {
      stdout.writeln('  ⚠️  Review warnings before publishing');
    }
  } else if (result.exitCode == 0) {
    stdout.writeln('  ✅ Package passes pub.dev validation');
  } else {
    stdout.writeln('  ❌ Package validation failed');
    stdout.writeln('  📋 Check: dart pub publish --dry-run');
  }

  // Check dependencies
  await _checkDependencies();
}

Future<void> _checkDependencies() async {
  stdout.writeln('\n📦 Checking dependencies...');

  final result = await Process.run('dart', [
    'pub',
    'deps',
    '--json',
  ], workingDirectory: '.');

  if (result.exitCode == 0) {
    try {
      final deps = json.decode(result.stdout as String);
      final packages = deps['packages'] as List;

      int directDeps = 0;
      int devDeps = 0;

      for (final pkg in packages) {
        final kind = pkg['kind'] as String;
        if (kind == 'direct') directDeps++;
        if (kind == 'dev') devDeps++;
      }

      stdout.writeln('  • Direct dependencies: $directDeps');
      stdout.writeln('  • Dev dependencies: $devDeps');
      stdout.writeln('  • Total packages: ${packages.length}');

      if (directDeps > 10) {
        stdout.writeln(
          '  ⚠️  Many direct dependencies ($directDeps) - consider reducing',
        );
      } else {
        stdout.writeln('  ✅ Reasonable dependency count');
      }
    } catch (e) {
      stdout.writeln('  ⚠️  Could not parse dependency info');
    }
  }
}
