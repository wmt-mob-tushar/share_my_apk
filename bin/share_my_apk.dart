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
    // Welcome message
    _printWelcomeMessage();

    final options = argParserUtil.parse(arguments);

    // Show configuration source
    _showConfigurationInfo(options, logger);

    final apkBuilder = FlutterBuildService();

    final apkPath = await apkBuilder.build(
      release: options.isRelease,
      projectPath: options.path ?? '.',
      customName: options.customName,
      environment: options.environment,
      outputDir: options.outputDir,
      clean: options.clean,
      getPubDeps: options.getPubDeps,
      generateL10n: options.generateL10n,
    );

    final apkFile = File(apkPath);
    final fileSize = await apkFile.length();
    final fileSizeMB = (fileSize / 1024 / 1024);
    var provider = options.provider;
    String? token;

    // Detailed file information
    logger.info('📁 APK Information:');
    logger.info('   • File: ${apkFile.path.split('/').last}');
    logger.info(
      '   • Size: ${fileSizeMB.toStringAsFixed(2)} MB ($fileSize bytes)',
    );
    logger.info('   • Location: $apkPath');

    // Smart provider selection with detailed explanation
    if (provider == 'diawi' && fileSize > 70 * 1024 * 1024) {
      logger.warning(
        '⚡ Smart Provider Switch: APK size (${fileSizeMB.toStringAsFixed(1)} MB) exceeds Diawi\'s 70MB limit.',
      );
      logger.info(
        '🔄 Automatically switching to Gofile.io for better compatibility...',
      );
      provider = 'gofile';
      token = options.gofileToken;
    } else {
      if (provider == 'diawi') {
        token = options.diawiToken;
        logger.info('🎯 Using Diawi (great for team sharing, 70MB limit)');
        if (token == null) {
          logger.warning(
            '⚠️  No Diawi token found. Get one at: https://dashboard.diawi.com/profile/api',
          );
        }
      } else {
        token = options.gofileToken;
        logger.info('🎯 Using Gofile.io (no size limits, public access)');
        if (token == null) {
          logger.info('ℹ️  Running without Gofile token (anonymous upload)');
        }
      }
    }

    final uploader = UploadServiceFactory.create(provider, token: token);

    // Upload preparation
    logger.info('🚀 Starting Upload Process...');
    logger.info('   • Provider: $provider');
    logger.info('   • File size: ${fileSizeMB.toStringAsFixed(2)} MB');
    if (token != null) {
      logger.info('   • Authentication: ✅ Token provided');
    } else {
      logger.info('   • Authentication: 📂 Anonymous upload');
    }

    final downloadLink = await uploader.upload(apkPath);

    // Clear any residual warnings/output before showing success
    // ignore: avoid_print
    print('\n' * 3);
    _printSuccessBox(provider, downloadLink);
  } on ArgumentError catch (e) {
    // ignore: avoid_print
    print(''); // Add spacing
    logger.severe('❌ Configuration Error: ${e.message}');
    // ignore: avoid_print
    print(''); // Add spacing
    _printHelpfulSuggestions(logger);
    exit(1);
  } on ProcessException catch (e) {
    // ignore: avoid_print
    print(''); // Add spacing
    logger.severe('❌ Build Error: ${e.message}');
    // ignore: avoid_print
    print(''); // Add spacing
    _printBuildErrorSuggestions(logger);
    exit(1);
  } on SocketException catch (e) {
    // ignore: avoid_print
    print(''); // Add spacing
    logger.severe('❌ Network Error: ${e.message}');
    // ignore: avoid_print
    print(''); // Add spacing
    _printNetworkErrorSuggestions(logger);
    exit(1);
  } on HttpException catch (e) {
    // ignore: avoid_print
    print(''); // Add spacing
    logger.severe('❌ Upload Error: ${e.message}');
    // ignore: avoid_print
    print(''); // Add spacing
    _printUploadErrorSuggestions(logger);
    exit(1);
  } catch (e) {
    // ignore: avoid_print
    print(''); // Add spacing
    logger.severe('❌ Unexpected Error: $e');
    // ignore: avoid_print
    print(''); // Add spacing
    _printGeneralErrorSuggestions(logger);
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

void _printWelcomeMessage() {
  // Using print here is acceptable for CLI welcome message
  // ignore: avoid_print
  print('$cyan🚀 Share My APK v0.4.0-beta$reset');
  // ignore: avoid_print
  print('$blue   Flutter APK Build & Upload Tool$reset');
  // ignore: avoid_print
  print('');
}

void _showConfigurationInfo(CliOptions options, Logger logger) {
  logger.info('⚙️  Configuration loaded:');

  // Show config source
  final configFile = File('share_my_apk.yaml');
  final pubspecFile = File('pubspec.yaml');

  if (configFile.existsSync()) {
    logger.info('   • Source: share_my_apk.yaml ✅');
  } else if (pubspecFile.existsSync()) {
    logger.info('   • Source: pubspec.yaml (legacy)');
  } else {
    logger.info('   • Source: CLI arguments + defaults');
    logger.info('   💡 Run --init to create a config file');
  }

  logger.info('   • Project: ${options.path ?? "."}');
  logger.info('   • Build mode: ${options.isRelease ? "release" : "debug"}');
  logger.info('   • Provider: ${options.provider}');

  if (options.customName != null) {
    logger.info('   • Custom name: ${options.customName}');
  }
  if (options.environment != null) {
    logger.info('   • Environment: ${options.environment}');
  }
  if (options.outputDir != null) {
    logger.info('   • Output dir: ${options.outputDir}');
  }

  // ignore: avoid_print
  print('');
}

void _printSuccessBox(String provider, String downloadLink) {
  final message = '🎉 APK successfully uploaded to $provider!';
  final link = '🔗 Download: $downloadLink';
  final share = '📱 Share this link to install the APK';
  final tips = provider == 'diawi'
      ? '💡 Diawi links expire after 30 days'
      : '💡 Gofile links are permanent but public';

  final maxLength = [
    message,
    link,
    share,
    tips,
  ].map((s) => s.length).reduce((a, b) => a > b ? a : b);
  final boxWidth = maxLength + 4;

  // Using print here is acceptable for CLI success display
  // ignore: avoid_print
  print(green);
  // ignore: avoid_print
  print('╔${'═' * (boxWidth - 2)}╗');
  // ignore: avoid_print
  print('║ ${message.padRight(boxWidth - 3)}║');
  // ignore: avoid_print
  print('║${' ' * (boxWidth - 2)}║');
  // ignore: avoid_print
  print('║ ${link.padRight(boxWidth - 3)}║');
  // ignore: avoid_print
  print('║ ${share.padRight(boxWidth - 3)}║');
  // ignore: avoid_print
  print('║${' ' * (boxWidth - 2)}║');
  // ignore: avoid_print
  print('║ ${tips.padRight(boxWidth - 3)}║');
  // ignore: avoid_print
  print('╚${'═' * (boxWidth - 2)}╝');
  // ignore: avoid_print
  print(reset);
}

void _printHelpfulSuggestions(Logger logger) {
  // Using print here is acceptable for CLI error display
  // ignore: avoid_print
  print(
    '$yellow╔═══════════════════════════════════════════════════════════════╗$reset',
  );
  // ignore: avoid_print
  print(
    '$yellow║                     💡 TROUBLESHOOTING HELP                   ║$reset',
  );
  // ignore: avoid_print
  print(
    '$yellow╠═══════════════════════════════════════════════════════════════╣$reset',
  );
  // ignore: avoid_print
  print(
    '$yellow║  • Run "share_my_apk --init" to create a config file          ║$reset',
  );
  // ignore: avoid_print
  print(
    '$yellow║  • For Diawi: Get token at https://dashboard.diawi.com/...    ║$reset',
  );
  // ignore: avoid_print
  print(
    '$yellow║  • Use "share_my_apk --help" for all available options        ║$reset',
  );
  // ignore: avoid_print
  print(
    '$yellow║  • Try "share_my_apk --provider gofile" (no token required)   ║$reset',
  );
  // ignore: avoid_print
  print(
    '$yellow╚═══════════════════════════════════════════════════════════════╝$reset',
  );
}

void _printBuildErrorSuggestions(Logger logger) {
  // Using print here is acceptable for CLI error display
  // ignore: avoid_print
  print(
    '$red╔═══════════════════════════════════════════════════════════════╗$reset',
  );
  // ignore: avoid_print
  print(
    '$red║                     🔧 BUILD ERROR HELP                       ║$reset',
  );
  // ignore: avoid_print
  print(
    '$red╠═══════════════════════════════════════════════════════════════╣$reset',
  );
  // ignore: avoid_print
  print(
    '$red║  • Run "flutter doctor" to check Flutter installation         ║$reset',
  );
  // ignore: avoid_print
  print(
    '$red║  • Try "flutter clean && flutter pub get" in your project     ║$reset',
  );
  // ignore: avoid_print
  print(
    '$red║  • Ensure you\'re in a valid Flutter project directory         ║$reset',
  );
  // ignore: avoid_print
  print(
    '$red║  • Check if Android toolchain is properly configured          ║$reset',
  );
  // ignore: avoid_print
  print(
    '$red║  • Try building manually: "flutter build apk --release"       ║$reset',
  );
  // ignore: avoid_print
  print(
    '$red╚═══════════════════════════════════════════════════════════════╝$reset',
  );
}

void _printNetworkErrorSuggestions(Logger logger) {
  // Using print here is acceptable for CLI error display
  // ignore: avoid_print
  print(
    '$red╔═══════════════════════════════════════════════════════════════╗$reset',
  );
  // ignore: avoid_print
  print(
    '$red║                     🌐 NETWORK ERROR HELP                     ║$reset',
  );
  // ignore: avoid_print
  print(
    '$red╠═══════════════════════════════════════════════════════════════╣$reset',
  );
  // ignore: avoid_print
  print(
    '$red║  • Check your internet connection                             ║$reset',
  );
  // ignore: avoid_print
  print(
    '$red║  • Try again in a few minutes (server might be busy)          ║$reset',
  );
  // ignore: avoid_print
  print(
    '$red║  • Check if you\'re behind a firewall or proxy                 ║$reset',
  );
  // ignore: avoid_print
  print(
    '$red║  • Try switching providers (--provider gofile or diawi)       ║$reset',
  );
  // ignore: avoid_print
  print(
    '$red╚═══════════════════════════════════════════════════════════════╝$reset',
  );
}

void _printUploadErrorSuggestions(Logger logger) {
  // Using print here is acceptable for CLI error display
  // ignore: avoid_print
  print(
    '$red╔═══════════════════════════════════════════════════════════════╗$reset',
  );
  // ignore: avoid_print
  print(
    '$red║                     📤 UPLOAD ERROR HELP                      ║$reset',
  );
  // ignore: avoid_print
  print(
    '$red╠═══════════════════════════════════════════════════════════════╣$reset',
  );
  // ignore: avoid_print
  print(
    '$red║  • Verify your API token is correct and active                ║$reset',
  );
  // ignore: avoid_print
  print(
    '$red║  • Check if file size exceeds provider limits (Diawi: 70MB)   ║$reset',
  );
  // ignore: avoid_print
  print(
    '$red║  • Try using Gofile.io: "share_my_apk --provider gofile"       ║$reset',
  );
  // ignore: avoid_print
  print(
    '$red║  • Ensure APK file exists and is not corrupted                ║$reset',
  );
  // ignore: avoid_print
  print(
    '$red╚═══════════════════════════════════════════════════════════════╝$reset',
  );
}

void _printGeneralErrorSuggestions(Logger logger) {
  // Using print here is acceptable for CLI error display
  // ignore: avoid_print
  print(
    '$red╔═══════════════════════════════════════════════════════════════╗$reset',
  );
  // ignore: avoid_print
  print(
    '$red║                     ⚠️  GENERAL ERROR HELP                     ║$reset',
  );
  // ignore: avoid_print
  print(
    '$red╠═══════════════════════════════════════════════════════════════╣$reset',
  );
  // ignore: avoid_print
  print(
    '$red║  • Try running with --help for usage information              ║$reset',
  );
  // ignore: avoid_print
  print(
    '$red║  • Ensure all dependencies are up to date                     ║$reset',
  );
  // ignore: avoid_print
  print(
    '$red║  • Check GitHub issues: github.com/wm-jenildgohel/share_my_apk║$reset',
  );
  // ignore: avoid_print
  print(
    '$red║  • Try running the command again                              ║$reset',
  );
  // ignore: avoid_print
  print(
    '$red╚═══════════════════════════════════════════════════════════════╝$reset',
  );
}
