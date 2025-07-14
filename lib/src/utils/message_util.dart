import 'dart:io';

// ANSI color codes
const String reset = '\x1B[0m';
const String red = '\x1B[31m';
const String green = '\x1B[32m';
const String yellow = '\x1B[33m';
const String blue = '\x1B[34m';
const String cyan = '\x1B[36m';

class MessageUtil {
  static void printSuccessBox(String provider, String downloadLink) {
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

    stdout.writeln(green);
    stdout.writeln('╔${'═' * (boxWidth - 2)}╗');
    stdout.writeln('║ ${message.padRight(boxWidth - 3)}║');
    stdout.writeln('║${' ' * (boxWidth - 2)}║');
    stdout.writeln('║ ${link.padRight(boxWidth - 3)}║');
    stdout.writeln('║ ${share.padRight(boxWidth - 3)}║');
    stdout.writeln('║${' ' * (boxWidth - 2)}║');
    stdout.writeln('║ ${tips.padRight(boxWidth - 3)}║');
    stdout.writeln('╚${'═' * (boxWidth - 2)}╝');
    stdout.writeln(reset);
  }

  static void printHelpfulSuggestions() {
    stdout.writeln(
      '$yellow╔═══════════════════════════════════════════════════════════════╗$reset',
    );
    stdout.writeln(
      '$yellow║                     💡 TROUBLESHOOTING HELP                   ║$reset',
    );
    stdout.writeln(
      '$yellow╠═══════════════════════════════════════════════════════════════╣$reset',
    );
    stdout.writeln(
      '$yellow║  • Run "share_my_apk --init" to create a config file          ║$reset',
    );
    stdout.writeln(
      '$yellow║  • For Diawi: Get token at https://dashboard.diawi.com/...    ║$reset',
    );
    stdout.writeln(
      '$yellow║  • Use "share_my_apk --help" for all available options        ║$reset',
    );
    stdout.writeln(
      '$yellow║  • Try "share_my_apk --provider gofile" (no token required)   ║$reset',
    );
    stdout.writeln(
      '$yellow╚═══════════════════════════════════════════════════════════════╝$reset',
    );
  }

  static void printBuildErrorSuggestions() {
    stdout.writeln(
      '$red╔═══════════════════════════════════════════════════════════════╗$reset',
    );
    stdout.writeln(
      '$red║                     🔧 BUILD ERROR HELP                       ║$reset',
    );
    stdout.writeln(
      '$red╠═══════════════════════════════════════════════════════════════╣$reset',
    );
    stdout.writeln(
      '$red║  • Run "flutter doctor" to check Flutter installation         ║$reset',
    );
    stdout.writeln(
      '$red║  • Try "flutter clean && flutter pub get" in your project     ║$reset',
    );
    stdout.writeln(
      '$red║  • Ensure you\'re in a valid Flutter project directory         ║$reset',
    );
    stdout.writeln(
      '$red║  • Check if Android toolchain is properly configured          ║$reset',
    );
    stdout.writeln(
      '$red║  • Try building manually: "flutter build apk --release"       ║$reset',
    );
    stdout.writeln(
      '$red╚═══════════════════════════════════════════════════════════════╝$reset',
    );
  }

  static void printNetworkErrorSuggestions() {
    stdout.writeln(
      '$red╔═══════════════════════════════════════════════════════════════╗$reset',
    );
    stdout.writeln(
      '$red║                     🌐 NETWORK ERROR HELP                     ║$reset',
    );
    stdout.writeln(
      '$red╠═══════════════════════════════════════════════════════════════╣$reset',
    );
    stdout.writeln(
      '$red║  • Check your internet connection                             ║$reset',
    );
    stdout.writeln(
      '$red║  • Try again in a few minutes (server might be busy)          ║$reset',
    );
    stdout.writeln(
      '$red║  • Check if you\'re behind a firewall or proxy                 ║$reset',
    );
    stdout.writeln(
      '$red║  • Try switching providers (--provider gofile or diawi)       ║$reset',
    );
    stdout.writeln(
      '$red╚═══════════════════════════════════════════════════════════════╝$reset',
    );
  }

  static void printUploadErrorSuggestions() {
    stdout.writeln(
      '$red╔═══════════════════════════════════════════════════════════════╗$reset',
    );
    stdout.writeln(
      '$red║                     📤 UPLOAD ERROR HELP                      ║$reset',
    );
    stdout.writeln(
      '$red╠═══════════════════════════════════════════════════════════════╣$reset',
    );
    stdout.writeln(
      '$red║  • Verify your API token is correct and active                ║$reset',
    );
    stdout.writeln(
      '$red║  • Check if file size exceeds provider limits (Diawi: 70MB)   ║$reset',
    );
    stdout.writeln(
      '$red║  • Try using Gofile.io: "share_my_apk --provider gofile"       ║$reset',
    );
    stdout.writeln(
      '$red║  • Ensure APK file exists and is not corrupted                ║$reset',
    );
    stdout.writeln(
      '$red╚═══════════════════════════════════════════════════════════════╝$reset',
    );
  }

  static void printGeneralErrorSuggestions() {
    stdout.writeln(
      '$red╔═══════════════════════════════════════════════════════════════╗$reset',
    );
    stdout.writeln(
      '$red║                     ⚠️  GENERAL ERROR HELP                     ║$reset',
    );
    stdout.writeln(
      '$red╠═══════════════════════════════════════════════════════════════╣$reset',
    );
    stdout.writeln(
      '$red║  • Try running with --help for usage information              ║$reset',
    );
    stdout.writeln(
      '$red║  • Ensure all dependencies are up to date                     ║$reset',
    );
    stdout.writeln(
      '$red║  • Check GitHub issues: github.com/wm-jenildgohel/share_my_apk║$reset',
    );
    stdout.writeln(
      '$red║  • Try running the command again                              ║$reset',
    );
    stdout.writeln(
      '$red╚═══════════════════════════════════════════════════════════════╝$reset',
    );
  }
}
