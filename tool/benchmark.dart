#!/usr/bin/env dart

/// Performance benchmarking tool for share_my_apk
library;

import 'dart:math';
import 'package:share_my_apk/share_my_apk.dart';

void main() async {
  print('⚡ Running performance benchmarks...\n');
  
  await _benchmarkArgParsing();
  await _benchmarkConfigService();
  await _benchmarkUploadServiceFactory();
  
  print('\n✅ Benchmark suite completed!');
}

Future<void> _benchmarkArgParsing() async {
  print('📊 Benchmarking ArgParserUtil...');
  
  final parser = ArgParserUtil();
  final args = ['--provider', 'gofile', '--path', '.'];
  
  final stopwatch = Stopwatch()..start();
  const iterations = 1000;
  
  for (int i = 0; i < iterations; i++) {
    parser.parse(args);
  }
  
  stopwatch.stop();
  final avgTime = stopwatch.elapsedMicroseconds / iterations;
  
  print('  • $iterations iterations: ${stopwatch.elapsedMilliseconds}ms');
  print('  • Average per parse: ${avgTime.toStringAsFixed(2)}μs');
  
  // Performance threshold
  if (avgTime > 1000) {
    print('  ⚠️  Slower than expected (>1ms per parse)');
  } else {
    print('  ✅ Performance within acceptable range');
  }
}

Future<void> _benchmarkConfigService() async {
  print('\n📊 Benchmarking ConfigService...');
  
  final stopwatch = Stopwatch()..start();
  const iterations = 100;
  
  for (int i = 0; i < iterations; i++) {
    ConfigService.getConfig();
  }
  
  stopwatch.stop();
  final avgTime = stopwatch.elapsedMicroseconds / iterations;
  
  print('  • $iterations iterations: ${stopwatch.elapsedMilliseconds}ms');
  print('  • Average per config read: ${avgTime.toStringAsFixed(2)}μs');
  
  if (avgTime > 10000) {
    print('  ⚠️  Config reading slower than expected (>10ms)');
  } else {
    print('  ✅ Config performance acceptable');
  }
}

Future<void> _benchmarkUploadServiceFactory() async {
  print('\n📊 Benchmarking UploadServiceFactory...');
  
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
    
    print('  • $provider: ${avgTime.toStringAsFixed(2)}μs per creation');
  }
  
  final maxTime = results.values.reduce(max);
  if (maxTime > 100) {
    print('  ⚠️  Factory creation slower than expected (>100μs)');
  } else {
    print('  ✅ Factory performance excellent');
  }
}