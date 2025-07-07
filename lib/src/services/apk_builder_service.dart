import 'package:process_run/process_run.dart';
import 'package:snug_logger/snug_logger.dart';

/// A service class for building Flutter APKs.
class ApkBuilderService {
  /// Builds the APK and returns the path to the generated file.
  ///
  /// Throws an [Exception] if the build fails.
  Future<String> build({bool release = true, String? projectPath}) async {
    final shell = Shell(workingDirectory: projectPath);
    final buildType = release ? 'release' : 'debug';

    snugLog('Starting APK build (mode: $buildType)...', logType: LogType.info);

    final result = await shell.run('flutter build apk --$buildType');

    if (result.first.exitCode == 0) {
      final apkPath = _getApkPath(result.outText, buildType, projectPath);
      if (apkPath != null) {
        snugLog('APK built successfully: $apkPath', logType: LogType.info);
        return apkPath;
      } else {
        snugLog(
          'Could not find APK path in build output.',
          logType: LogType.error,
        );
        throw Exception('APK build failed: Could not find APK path.');
      }
    } else {
      snugLog('APK build failed:', logType: LogType.error);
      snugLog(result.errText, logType: LogType.error);
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
