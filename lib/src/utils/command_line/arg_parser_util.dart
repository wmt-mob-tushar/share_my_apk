import 'dart:io';

import 'package:args/args.dart';
import 'package:share_my_apk/src/models/cli_options.dart';
import 'package:share_my_apk/src/services/config_service.dart';
import 'package:share_my_apk/src/utils/command_line/help_util.dart';
import 'package:share_my_apk/src/utils/command_line/init_util.dart';

/// A utility class for parsing command-line arguments.
class ArgParserUtil {
  static const _help = 'help';
  static const _init = 'init';
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
        ..addFlag(
          _init,
          negatable: false,
          help: 'Generates a `share_my_apk.yaml` configuration file.',
        )
        ..addOption(_diawiToken, help: 'Your API token for Diawi.')
        ..addOption(_gofileToken, help: 'Your API token for Gofile.')
        ..addOption(_path, abbr: 'p', help: 'Path to your Flutter project.')
        ..addFlag(_release, defaultsTo: true, help: 'Build in release mode.')
        ..addOption(
          _provider,
          help: 'The upload provider to use.',
          allowed: ['diawi', 'gofile'],
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
      HelpUtil.printHelp(_parser.usage);
      exit(0);
    }

    if (argResults[_init] as bool) {
      InitUtil.generateConfigFile();
      exit(0);
    }

    final config = ConfigService.getConfig();

    final provider =
        argResults[_provider] as String? ??
        (config['provider']?.toString() ?? 'diawi');

    final diawiToken =
        argResults[_diawiToken] as String? ?? config['diawi_token']?.toString();
    final gofileToken =
        argResults[_gofileToken] as String? ??
        config['gofile_token']?.toString();

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
    final environment =
        argResults[_environment] as String? ??
        config['environment']?.toString();
    final outputDir =
        argResults[_outputDir] as String? ?? config['output-dir']?.toString();

    if (provider == 'diawi' && token == null) {
      throw ArgumentError(
        'Usage: share_my_apk --provider diawi --diawi-token <your_diawi_token>\n${_parser.usage}',
      );
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
}
