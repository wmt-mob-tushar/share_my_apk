/// A library to build and upload Flutter APKs to various services.
///
/// This package provides a command-line tool and can also be used as a library.
library share_my_apk;

// Services
export 'src/services/apk_builder_service.dart';
export 'src/services/upload_service.dart';

// Models
export 'src/models/cli_options.dart';

// Utils
export 'src/utils/arg_parser_util.dart';
