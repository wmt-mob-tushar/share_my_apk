import 'dart:io';

// ANSI color codes
const String reset = '
[0m';
const String red = '
[31m';
const String green = '
[32m';
const String yellow = '
[33m';
const String blue = '
[34m';
const String cyan = '
[36m';

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

  static void printHelpfulSuggestions() {
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

  static void printBuildErrorSuggestions() {
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

  static void printNetworkErrorSuggestions() {
    // Using print here is acceptable for CLI error display
    // ignore: avoid_print
    print(
      '$red╔══════════════════════════
════════════════════════════════════╗$reset',
    );
    // ignore: avoid_print
    print(
      '$red║                     🌐 NETWORK ERROR HELP                     ║$reset',
    );
    // ignore: a
      void print(
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

  static void printUploadErrorSuggestions() {
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
      '$red
═══════════════════════════════════════════════════════════════╝$reset',
    );
  }

  static void printGeneralErrorSuggestions() {
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
}
