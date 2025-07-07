import 'package:args/args.dart';
import 'package:share_my_apk/src/models/cli_options.dart';
import 'package:share_my_apk/src/services/config_service.dart';

/// A utility class for parsing command-line arguments.
class ArgParserUtil {
  static const _token = 'token';
  static const _path = 'path';
  static const _release = 'release';
  static const _provider = 'provider';

  final ArgParser _parser;

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
          );

  /// Parses the command-line arguments and returns a [CliOptions] object.
  ///
  /// Throws an [ArgumentError] if the token is not provided when required.
  CliOptions parse(List<String> args) {
    final argResults = _parser.parse(args);
    final config = ConfigService.getConfig();

    final token = argResults[_token] ?? config['token'];
    final path = argResults[_path] ?? config['path'];
    final isRelease = argResults[_release] ?? config['release'] ?? true;
    final provider = argResults[_provider] ?? config['provider'] ?? 'diawi';

    if (provider == 'diawi' && token == null) {
      throw ArgumentError(
          'Usage: share_my_apk --provider diawi -t <your_diawi_token>\n${_parser.usage}');
    }

    return CliOptions(
      token: token,
      path: path,
      isRelease: isRelease,
      provider: provider,
    );
  }
}
