import 'dart:io';
import 'dart:math';

import 'package:logging/logging.dart';
import 'package:share_my_apk/share_my_apk.dart';

// ANSI color codes
const String reset = '\x1B[0m';
const String red = '\x1B[31m';
const String green = '\x1B[32m';
const String yellow = '\x1B[33m';
const String blue = '\x1B[34m';
const String magenta = '\x1B[35m';
const String cyan = '\x1B[36m';

void main(List<String> arguments) async {
  // A list of creative emojis for logging
  final funEmojis = ['🎉', '🚀', '🤖', '🍕', '👾', '🔥', '💡', '⭐', '✅', '✨'];
  final random = Random();

  // Configure logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    final emoji = funEmojis[random.nextInt(funEmojis.length)];
    final color = _getColorForLevel(record.level);
    // Using print here is acceptable for CLI logging output
    // ignore: avoid_print
    print('$color$emoji ${record.level.name}: ${record.message}$reset');
  });

  final argParserUtil = ArgParserUtil();
  final Logger logger = Logger('main');

  try {
    final options = argParserUtil.parse(arguments);
    final apkBuilder = FlutterBuildService();

    final apkPath = await apkBuilder.build(
      release: options.isRelease,
      projectPath: options.path ?? '.',
      customName: options.customName,
      environment: options.environment,
      outputDir: options.outputDir,
    );

    final apkFile = File(apkPath);
    final fileSize = await apkFile.length();
    var provider = options.provider;
    String? token;

    if (provider == 'diawi' && fileSize > 70 * 1024 * 1024) {
      logger.warning(
        'APK size is greater than 70MB. Forcefully using gofile.io instead of diawi.',
      );
      provider = 'gofile';
      token = options.gofileToken;
    } else {
      if (provider == 'diawi') {
        token = options.diawiToken;
      } else {
        token = options.gofileToken;
      }
    }

    final uploader = UploadServiceFactory.create(provider, token: token);

    final downloadLink = await uploader.upload(apkPath);

    logger.info('APK successfully uploaded to $provider!');
    logger.info('Download link: $downloadLink');
  } on ArgumentError catch (e) {
    logger.severe(e.message);
    exit(1);
  } catch (e) {
    logger.severe('An unexpected error occurred: $e');
    exit(1);
  }
}

String _getColorForLevel(Level level) {
  if (level == Level.SEVERE) {
    return red;
  } else if (level == Level.WARNING) {
    return yellow;
  } else if (level == Level.INFO) {
    return green;
  } else if (level == Level.CONFIG) {
    return blue;
  } else if (level == Level.FINE) {
    return cyan;
  } else if (level == Level.FINER) {
    return magenta;
  } else if (level == Level.FINEST) {
    return magenta;
  }
  return reset;
}
