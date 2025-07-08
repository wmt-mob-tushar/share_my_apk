import 'package:share_my_apk/src/services/upload/diawi_upload_service.dart';
import 'package:share_my_apk/src/services/upload/gofile_upload_service.dart';
import 'package:share_my_apk/src/services/upload/upload_service.dart';

/// A factory for creating [UploadService] instances.
class UploadServiceFactory {
  /// Creates a new [UploadService] instance based on the given [provider].
  static UploadService create(String provider, {String? token}) {
    switch (provider) {
      case 'gofile':
        return GofileUploadService(apiToken: token);
      case 'diawi':
      default:
        if (token == null) {
          throw ArgumentError('Diawi provider requires a token.');
        }
        return DiawiUploadService(token);
    }
  }
}
