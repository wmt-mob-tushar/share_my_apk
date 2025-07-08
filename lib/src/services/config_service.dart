import 'dart:io';
import 'package:yaml/yaml.dart';

/// Service for reading configuration from pubspec.yaml.
///
/// This service extracts configuration options for the share_my_apk package
/// from the pubspec.yaml file, allowing users to set default values for
/// various options without specifying them on the command line each time.
class ConfigService {
  /// Reads share_my_apk configuration from pubspec.yaml.
  ///
  /// Looks for a 'share_my_apk' section in the pubspec.yaml file and returns
  /// the configuration as a Map. Returns an empty Map if the file doesn't
  /// exist or if the configuration section is not found.
  ///
  /// ## Example pubspec.yaml configuration:
  ///
  /// ```yaml
  /// share_my_apk:
  ///   token: your_default_token
  ///   provider: diawi
  ///   environment: staging
  ///   output-dir: /custom/output
  /// ```
  static Map<String, dynamic> getConfig() {
    final file = File('pubspec.yaml');
    if (!file.existsSync()) {
      return <String, dynamic>{};
    }

    final content = file.readAsStringSync();
    final yaml = loadYaml(content);

    final config = yaml['share_my_apk'];
    if (config is Map) {
      return Map<String, dynamic>.from(config);
    }
    
    return <String, dynamic>{};
  }
}
