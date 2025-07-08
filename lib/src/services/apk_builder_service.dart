import 'dart:io';
import 'package:process_run/process_run.dart';
import 'package:logging/logging.dart';
import 'package:yaml/yaml.dart';

/// A comprehensive service for building and organizing Flutter APK files.
///
/// This service handles the complete APK build process, including:
/// - Building Flutter APKs in release or debug mode
/// - Custom file naming with timestamps and version information
/// - Directory organization by environment
/// - Automatic project information extraction from pubspec.yaml
///
/// ## Usage Example
///
/// ```dart
/// final apkBuilder = ApkBuilderService();
///
/// // Basic build
/// final apkPath = await apkBuilder.build();
///
/// // Advanced build with custom options
/// final customApkPath = await apkBuilder.build(
///   release: true,
///   projectPath: '/path/to/flutter/project',
///   customName: 'MyApp_Beta',
///   environment: 'staging',
///   outputDir: '/custom/output/directory',
/// );
/// ```
///
/// The service automatically:
/// - Extracts app name and version from pubspec.yaml
/// - Generates timestamped file names
/// - Creates organized directory structures
/// - Provides detailed logging throughout the process
class ApkBuilderService {
  /// Logger instance for tracking build operations.
  static final Logger _logger = Logger('ApkBuilderService');

  /// Builds a Flutter APK with comprehensive customization options.
  ///
  /// This method performs the complete build workflow:
  /// 1. Executes the Flutter build command
  /// 2. Extracts project information from pubspec.yaml
  /// 3. Generates a custom file name with timestamp
  /// 4. Organizes the output in the specified directory structure
  /// 5. Moves and renames the built APK to the final location
  ///
  /// ## Parameters
  ///
  /// - [release]: Build in release mode if `true`, debug mode if `false`.
  ///   Release builds are optimized for production, while debug builds
  ///   include debugging information. Defaults to `true`.
  ///
  /// - [projectPath]: Path to the Flutter project directory containing
  ///   pubspec.yaml. If not specified, uses the current working directory.
  ///
  /// - [customName]: Custom base name for the APK file. If provided,
  ///   the final name will be `{customName}_{version}_{timestamp}.apk`.
  ///   If not provided, uses the app name from pubspec.yaml.
  ///
  /// - [environment]: Environment subdirectory name for organizing builds.
  ///   Creates a folder structure like `/output/{environment}/file.apk`.
  ///   Common values: 'dev', 'staging', 'prod', 'test'.
  ///
  /// - [outputDir]: Base output directory for the APK file. If not specified,
  ///   defaults to `{projectPath}/build/apk/`. The directory is created
  ///   automatically if it doesn't exist.
  ///
  /// ## Returns
  ///
  /// A [Future<String>] that completes with the absolute path to the
  /// built and organized APK file.
  ///
  /// ## Throws
  ///
  /// - [Exception]: If the Flutter build command fails
  /// - [Exception]: If the APK path cannot be determined from build output
  /// - [FileSystemException]: If file operations (copy, move) fail
  ///
  /// ## Example
  ///
  /// ```dart
  /// try {
  ///   final apkPath = await apkBuilder.build(
  ///     release: true,
  ///     customName: 'MyApp_Release',
  ///     environment: 'prod',
  ///     outputDir: '/builds',
  ///   );
  ///   print('APK built: $apkPath');
  /// } catch (e) {
  ///   print('Build failed: $e');
  /// }
  /// ```
  Future<String> build({
    bool release = true,
    String? projectPath,
    String? customName,
    String? environment,
    String? outputDir,
  }) async {
    // Create shell instance with the specified working directory
    final shell = Shell(workingDirectory: projectPath);
    final buildType = release ? 'release' : 'debug';

    _logger.info('Starting APK build (mode: $buildType)...');

    // Execute Flutter build command
    final result = await shell.run('flutter build apk --$buildType');

    if (result.first.exitCode == 0) {
      // Extract APK path from Flutter build output
      final originalApkPath = _getApkPath(result.outText, buildType, projectPath);
      if (originalApkPath != null) {
        _logger.info('APK built successfully: $originalApkPath');
        
        // Organize and rename the APK according to user preferences
        final finalApkPath = await _organizeApk(
          originalApkPath,
          projectPath,
          customName,
          environment,
          outputDir,
        );
        
        return finalApkPath;
      } else {
        _logger.severe('Could not find APK path in build output.');
        throw Exception('APK build failed: Could not find APK path.');
      }
    } else {
      _logger.severe('APK build failed:');
      _logger.severe(result.errText);
      throw Exception('APK build failed.');
    }
  }

