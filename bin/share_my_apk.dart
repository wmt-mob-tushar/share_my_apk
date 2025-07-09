import 'dart:io';

import 'package:intl/intl.dart';
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
  // Configure logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    final emoji = _getEmojiForLevel(record.level);
    final color = _getColorForLevel(record.level);
    final time = DateFormat('HH:mm:ss').format(record.time);

    // Using print here is acceptable for CLI logging output
    // ignore: avoid_print
    print('$color$emoji [$time] ${record.message}$reset');
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

    _printSuccessBox(provider, downloadLink);
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

String _getEmojiForLevel(Level level) {
  if (level == Level.SEVERE) {
    return '💥';
  } else if (level == Level.WARNING) {
    return '⚠️';
  } else if (level == Level.INFO) {
    return 'ℹ️';
  } else if (level == Level.CONFIG) {
    return '⚙️';
  } else if (level == Level.FINE) {
    return '✨';
  } else if (level == Level.FINER) {
    return '🔍';
  } else if (level == Level.FINEST) {
    return '🔬';
  }
  return '✅';
}

void _printSuccessBox(String provider, String downloadLink) {
  final message = 'APK successfully uploaded to $provider!';
  final link = 'Download link: $downloadLink';
  final boxWidth = message.length > link.length ? message.length + 4 : link.length + 4;

  print(green);
  print('╔${'═' * (boxWidth - 2)}╗');
  print('║ ${message.padRight(boxWidth - 3)}║');
  print('║ ${link.padRight(boxWidth - 3)}║');
  print('╚${'═' * (boxWidth - 2)}╝');
  print(reset);
}
