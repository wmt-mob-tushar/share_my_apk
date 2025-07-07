import 'dart:io';
import 'package:yaml/yaml.dart';

class ConfigService {
  static Map<String, dynamic> getConfig() {
    final file = File('pubspec.yaml');
    if (!file.existsSync()) {
      return {};
    }

    final content = file.readAsStringSync();
    final yaml = loadYaml(content);

    return yaml['share_my_apk'] ?? {};
  }
}
