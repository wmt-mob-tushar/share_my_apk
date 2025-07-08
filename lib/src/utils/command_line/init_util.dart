import 'dart:io';
import 'package:logging/logging.dart';

class InitUtil {
  static final Logger _logger = Logger('InitUtil');

  static void generateConfigFile() {
    final configFile = File('share_my_apk.yaml');
    if (configFile.existsSync()) {
      _logger.info('`share_my_apk.yaml` already exists.');
      return;
    }

    configFile.writeAsStringSync('''
# Configuration for the share_my_apk tool.
# You can set default values for the command-line options here.

# Default provider to use for uploads.
# Allowed values: diawi, gofile
# provider: diawi

# API tokens for different providers.
# Get your Diawi token from: https://dashboard.diawi.com/profile/api
# diawi_token: your_diawi_token
# gofile_token: your_gofile_token

# Default path to your Flutter project.
# path: .

# Whether to build in release mode by default.
# release: true

# Custom name for the APK file (without extension).
# name: my-cool-app

# Environment folder (e.g., dev, prod, staging).
# environment: staging

# Output directory for the built APK.
# output-dir: build/my_apks
''');
    _logger.info('`share_my_apk.yaml` created successfully.');
  }
}
