import 'dart:io';

import 'package:args/args.dart';
import 'package:share_my_apk/src/models/cli_options.dart';
import 'package:share_my_apk/src/services/config_service.dart';

/// A utility class for parsing command-line arguments.
class ArgParserUtil {
  static const _help = 'help';
  static const _diawiToken = 'diawi-token';
  static const _gofileToken = 'gofile-token';
  static const _path = 'path';
  static const _release = 'release';
  static const _provider = 'provider';
  static const _customName = 'name';
  static const _environment = 'environment';
  static const _outputDir = 'output-dir';

  final ArgParser _parser;

  /// Creates a new [ArgParserUtil] with pre-configured argument definitions.
  ///
  /// Sets up all available command-line options including tokens, paths,
  /// build modes, providers, and file organization options.
  ArgParserUtil()
      : _parser = ArgParser()
          ..addFlag(
            _help,
            abbr: 'h',
            negatable: false,
            help: 'Displays this help message.',
          )
          ..addOption(
            _diawiToken,
            help: 'Your API token for Diawi.',
          )
          ..addOption(
            _gofileToken,
            help: 'Your API token for Gofile.',
          )
          ..addOption(
            _path,
            abbr: 'p',
            help: 'Path to your Flutter project.',
          )
          ..addFlag(
            _release,
            defaultsTo: true,
            help: 'Build in release mode.',
          )
          ..addOption(
            _provider,
            help: 'The upload provider to use.',
            allowed: ['diawi', 'gofile'],
            defaultsTo: 'diawi',
          )
          ..addOption(
            _customName,
            abbr: 'n',
            help: 'Custom name for the APK file (without extension).',
          )
          ..addOption(
            _environment,
            abbr: 'e',
            help: 'Environment folder (dev, prod, staging, etc.).',
          )
          ..addOption(
            _outputDir,
            abbr: 'o',
            help: 'Output directory for the built APK.',
          );

  /// Parses the command-line arguments and returns a [CliOptions] object.
  ///
  /// Throws an [ArgumentError] if the token is not provided when required.
  CliOptions parse(List<String> args) {
    final argResults = _parser.parse(args);

    if (argResults[_help] as bool) {
      _printHelp();
      exit(0);
    }

    final config = ConfigService.getConfig();

    final provider =
        argResults[_provider] as String? ?? (config['provider']?.toString() ?? 'diawi');

    final diawiToken =
        argResults[_diawiToken] as String? ?? config['diawi_token']?.toString();
    final gofileToken =
        argResults[_gofileToken] as String? ?? config['gofile_token']?.toString();

    String? token;
    if (provider == 'diawi') {
      token = diawiToken;
    } else if (provider == 'gofile') {
      token = gofileToken;
    }

    final path = argResults[_path] as String? ?? config['path']?.toString();
    final isRelease =
        argResults[_release] as bool? ?? (config['release'] as bool? ?? true);
    final customName =
        argResults[_customName] as String? ?? config['name']?.toString();
    final environment = argResults[_environment] as String? ??
        config['environment']?.toString();
    final outputDir =
        argResults[_outputDir] as String? ?? config['output-dir']?.toString();

    if (provider == 'diawi' && token == null) {
      throw ArgumentError(
          'Usage: share_my_apk --provider diawi --diawi-token <your_diawi_token>\n${_parser.usage}');
    }

    return CliOptions(
      token: token,
      path: path,
      isRelease: isRelease,
      provider: provider,
      customName: customName,
      environment: environment,
      outputDir: outputDir,
      diawiToken: diawiToken,
      gofileToken: gofileToken,
    );
  }

  void _printHelp() {
    print('''
A powerful command-line tool to build and upload your Flutter APKs.

Usage: share_my_apk [options]

Options:
${_parser.usage}

Configuration:
  You can set default values for the options in a `share_my_apk.yaml` file in your project's root directory.

  Example `share_my_apk.yaml`:
  
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
  }
}
