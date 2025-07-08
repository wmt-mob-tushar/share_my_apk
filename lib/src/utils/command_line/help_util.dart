import 'package:logging/logging.dart';

class HelpUtil {
  static final Logger _logger = Logger('HelpUtil');

  static void printHelp(String usage) {
    _logger.info('''
\x1B[1mNAME\x1B[0m
      \x1B[1mshare_my_apk\x1B[0m - A powerful command-line tool to build and upload your Flutter APKs.

\x1B[1mSYNOPSIS\x1B[0m
      \x1B[1mshare_my_apk\x1B[0m [\x1B[4moptions\x1B[0m]

\x1B[1mDESCRIPTION\x1B[0m
      This tool simplifies the process of building and sharing your Flutter APKs by integrating with services like Diawi and Gofile.io.

\x1B[1mOPTIONS\x1B[0m
$usage

\x1B[1mCONFIGURATION\x1B[0m
      You can set default values for the options in a \x1B[1m`share_my_apk.yaml`\x1B[0m file in your project's root directory.
      To generate a configuration file, run:
            \x1B[1mshare_my_apk --init\x1B[0m
''');
  }
}
