import 'package:logging/logging.dart';

class HelpUtil {
  static final Logger _logger = Logger('HelpUtil');

  static void printHelp(String usage) {
    _logger.info('''
NAME
      share_my_apk - Your friendly neighborhood APK sharer.

SYNOPSIS
      share_my_apk [options]

DESCRIPTION
      Why bother with the drag-and-drop dance when you can just use this tool?
      It builds and shares your Flutter APKs, giving you more time to ponder the important questions in life, like "why is it called a build when it's already built?".

OPTIONS
$usage

CONFIGURATION
      Set it and forget it! Use a share_my_apk.yaml file in your project's root.
      To get started, just run:
            share_my_apk --init

JOKE OF THE DAY
      Why do programmers prefer dark mode? 
      Because light attracts bugs!
''');
  }
}
