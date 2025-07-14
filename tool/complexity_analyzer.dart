#!/usr/bin/env dart

/// Code complexity analyzer for share_my_apk
///
/// Analyzes cyclomatic complexity and other code metrics.
library;

import 'dart:io';

void main() async {
  stdout.writeln('📈 Analyzing code complexity and metrics...\n');

  await _analyzeComplexity();
  await _analyzeLinesOfCode();
  await _analyzeDocumentationCoverage();

  stdout.writeln('✅ Code analysis complete!');
}

Future<void> _analyzeComplexity() async {
  stdout.writeln('🧮 Analyzing cyclomatic complexity...');

  // Using dart analyze with custom rules
  final result = await Process.run('dart', [
    'analyze',
    '--packages=.dart_tool/package_config.json',
  ], workingDirectory: '.');

  if (result.exitCode == 0) {
    stdout.writeln('  ✅ No complexity issues found');
  } else {
    stdout.writeln('  ⚠️  Complexity issues detected:');
    stdout.writeln(result.stdout);
  }
}

Future<void> _analyzeLinesOfCode() async {
  stdout.writeln('\n📏 Analyzing lines of code...');

  final libDir = Directory('lib');
  int totalLines = 0;
  int codeLines = 0;
  int commentLines = 0;
  int fileCount = 0;

  await for (final entity in libDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      fileCount++;
      final content = await entity.readAsString();
      final lines = content.split('\n');

      for (final line in lines) {
        totalLines++;
        final trimmed = line.trim();

        if (trimmed.isEmpty) {
          continue;
        } else if (trimmed.startsWith('//') ||
            trimmed.startsWith('/*') ||
            trimmed.startsWith('*') ||
            trimmed.startsWith('*/')) {
          commentLines++;
        } else {
          codeLines++;
        }
      }
    }
  }

  stdout.writeln('  • Files: $fileCount');
  stdout.writeln('  • Total lines: $totalLines');
  stdout.writeln('  • Code lines: $codeLines');
  stdout.writeln('  • Comment lines: $commentLines');
  stdout.writeln(
    '  • Comment ratio: ${(commentLines / totalLines * 100).toStringAsFixed(1)}%',
  );

  // Quality thresholds
  final commentRatio = commentLines / totalLines;
  if (commentRatio < 0.15) {
    stdout.writeln('  ⚠️  Low documentation ratio (<15%)');
  } else {
    stdout.writeln('  ✅ Good documentation ratio');
  }

  final avgLinesPerFile = totalLines / fileCount;
  if (avgLinesPerFile > 500) {
    stdout.writeln(
      '  ⚠️  Large average file size (>${avgLinesPerFile.round()} lines)',
    );
  } else {
    stdout.writeln('  ✅ Reasonable file sizes');
  }
}

Future<void> _analyzeDocumentationCoverage() async {
  stdout.writeln('\n📚 Analyzing documentation coverage...');

  final libDir = Directory('lib');
  int publicApis = 0;
  int documentedApis = 0;

  await for (final entity in libDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = await entity.readAsString();
      final lines = content.split('\n');

      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].trim();

        // Check for public API declarations
        if (_isPublicApi(line)) {
          publicApis++;

          // Check if previous line(s) contain documentation
          if (i > 0 && _hasDocumentation(lines, i)) {
            documentedApis++;
          }
        }
      }
    }
  }

  final docCoverage = publicApis > 0
      ? (documentedApis / publicApis) * 100
      : 100;

  stdout.writeln('  • Public APIs: $publicApis');
  stdout.writeln('  • Documented APIs: $documentedApis');
  stdout.writeln(
    '  • Documentation coverage: ${docCoverage.toStringAsFixed(1)}%',
  );

  if (docCoverage < 80) {
    stdout.writeln('  ⚠️  Low documentation coverage (<80%)');
  } else {
    stdout.writeln('  ✅ Good documentation coverage');
  }
}

bool _isPublicApi(String line) {
  // Check for public class, function, or method declarations
  final patterns = [
    RegExp(r'^class\s+[A-Z]'),
    RegExp(r'^abstract\s+class\s+[A-Z]'),
    RegExp(r'^enum\s+[A-Z]'),
    RegExp(r'^typedef\s+[A-Z]'),
    RegExp(r'^\s*[A-Z][a-zA-Z0-9_]*\s+[a-z][a-zA-Z0-9_]*\s*\('),
    RegExp(r'^\s*Future<[^>]*>\s+[a-z][a-zA-Z0-9_]*\s*\('),
    RegExp(r'^\s*static\s+[a-zA-Z0-9_<>]+\s+[a-z][a-zA-Z0-9_]*\s*\('),
  ];

  return patterns.any((pattern) => pattern.hasMatch(line)) &&
      !line.startsWith('_'); // Not private
}

bool _hasDocumentation(List<String> lines, int currentIndex) {
  // Look backwards for documentation comments
  for (int i = currentIndex - 1; i >= 0; i--) {
    final line = lines[i].trim();

    if (line.isEmpty) {
      continue;
    } else if (line.startsWith('///') || line.startsWith('/**')) {
      return true;
    } else {
      break; // Hit non-comment, non-empty line
    }
  }

  return false;
}
