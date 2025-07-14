import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:process_run/shell.dart';
import 'package:share_my_apk/src/services/build/apk_organizer_service.dart';
import 'package:share_my_apk/src/services/build/apk_parser_service.dart';
import 'package:share_my_apk/src/utils/console_logger.dart';

class FlutterBuildService {
  final ApkParserService _apkParserService;
  final ApkOrganizerService _apkOrganizerService;
  final ConsoleLogger? _logger;

  FlutterBuildService({
    ApkParserService? apkParserService,
    ApkOrganizerService? apkOrganizerService,
    ConsoleLogger? logger,
  }) : _apkParserService = apkParserService ?? ApkParserService(),
       _apkOrganizerService = apkOrganizerService ?? ApkOrganizerService(),
       _logger = logger;

  /// Builds a Flutter Android APK with comprehensive build pipeline.
  ///
  /// - [release]: Whether to build in release mode. Defaults to `true`.
  /// - [projectPath]: The path to the Flutter project. Defaults to the current directory.
  /// - [customName]: A custom name for the APK file.
  /// - [environment]: The build environment (e.g., 'dev', 'prod').
  /// - [outputDir]: The directory to save the final APK file.
  /// - [clean]: Whether to run flutter clean before build. Defaults to `true`.
  /// - [getPubDeps]: Whether to run pub get before build. Defaults to `true`.
  /// - [generateL10n]: Whether to generate localizations. Defaults to `true`.
  ///
  /// Returns the path to the built and organized APK file.
  Future<String> build({
    bool release = true,
    String? projectPath,
    String? customName,
    String? environment,
    String? outputDir,
    bool clean = true,
    bool getPubDeps = true,
    bool generateL10n = true,
    bool verbose = false,
  }) async {
    final workingDir = projectPath ?? Directory.current.path;
    final shell = Shell(workingDirectory: workingDir);
    final buildType = release ? 'release' : 'debug';

    _logger?.info('🚀 Starting comprehensive APK build (mode: $buildType)...');

    final flutterCommand = _detectFlutterCommand(workingDir);
    _logger?.fine('Using Flutter command: $flutterCommand');

    await _runBuildPipeline(
      shell,
      flutterCommand,
      workingDir,
      buildType,
      clean,
      getPubDeps,
      generateL10n,
      verbose,
    );

    final result = await _runCommand(
      shell,
      '$flutterCommand build apk --$buildType',
      'Building APK ($buildType mode)...',
      verbose,
    );

    if (result.first.exitCode == 0) {
      final buildOutput = result.outText;
      _logger?.fine('Build output:\n$buildOutput');

      final originalApkPath = _apkParserService.getApkPath(
        buildOutput,
        projectPath,
      );
      if (originalApkPath != null) {
        _logger?.info('✅ APK built successfully: $originalApkPath');

        final finalApkPath = await _apkOrganizerService.organize(
          originalApkPath,
          projectPath,
          customName,
          environment,
          outputDir,
        );

        return finalApkPath;
      } else {
        _logger?.severe('🔥 Could not find APK path in build output.');
        throw Exception('APK build failed: Could not find APK path.');
      }
    } else {
      _logger?.severe(
        '🔥 APK build failed with exit code ${result.first.exitCode}:',
      );
      _logger?.severe(result.errText);
      throw Exception('APK build failed.');
    }
  }

  Future<List<ProcessResult>> _runCommand(
    Shell shell,
    String command,
    String message,
    bool verbose,
  ) async {
    _logger?.startSpinner(message);
    try {
      final result = await shell.run(command);
      _logger?.stopSpinner();
      if (verbose) {
        _logger?.fine(result.map((line) => line.outText).join('\n'));
      }
      return result;
    } catch (e) {
      _logger?.stopSpinner(success: false);
      rethrow;
    }
  }

  Future<void> _runBuildPipeline(
    Shell shell,
    String flutterCommand,
    String workingDir,
    String buildType,
    bool clean,
    bool getPubDeps,
    bool generateL10n,
    bool verbose,
  ) async {
    // 1. Clean project
    if (clean) {
      await _runCommand(
        shell,
        '$flutterCommand clean',
        '🧹 [1/4] Cleaning project...',
        verbose,
      );
    }

    // 2. Get dependencies
    if (getPubDeps) {
      await _runCommand(
        shell,
        '$flutterCommand pub get',
        '📦 [2/4] Getting dependencies...',
        verbose,
      );
    }

    // 3. Generate localizations if needed
    final l10nFile = File(p.join(workingDir, 'l10n.yaml'));
    if (generateL10n && l10nFile.existsSync()) {
      _logger?.fine('Found localizations directory, will generate l10n');
      await _runCommand(
        shell,
        '$flutterCommand gen-l10n',
        '🌍 [3/4] Generating localizations...',
        verbose,
      );
    }
  }

  String _detectFlutterCommand(String workingDir) {
    final fvmConfig = File(p.join(workingDir, '.fvm', 'fvm_config.json'));
    if (fvmConfig.existsSync()) {
      _logger?.fine('FVM config found, using fvm flutter command.');
      return 'fvm flutter';
    } else {
      _logger?.fine('No FVM config found, using global flutter command.');
      return 'flutter';
    }
  }
}
