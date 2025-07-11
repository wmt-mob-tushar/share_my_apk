import 'dart:io';

import 'package:share_my_apk/share_my_apk.dart';
import 'package:share_my_apk/src/utils/console_logger.dart';
import 'package:share_my_apk/src/utils/message_util.dart' as message_util;
import 'package:yaml/yaml.dart';

class CliRunner {
  final ConsoleLogger _logger;

  CliRunner() : _logger = ConsoleLogger('main');

  Future<void> run(List<String> arguments) async {
    try {
      final packageVersion = await _getPackageVersion();
      _printWelcomeMessage(packageVersion);

      final argParserUtil = ArgParserUtil();
      final options = argParserUtil.parse(arguments);

      _showConfigurationInfo(options);

      final apkBuilder = FlutterBuildService(logger: _logger);

      final apkPath = await apkBuilder.build(
        release: options.isRelease,
        projectPath: options.path ?? '.',
        customName: options.customName,
        environment: options.environment,
        outputDir: options.outputDir,
        clean: options.clean,
        getPubDeps: options.getPubDeps,
        generateL10n: options.generateL10n,
        verbose: options.verbose,
      );

      final apkFile = File(apkPath);
      final fileSize = await apkFile.length();
      final fileSizeMB = (fileSize / 1024 / 1024);
      var provider = options.provider;
      String? token;

      _logger.info('📁 APK Information:');
      _logger.info('   • File: ${apkFile.path.split('/').last}');
      _logger.info(
        '   • Size: ${fileSizeMB.toStringAsFixed(2)} MB ($fileSize bytes)',
      );
      _logger.info('   • Location: $apkPath');

      if (provider == 'diawi' && fileSize > 70 * 1024 * 1024) {
        _logger.warning(
          '⚡ Smart Provider Switch: APK size (${fileSizeMB.toStringAsFixed(1)} MB) exceeds Diawi's 70MB limit.',
        );
        _logger.info(
          '🔄 Automatically switching to Gofile.io for better compatibility...',
        );
        provider = 'gofile';
        token = options.gofileToken;
      } else {
        if (provider == 'diawi') {
          token = options.diawiToken;
          _logger.info('🎯 Using Diawi (great for team sharing, 70MB limit)');
          if (token == null) {
            _logger.warning(
              '⚠️  No Diawi token found. Get one at: https://dashboard.diawi.com/profile/api',
            );
          }
        } else {
          token = options.gofileToken;
          _logger.info('🎯 Using Gofile.io (no size limits, public access)');
          if (token == null) {
            _logger.info('ℹ️  Running without Gofile token (anonymous upload)');
          }
        }
      }

      final uploader = UploadServiceFactory.create(provider, token: token);

      _logger.info('🚀 Starting Upload Process...');
      _logger.info('   • Provider: $provider');
      _logger.info('   • File size: ${fileSizeMB.toStringAsFixed(2)} MB');
      if (token != null) {
        _logger.info('   • Authentication: ✅ Token provided');
      } else {
        _logger.info('   • Authentication: 📂 Anonymous upload');
      }

      final downloadLink = await uploader.upload(apkPath);

      print('
' * 3);
      message_util.MessageUtil.printSuccessBox(provider, downloadLink);
    } on ArgumentError catch (e) {
      _logger.severe('❌ Configuration Error: ${e.message}');
      message_util.MessageUtil.printHelpfulSuggestions();
      exit(1);
    } on ProcessException catch (e) {
      _logger.severe('❌ Build Error: ${e.message}');
      message_util.MessageUtil.printBuildErrorSuggestions();
      exit(1);
    } on SocketException catch (e) {
      _logger.severe('❌ Network Error: ${e.message}');
      message_util.MessageUtil.printNetworkErrorSuggestions();
      exit(1);
    } on HttpException catch (e) {
      _logger.severe('❌ Upload Error: ${e.message}');
      message_util.MessageUtil.printUploadErrorSuggestions();
      exit(1);
    } catch (e) {
      _logger.severe('❌ Unexpected Error: $e');
      message_util.MessageUtil.printGeneralErrorSuggestions();
      exit(1);
    }
  }

  void _printWelcomeMessage(String version) {
    _logger.info('${cyan}🚀 Share My APK v$version$reset');
    _logger.info('$blue   Flutter APK Build & Upload Tool$reset');
    _logger.info('');
  }

  Future<String> _getPackageVersion() async {
    try {
      final pubspecFile = File('pubspec.yaml');
      final yamlString = await pubspecFile.readAsString();
      final yamlMap = loadYaml(yamlString);
      return yamlMap['version'] as String;
    } catch (e) {
      _logger.warning('⚠️  Could not read package version from pubspec.yaml: $e');
      return 'Unknown';
    }
  }

  void _showConfigurationInfo(CliOptions options) {
    _logger.info('⚙️  Configuration loaded:');

    final configFile = File('share_my_apk.yaml');
    final pubspecFile = File('pubspec.yaml');

    if (configFile.existsSync()) {
      _logger.info('   • Source: share_my_apk.yaml ✅');
    } else if (pubspecFile.existsSync()) {
      _logger.info('   • Source: pubspec.yaml (legacy)');
    } else {
      _logger.info('   • Source: CLI arguments + defaults');
      _logger.info('   💡 Run --init to create a config file');
    }

    _logger.info('   • Project: ${options.path ?? "."}');
    _logger.info('   • Build mode: ${options.isRelease ? "release" : "debug"}');
    _logger.info('   • Provider: ${options.provider}');

    if (options.customName != null) {
      _logger.info('   • Custom name: ${options.customName}');
    }
    if (options.environment != null) {
      _logger.info('   • Environment: ${options.environment}');
    }
    if (options.outputDir != null) {
      _logger.info('   • Output dir: ${options.outputDir}');
    }

    print('');
  }
}
