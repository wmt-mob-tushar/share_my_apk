import 'package:share_my_apk/src/services/gofile_upload_service.dart';
import 'package:share_my_apk/src/services/upload_service.dart';

class UploadServiceFactory {
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
