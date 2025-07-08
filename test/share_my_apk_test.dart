import 'package:share_my_apk/share_my_apk.dart';
import 'package:test/test.dart';

void main() {
  group('Services', () {
    test('FlutterBuildService can be instantiated', () {
      expect(FlutterBuildService(), isA<FlutterBuildService>());
    });

    test('UploadServiceFactory creates GofileUploadService', () {
      final service = UploadServiceFactory.create('gofile');
      expect(service, isA<GofileUploadService>());
    });

    test('UploadServiceFactory creates DiawiUploadService', () {
      final service = UploadServiceFactory.create('diawi', token: 'fake_token');
      expect(service, isA<DiawiUploadService>());
    });

    test('UploadServiceFactory throws for Diawi without a token', () {
      expect(() => UploadServiceFactory.create('diawi'), throwsArgumentError);
    });
  });
}
