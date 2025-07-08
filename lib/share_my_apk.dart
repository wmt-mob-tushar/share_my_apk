/// A powerful command-line tool and library for building and uploading Flutter APKs
/// to various services like Diawi and Gofile.io.
///
/// This library provides a comprehensive solution for Flutter developers who need
/// to automate the build and distribution process of their Android applications.
///
/// ## Key Features
///
/// - **Build & Upload**: Seamlessly build Flutter APKs and upload to multiple providers
/// - **Multiple Providers**: Supports Diawi and Gofile.io with automatic switching
/// - **Custom File Naming**: Generate APK files with custom names and timestamps
/// - **Directory Organization**: Organize builds by environment and custom directories
/// - **Professional Logging**: Structured logging using the standard `logging` package
///
/// ## Quick Start
///
/// ```dart
/// import 'package:share_my_apk/share_my_apk.dart';
/// import 'package:logging/logging.dart';
///
/// void main() async {
///   // Configure logging
///   Logger.root.level = Level.ALL;
///   Logger.root.onRecord.listen((record) {
///     print('${record.level.name}: ${record.message}');
///   });
///
///   // Build APK
///   final apkBuilder = ApkBuilderService();
///   final apkPath = await apkBuilder.build(
///     release: true,
///     customName: 'MyApp_Beta',
///     environment: 'staging',
///   );
///
///   // Upload to provider
///   final uploader = UploadServiceFactory.create('gofile');
///   final downloadLink = await uploader.upload(apkPath);
///   print('Download link: $downloadLink');
/// }
/// ```
///
/// **Developed by the Mobile Department at [Webmob Technologies](https://www.webmobtech.com/)**
library share_my_apk;

// Core Services
export 'src/services/apk_builder_service.dart';
export 'src/services/upload_service.dart';
export 'src/services/upload_service_factory.dart';

// Upload Provider Implementations
export 'src/services/gofile_upload_service.dart';

// Configuration and Models
export 'src/models/cli_options.dart';
export 'src/services/config_service.dart';

// Utilities
export 'src/utils/arg_parser_util.dart';
