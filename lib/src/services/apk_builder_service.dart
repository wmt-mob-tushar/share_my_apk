import 'package:process_run/process_run.dart';
import 'package:logging/logging.dart';

/// A service class for building Flutter APKs.
class ApkBuilderService {
  static final Logger _logger = Logger('ApkBuilderService');

  /// Builds the APK and returns the path to the generated file.
  ///
  /// Throws an [Exception] if the build fails.
  Future<String> build({bool release = true, String? projectPath}) async {
    final shell = Shell(workingDirectory: projectPath);
    final buildType = release ? 'release' : 'debug';

    _logger.info('Starting APK build (mode: $buildType)...');

    final result = await shell.run('flutter build apk --$buildType');

    if (result.first.exitCode == 0) {
      final apkPath = _getApkPath(result.outText, buildType, projectPath);
      if (apkPath != null) {
        _logger.info('APK built successfully: $apkPath');
        return apkPath;
      } else {
        _logger.severe(
          'Could not find APK path in build output.',
        );
        throw Exception('APK build failed: Could not find APK path.');
      }
    } else {
      _logger.severe('APK build failed:');
      _logger.severe(result.errText);
      throw Exception('APK build failed.');
    }
  }

  String? _getApkPath(
    String buildOutput,
    String buildType,
    String? projectPath,
  ) {
    final regex = RegExp(r'Built (\S+\.apk)');
    final match = regex.firstMatch(buildOutput);
    if (match != null) {
      final relativePath = match.group(1);
      if (relativePath != null) {
        return '${projectPath ?? '.'}/$relativePath';
      }
    }
    return null;
  }
}
