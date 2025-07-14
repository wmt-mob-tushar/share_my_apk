#!/usr/bin/env dart

/// Performance benchmarking tool for share_my_apk
library;

import 'dart:io';
import 'dart:math';
import 'package:share_my_apk/share_my_apk.dart';

void main() async {
  stdout.writeln('⚡ Running performance benchmarks...\n');

  await _benchmarkArgParsing();
  await _benchmarkConfigService();
  await _benchmarkUploadServiceFactory();

  stdout.writeln('\n✅ Benchmark suite completed!');
}

Future<void> _benchmarkArgParsing() async {
  stdout.writeln('📊 Benchmarking ArgParserUtil...');

  final parser = ArgParserUtil();
  final args = ['--provider', 'gofile', '--path', '.'];

  final stopwatch = Stopwatch()..start();
  const iterations = 1000;

  for (int i = 0; i < iterations; i++) {
    parser.parse(args);
  }

  stopwatch.stop();
  final avgTime = stopwatch.elapsedMicroseconds / iterations;

  stdout.writeln(
    '  • $iterations iterations: ${stopwatch.elapsedMilliseconds}ms',
  );
  stdout.writeln('  • Average per parse: ${avgTime.toStringAsFixed(2)}μs');

  // Performance threshold
  if (avgTime > 1000) {
    stdout.writeln('  ⚠️  Slower than expected (>1ms per parse)');
  } else {
    stdout.writeln('  ✅ Performance within acceptable range');
  }
}

Future<void> _benchmarkConfigService() async {
  stdout.writeln('\n📊 Benchmarking ConfigService...');

  final stopwatch = Stopwatch()..start();
  const iterations = 100;

  for (int i = 0; i < iterations; i++) {
    ConfigService.getConfig();
  }

  stopwatch.stop();
  final avgTime = stopwatch.elapsedMicroseconds / iterations;

  stdout.writeln(
    '  • $iterations iterations: ${stopwatch.elapsedMilliseconds}ms',
  );
  stdout.writeln(
    '  • Average per config read: ${avgTime.toStringAsFixed(2)}μs',
  );

  if (avgTime > 10000) {
    stdout.writeln('  ⚠️  Config reading slower than expected (>10ms)');
  } else {
    stdout.writeln('  ✅ Config performance acceptable');
  }
}

Future<void> _benchmarkUploadServiceFactory() async {
  stdout.writeln('\n📊 Benchmarking UploadServiceFactory...');

  final providers = ['gofile', 'diawi'];
  final results = <String, double>{};

  for (final provider in providers) {
    final stopwatch = Stopwatch()..start();
    const iterations = 1000;

    for (int i = 0; i < iterations; i++) {
      try {
        UploadServiceFactory.create(provider, token: 'test-token');
      } catch (e) {
        // Expected for some cases
      }
    }

    stopwatch.stop();
    final avgTime = stopwatch.elapsedMicroseconds / iterations;
    results[provider] = avgTime;

    stdout.writeln(
      '  • $provider: ${avgTime.toStringAsFixed(2)}μs per creation',
    );
  }

  final maxTime = results.values.reduce(max);
  if (maxTime > 100) {
    stdout.writeln('  ⚠️  Factory creation slower than expected (>100μs)');
  } else {
    stdout.writeln('  ✅ Factory performance excellent');
  }
}
