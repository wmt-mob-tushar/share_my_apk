import 'package:share_my_apk/src/utils/cli_runner.dart';
import 'package:share_my_apk/src/utils/console_logger.dart';

import 'dart:io';

void main(List<String> arguments) {
  ConsoleLogger.initialize();

  // Display the CLI banner
  stdout.writeln(
    '${cyan}' +
        r'''
  _______ _                            _       _   _
 |__   __| |                          | |     | | (_)
    | |  | |__   __ _ _ __ _ __ __ _  | | __ _| |_ _  ___  __ _
    | |  | '_ \ / _` | '__| '__/ _` | | |/ _` | __| |/ _ \/ _` |
    | |  | | | | (_| | |  | | | (_| | | | (_| | |_| |  __/ (_| |
    |_|  |_| |_|","__|_|  |_|  \",",__|_| |_|\",",__|_|\__|_|\___|\",",__ |
                                                            __/ |
                                                           |___/
''' +
        '${reset}\n',
  );

  CliRunner().run(arguments);
}
