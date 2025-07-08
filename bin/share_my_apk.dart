import 'dart:io';

import 'package:share_my_apk/src/services/apk_builder_service.dart';
import 'package:share_my_apk/src/services/upload_service_factory.dart';
import 'package:share_my_apk/src/utils/arg_parser_util.dart';
import 'package:logging/logging.dart';

void main(List<String> arguments) async {
  final argParserUtil = ArgParserUtil();
  final Logger logger = Logger('main');

  try {
    final options = argParserUtil.parse(arguments);
    final apkBuilder = ApkBuilderService();

    final apkPath = await apkBuilder.build(
      release: options.isRelease,
      projectPath: options.path ?? '.',
      customName: options.customName,
      environment: options.environment,
      outputDir: options.outputDir,
    );

    final apkFile = File(apkPath);
    final fileSize = await apkFile.length();
    var provider = options.provider;

    if (provider == 'diawi' && fileSize > 70 * 1024 * 1024) {
      logger.severe(
        'APK size is greater than 70MB. Forcefully using gofile.io instead of diawi.',
      );
      provider = 'gofile';
    }

    final uploader = UploadServiceFactory.create(
      provider,
      token: options.token,
    );

    final downloadLink = await uploader.upload(apkPath);

    logger.info('APK successfully uploaded to $provider!');
    logger.info('Download link: $downloadLink');
  } on ArgumentError catch (e) {
    logger.severe(e.message);
    exit(1);
  } catch (e) {
    logger.severe('An unexpected error occurred: $e');
    exit(1);
  }
}
