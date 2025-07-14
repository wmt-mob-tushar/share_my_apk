import 'package:share_my_apk/src/utils/cli_runner.dart';
import 'package:share_my_apk/src/utils/console_logger.dart';

import 'dart:io';

void main(List<String> arguments) {
  ConsoleLogger.initialize();

  // Display the CLI banner
  

  CliRunner().run(arguments);
}
