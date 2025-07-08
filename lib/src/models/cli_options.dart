/// Configuration model for command-line interface options.
///
/// This class encapsulates all the configurable options that can be passed
/// to the share_my_apk command-line tool or used programmatically when
/// building and uploading APK files.
///
/// ## Example Usage
///
/// ```dart
/// final options = CliOptions(
///   token: 'your_diawi_token',
///   path: '/path/to/flutter/project',
///   isRelease: true,
///   provider: 'diawi',
///   customName: 'MyApp_Beta',
///   environment: 'staging',
///   outputDir: '/custom/output/directory',
/// );
/// ```
class CliOptions {
  /// API token for upload providers.
  ///
  /// Required for Diawi uploads, optional for Gofile.io.
  /// Get your Diawi token from: https://dashboard.diawi.com/profile/api
  final String? token;

  /// Path to the Flutter project directory.
  ///
  /// If not specified, the current working directory will be used.
  /// The path should contain a valid Flutter project with pubspec.yaml.
  final String? path;

  /// Whether to build in release mode.
  ///
  /// When `true`, builds the APK in release mode (optimized for production).
  /// When `false`, builds in debug mode (includes debugging information).
  /// Defaults to `true`.
  final bool isRelease;

  /// Upload provider to use for APK distribution.
  ///
  /// Supported providers:
  /// - `'diawi'`: Upload to Diawi service (requires token)
  /// - `'gofile'`: Upload to Gofile.io service (no token required)
  ///
  /// The tool automatically switches from Diawi to Gofile.io if the APK
  /// size exceeds 70MB and Diawi is selected.
  final String provider;

  /// Custom name for the generated APK file.
  ///
  /// If provided, the APK will be named using the format:
  /// `{customName}_{version}_{timestamp}.apk`
  ///
  /// If not provided, uses the app name from pubspec.yaml:
  /// `{appName}_{version}_{timestamp}.apk`
  final String? customName;

  /// Environment folder for organizing builds.
  ///
  /// When specified, creates a subdirectory with this name in the output
  /// directory. Commonly used values: 'dev', 'staging', 'prod', 'test'.
  ///
  /// Example structure: `/output/staging/MyApp_1.0.0_timestamp.apk`
  final String? environment;

  /// Custom output directory for the built APK.
  ///
  /// If not specified, defaults to `{projectPath}/build/apk/`.
  /// The directory will be created if it doesn't exist.
  final String? outputDir;

  /// Creates a new [CliOptions] instance.
  ///
  /// All parameters are optional and have sensible defaults.
  /// The [isRelease] parameter defaults to `true` and [provider] defaults to `'diawi'`.
  const CliOptions({
    this.token,
    this.path,
    this.isRelease = true,
    this.provider = 'diawi',
    this.customName,
    this.environment,
    this.outputDir,
  });

  /// Creates a copy of this [CliOptions] with the given fields replaced.
  ///
  /// This method is useful for creating variations of the configuration
  /// without modifying the original instance.
  CliOptions copyWith({
    String? token,
    String? path,
    bool? isRelease,
    String? provider,
    String? customName,
    String? environment,
    String? outputDir,
  }) {
    return CliOptions(
      token: token ?? this.token,
      path: path ?? this.path,
      isRelease: isRelease ?? this.isRelease,
      provider: provider ?? this.provider,
      customName: customName ?? this.customName,
      environment: environment ?? this.environment,
      outputDir: outputDir ?? this.outputDir,
    );
  }

  @override
  String toString() {
    return 'CliOptions('
        'token: ${token != null ? '***' : 'null'}, '
        'path: $path, '
        'isRelease: $isRelease, '
        'provider: $provider, '
        'customName: $customName, '
        'environment: $environment, '
        'outputDir: $outputDir'
        ')';
  }
}
