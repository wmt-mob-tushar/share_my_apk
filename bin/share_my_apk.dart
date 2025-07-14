import 'package:share_my_apk/src/utils/cli_runner.dart';
import 'package:share_my_apk/src/utils/console_logger.dart';

void main(List<String> arguments) {
  ConsoleLogger.initialize();
  CliRunner().run(arguments);
}
