import 'package:args/args.dart';
import 'package:share_my_apk/src/models/cli_options.dart';
import 'package:share_my_apk/src/services/config_service.dart';

/// A utility class for parsing command-line arguments.
class ArgParserUtil {
  static const _token = 'token';
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
          ..addOption(
            _token,
            abbr: 't',
            help: 'Your API token.',
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
    final config = ConfigService.getConfig();

    final token = argResults[_token] as String? ?? config['token']?.toString();
    final path = argResults[_path] as String? ?? config['path']?.toString();
    final isRelease = argResults[_release] as bool? ?? (config['release'] as bool? ?? true);
    final provider = argResults[_provider] as String? ?? (config['provider']?.toString() ?? 'diawi');
    final customName = argResults[_customName] as String? ?? config['name']?.toString();
    final environment = argResults[_environment] as String? ?? config['environment']?.toString();
    final outputDir = argResults[_outputDir] as String? ?? config['output-dir']?.toString();

    if (provider == 'diawi' && token == null) {
      throw ArgumentError(
          'Usage: share_my_apk --provider diawi -t <your_diawi_token>\n${_parser.usage}');
    }

    return CliOptions(
      token: token,
      path: path,
      isRelease: isRelease,
      provider: provider,
      customName: customName,
      environment: environment,
      outputDir: outputDir,
    );
  }
}
