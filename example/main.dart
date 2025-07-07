import 'dart:io';
import 'package:share_my_apk/share_my_apk.dart';
import 'package:share_my_apk/src/services/upload_service_factory.dart';
import 'package:logging/logging.dart';

void main() async {
  final Logger logger = Logger('main');
  // 1. Initialize the services
  final apkBuilder = ApkBuilderService();

  try {
    // 2. Build the APK
    // You can specify the project path and build mode (release or debug)
    final apkPath = await apkBuilder.build(
      release: true,
      projectPath: '.', // Use '.' for the current directory
    );

    logger.info('APK built successfully: $apkPath');

    // 3. Check the file size
    final apkFile = File(apkPath);
    final fileSize = await apkFile.length();
    final fileSizeMb = (fileSize / (1024 * 1024)).toStringAsFixed(2);

    logger.info('APK size: $fileSizeMb MB');

    // 4. Choose the upload provider
    var provider = 'diawi'; // Or 'gofile'
    if (provider == 'diawi' && fileSize > 70 * 1024 * 1024) {
      logger.severe(
        'APK size is >70MB, switching to gofile.io for upload.',
      );
      provider = 'gofile';
    }

    // 5. Create the uploader and upload the APK
    // The token is only required for Diawi.
    final uploader = UploadServiceFactory.create(
      provider,
      token: 'YOUR_DIAWI_TOKEN', // Replace with your token if using Diawi
    );

    final downloadLink = await uploader.upload(apkPath);

    logger.info('Upload successful!');
    logger.info('Download Link: $downloadLink');
  } on ProcessException catch (e) {
    logger.severe('Failed to build APK: ${e.message}');
  } catch (e) {
    logger.severe('An error occurred: $e');
  }
}