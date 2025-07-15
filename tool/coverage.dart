#!/usr/bin/env dart

/// Code coverage analysis tool for share_my_apk
library;

import 'dart:io';

void main(List<String> args) async {
  stdout.writeln('🧪 Running code coverage analysis...\n');

  // Run tests with coverage
  final testResult = await Process.run('dart', [
    'test',
    '--coverage=coverage',
  ], workingDirectory: '.');

  if (testResult.exitCode != 0) {
    stdout.writeln('❌ Tests failed');
    exit(1);
  }

  // Generate LCOV report
  final lcovResult = await Process.run('dart', [
    'run',
    'coverage:format_coverage',
    '--lcov',
    '--in=coverage',
    '--out=coverage/lcov.info',
    '--packages=.dart_tool/package_config.json',
  ], workingDirectory: '.');

  if (lcovResult.exitCode != 0) {
    stdout.writeln('❌ Coverage report generation failed');
    exit(1);
  }

  // Parse coverage data
  final lcovFile = File('coverage/lcov.info');
  if (!lcovFile.existsSync()) {
    stdout.writeln('❌ Coverage file not found');
    exit(1);
  }

  final coverage = await _parseLcovFile(lcovFile);

  stdout.writeln('📊 Coverage Report:');
  stdout.writeln('  • Line Coverage: ${coverage['line']!.toStringAsFixed(1)}%');
  stdout.writeln(
    '  • Function Coverage: ${coverage['function']!.toStringAsFixed(1)}%',
  );
  stdout.writeln(
    '  • Branch Coverage: ${coverage['branch']!.toStringAsFixed(1)}%',
  );

  // Enforce minimum coverage thresholds
  const minCoverage = 90.0;
  if (coverage['line']! < minCoverage) {
    stdout.writeln(
      '❌ Line coverage ${coverage['line']!.toStringAsFixed(1)}% below minimum $minCoverage%',
    );
    exit(1);
  }

  stdout.writeln('✅ Coverage thresholds met!');

  // Generate HTML report
  if (args.contains('--html')) {
    await _generateHtmlReport();
  }
}

Future<Map<String, double>> _parseLcovFile(File lcovFile) async {
  final content = await lcovFile.readAsString();
  int linesFound = 0, linesHit = 0;
  int functionsFound = 0, functionsHit = 0;
  int branchesFound = 0, branchesHit = 0;

  for (final line in content.split('\n')) {
    if (line.startsWith('LF:')) {
      linesFound += int.parse(line.substring(3));
    } else if (line.startsWith('LH:')) {
      linesHit += int.parse(line.substring(3));
    } else if (line.startsWith('FNF:')) {
      functionsFound += int.parse(line.substring(4));
    } else if (line.startsWith('FNH:')) {
      functionsHit += int.parse(line.substring(4));
    } else if (line.startsWith('BRF:')) {
      branchesFound += int.parse(line.substring(4));
    } else if (line.startsWith('BRH:')) {
      branchesHit += int.parse(line.substring(4));
    }
  }

  return {
    'line': linesFound > 0 ? (linesHit / linesFound) * 100 : 0,
    'function': functionsFound > 0 ? (functionsHit / functionsFound) * 100 : 0,
    'branch': branchesFound > 0 ? (branchesHit / branchesFound) * 100 : 0,
  };
}

Future<void> _generateHtmlReport() async {
  stdout.writeln('📄 Generating HTML coverage report...');

  final result = await Process.run('genhtml', [
    'coverage/lcov.info',
    '-o',
    'coverage/html',
  ], workingDirectory: '.');

  if (result.exitCode == 0) {
    stdout.writeln('✅ HTML report generated: coverage/html/index.html');
  } else {
    stdout.writeln('⚠️  HTML report generation failed (genhtml not installed)');
  }
}
