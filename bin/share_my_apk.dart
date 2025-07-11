import 'package:share_my_apk/src/utils/cli_runner.dart';
import 'package:share_my_apk/src/utils/console_logger.dart';

void main(List<String> arguments) {
  ConsoleLogger.initialize();
  CliRunner().run(arguments);
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
