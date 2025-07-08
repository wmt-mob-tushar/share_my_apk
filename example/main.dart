import 'package:share_my_apk/share_my_apk.dart';
import 'package:logging/logging.dart';

void main() async {
  // Configure logging to see detailed output from the tool.
  _setupLogging();

  final logger = Logger('main');

  try {
    // 1. Initialize the Flutter build service.
    final apkBuilder = FlutterBuildService();

    // 2. Build the APK.
    // This assumes you are running the command from the root of a Flutter project.
    final apkPath = await apkBuilder.build(
      release: true,
      customName: 'MyAwesomeApp',
      environment: 'production',
    );

    logger.info('✅ APK built successfully: $apkPath');

    // 3. Upload the APK to a service (e.g., Gofile.io).
    final uploader = UploadServiceFactory.create('gofile');
    final downloadLink = await uploader.upload(apkPath);

    logger.info('🚀 Upload successful!');
    logger.info('🔗 Download Link: $downloadLink');
  } catch (e) {
    logger.severe('❌ An error occurred: $e');
  }
}

/// Configures logging to display all messages with timestamps.
void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    final logger = Logger('main');
    final timestamp = record.time.toIso8601String().substring(0, 19);
    logger.info('[$timestamp] ${record.level.name}: ${record.message}');
  });
}
