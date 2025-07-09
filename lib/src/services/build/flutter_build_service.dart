import 'package:logging/logging.dart';
import 'package:process_run/process_run.dart';
import 'package:share_my_apk/src/services/build/apk_organizer_service.dart';
import 'package:share_my_apk/src/services/build/apk_parser_service.dart';

/// A service responsible for building Flutter Android APKs.
///
/// This service uses the `flutter build apk` command to generate the APK,
/// and then uses [ApkParserService] and [ApkOrganizerService] to locate
/// and organize the final APK file.
class FlutterBuildService {
  static final Logger _logger = Logger('FlutterBuildService');

  final ApkParserService _apkParserService;
  final ApkOrganizerService _apkOrganizerService;
  final bool _dryRun;

  /// Creates a new [FlutterBuildService].
  ///
  /// An optional [apkParserService] and [apkOrganizerService] can be provided
  /// for testing or custom behavior.
  FlutterBuildService({
    ApkParserService? apkParserService,
    ApkOrganizerService? apkOrganizerService,
    bool dryRun = false,
  })  : _apkParserService = apkParserService ?? ApkParserService(),
        _apkOrganizerService = apkOrganizerService ?? ApkOrganizerService(),
        _dryRun = dryRun;

  /// Builds a Flutter Android APK.
  ///
  /// - [release]: Whether to build in release mode. Defaults to `true`.
  /// - [projectPath]: The path to the Flutter project. Defaults to the current directory.
  /// - [customName]: A custom name for the APK file.
  /// - [environment]: The build environment (e.g., 'dev', 'prod').
  /// - [outputDir]: The directory to save the final APK file.
  ///
  /// Returns the path to the built and organized APK file.
  Future<String> build({
    bool release = true,
    String? projectPath,
    String? customName,
    String? environment,
    String? outputDir,
  }) async {
    final buildType = release ? 'release' : 'debug';
    final buildCommand = 'flutter build apk --$buildType';

    if (_dryRun) {
      _logger.info('[DRY RUN] Would execute build command: `$buildCommand`');
      _logger.info(
        '[DRY RUN] Would organize APK with name: `$customName`, env: `$environment`, output: `$outputDir`',
      );
      return 'dry_run_apk_path.apk';
    }

    final shell = Shell(workingDirectory: projectPath);

    _logger.info('🚀 Starting APK build (mode: $buildType)...');

    final result = await shell.run(buildCommand);

    if (result.first.exitCode == 0) {
      final buildOutput = result.outText;
      _logger.fine('Build output:\n$buildOutput');

      final originalApkPath = _apkParserService.getApkPath(
        buildOutput,
        projectPath,
      );
      if (originalApkPath != null) {
        _logger.info('✅ APK built successfully: $originalApkPath');

        final finalApkPath = await _apkOrganizerService.organize(
          originalApkPath,
          projectPath,
          customName,
          environment,
          outputDir,
        );

        return finalApkPath;
      } else {
        _logger.severe('🔥 Could not find APK path in build output.');
        throw Exception('APK build failed: Could not find APK path.');
      }
    } else {
      _logger.severe(
        '🔥 APK build failed with exit code ${result.first.exitCode}:',
      );
      _logger.severe(result.errText);
      throw Exception('APK build failed.');
    }
  }
}
