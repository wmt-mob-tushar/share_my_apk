import 'package:logging/logging.dart';

class HelpUtil {
  static final Logger _logger = Logger('HelpUtil');

  static void printHelp(String usage) {
    _logger.info('''
\x1B[1mNAME\x1B[0m
      \x1B[1mshare_my_apk\x1B[0m - Your friendly neighborhood APK sharer.

\x1B[1mSYNOPSIS\x1B[0m
      \x1B[1mshare_my_apk\x1B[0m [\x1B[4moptions\x1B[0m]

\x1B[1mDESCRIPTION\x1B[0m
      Why bother with the drag-and-drop dance when you can just use this tool?
      It builds and shares your Flutter APKs, giving you more time to ponder the important questions in life, like "why is it called a build when it's already built?".

\x1B[1mOPTIONS\x1B[0m
$usage

\x1B[1mCONFIGURATION\x1B[0m
      Set it and forget it! Use a \x1B[1m`share_my_apk.yaml`\x1B[0m file in your project's root.
      To get started, just run:
            \x1B[1mshare_my_apk --init\x1B[0m

\x1B[1mJOKE OF THE DAY\x1B[0m
      Why do programmers prefer dark mode? 
      Because light attracts bugs!
''');
  }
}