  /// Extracts the APK file path from Flutter build command output.
  ///
  /// Parses the build output to find the "Built [path].apk" line and
  /// constructs the absolute path to the generated APK file.
  ///
  /// Returns `null` if the APK path cannot be determined from the output.
  String? _getApkPath(
    String buildOutput,
    String buildType,
    String? projectPath,
  ) {
    // Look for the "Built [path].apk" pattern in build output
    final regex = RegExp(r'Built (\S+\.apk)');
    final match = regex.firstMatch(buildOutput);
    if (match != null) {
      final relativePath = match.group(1);
      if (relativePath != null) {
        // Convert relative path to absolute path
        return '${projectPath ?? '.'}/$relativePath';
      }
    }
    return null;
  }

  /// Organizes the built APK file according to user preferences.
  ///
  /// This method handles the complete file organization workflow:
  /// 1. Checks if any custom organization is requested
  /// 2. Extracts app information from pubspec.yaml
  /// 3. Generates a custom file name with timestamp
  /// 4. Creates the destination directory structure
  /// 5. Moves and renames the APK to the final location
  ///
  /// If no custom options are provided, returns the original APK path unchanged.
  Future<String> _organizeApk(
    String originalApkPath,
    String? projectPath,
    String? customName,
    String? environment,
    String? outputDir,
  ) async {
    final originalFile = File(originalApkPath);
    
    // If no custom organization options are provided, use original path
    if (customName == null && environment == null && outputDir == null) {
      return originalApkPath;
    }

    // Extract app information from pubspec.yaml for naming
    final appInfo = _getAppInfo(projectPath);
    
    // Generate the final file name with timestamp
    final fileName = _generateFileName(customName, appInfo);
    
    // Create the organized directory structure
    final destDir = _createDestinationDirectory(outputDir, environment, projectPath);
    
    // Construct the final APK path
    final finalApkPath = '$destDir/$fileName.apk';
    
    // Copy the APK to its final location and remove the original
    await originalFile.copy(finalApkPath);
    await originalFile.delete();
    
    _logger.info('APK organized to: $finalApkPath');
    return finalApkPath;
  }

  /// Extracts app name and version information from pubspec.yaml.
  ///
  /// Reads the pubspec.yaml file from the project directory and extracts
  /// the 'name' and 'version' fields for use in file naming.
  ///
  /// Returns default values if the file is not found or cannot be parsed.
  Map<String, String> _getAppInfo(String? projectPath) {
    final pubspecPath = '${projectPath ?? '.'}/pubspec.yaml';
    final pubspecFile = File(pubspecPath);
    
    // Check if pubspec.yaml exists
    if (!pubspecFile.existsSync()) {
      _logger.warning('pubspec.yaml not found at $pubspecPath');
      return {'name': 'app', 'version': '1.0.0'};
    }

    try {
      // Parse YAML content
      final content = pubspecFile.readAsStringSync();
      final yaml = loadYaml(content);
      
      return {
        'name': yaml['name']?.toString() ?? 'app',
        'version': yaml['version']?.toString() ?? '1.0.0',
      };
    } catch (e) {
      _logger.warning('Error reading pubspec.yaml: $e');
      return {'name': 'app', 'version': '1.0.0'};
    }
  }

  /// Generates a timestamped file name for the APK.
  ///
  /// Creates a file name in the format:
  /// - If customName provided: `{customName}_{version}_{timestamp}`
  /// - If not: `{appName}_{version}_{timestamp}`
  ///
  /// The timestamp format is: YYYY_MM_DD_HH_MM_SS
  String _generateFileName(String? customName, Map<String, String> appInfo) {
    // Generate timestamp in a file-system friendly format
    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(RegExp(r'[:.T-]'), '_')
        .split('.')[0];
    
    if (customName != null && customName.isNotEmpty) {
      return '${customName}_${appInfo['version']}_$timestamp';
    }
    
    // Sanitize app name for file system compatibility
    final appName = appInfo['name']!.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
    return '${appName}_${appInfo['version']}_$timestamp';
  }

  /// Creates the destination directory structure for the APK file.
  ///
  /// Handles the creation of organized directory structures based on:
  /// - Custom output directory (if specified)
  /// - Environment subdirectory (if specified)
  /// - Default fallback directory structure
  ///
  /// Creates directories recursively if they don't exist.
  String _createDestinationDirectory(String? outputDir, String? environment, String? projectPath) {
    // Determine base output directory
    String baseDir;
    if (outputDir != null) {
      baseDir = outputDir;
    } else {
      baseDir = '${projectPath ?? '.'}/build/apk';
    }
    
    // Add environment subdirectory if specified
    String finalDir = baseDir;
    if (environment != null && environment.isNotEmpty) {
      finalDir = '$baseDir/$environment';
    }
    
    // Create directory structure if it doesn't exist
    final directory = Directory(finalDir);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
      _logger.info('Created directory: $finalDir');
    }
    
    return finalDir;
  }
}
