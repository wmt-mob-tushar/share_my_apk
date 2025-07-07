import 'dart:io';
import 'package:share_my_apk/share_my_apk.dart';
import 'package:snug_logger/snug_logger.dart';

void main() async {
  // 1. Initialize the services
  final apkBuilder = ApkBuilderService();

  try {
    // 2. Build the APK
    // You can specify the project path and build mode (release or debug)
    final apkPath = await apkBuilder.build(
      release: true,
      projectPath: '.', // Use '.' for the current directory
    );

    snugLog('APK built successfully: $apkPath', logType: LogType.info);

    // 3. Check the file size
    final apkFile = File(apkPath);
    final fileSize = await apkFile.length();
    final fileSizeMb = (fileSize / (1024 * 1024)).toStringAsFixed(2);

    snugLog('APK size: $fileSizeMb MB', logType: LogType.info);

    // 4. Choose the upload provider
    var provider = 'diawi'; // Or 'gofile'
    if (provider == 'diawi' && fileSize > 70 * 1024 * 1024) {
      snugLog(
        'APK size is >70MB, switching to gofile.io for upload.',
        logType: LogType.warning,
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

    snugLog('Upload successful!', logType: LogType.success);
    snugLog('Download Link: $downloadLink', logType: LogType.info);
  } on ProcessException catch (e) {
    snugLog('Failed to build APK: ${e.message}', logType: LogType.error);
  } catch (e) {
    snugLog('An error occurred: $e', logType: LogType.error);
  }
}