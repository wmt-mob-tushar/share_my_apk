import 'dart:io';

import 'package:share_my_apk/src/services/apk_builder_service.dart';
import 'package:share_my_apk/src/services/upload_service_factory.dart';
import 'package:share_my_apk/src/utils/arg_parser_util.dart';
import 'package:snug_logger/snug_logger.dart';

void main(List<String> arguments) async {
  final argParserUtil = ArgParserUtil();

  try {
    final options = argParserUtil.parse(arguments);
    final apkBuilder = ApkBuilderService();

    final apkPath = await apkBuilder.build(
      release: options.isRelease,
      projectPath: options.path ?? '.',
    );

    final apkFile = File(apkPath);
    final fileSize = await apkFile.length();
    var provider = options.provider;

    if (provider == 'diawi' && fileSize > 70 * 1024 * 1024) {
      snugLog(
        'APK size is greater than 70MB. Forcefully using gofile.io instead of diawi.',
        logType: LogType.error,
      );
      provider = 'gofile';
    }

    final uploader = UploadServiceFactory.create(
      provider,
      token: options.token,
    );

    final downloadLink = await uploader.upload(apkPath);

    snugLog('APK successfully uploaded to $provider!', logType: LogType.info);
    snugLog('Download link: $downloadLink', logType: LogType.info);
  } on ArgumentError catch (e) {
    snugLog(e.message, logType: LogType.error);
    exit(1);
  } catch (e) {
    snugLog('An unexpected error occurred: $e', logType: LogType.error);
    exit(1);
  }
}
