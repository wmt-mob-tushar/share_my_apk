import 'package:share_my_apk/share_my_apk.dart';
import 'package:test/test.dart';

void main() {
  group('UploadServiceFactory', () {
    test('creates DiawiUploadService with token', () {
      final service = UploadServiceFactory.create('diawi', token: 'test-token');
      expect(service, isA<DiawiUploadService>());
    });

    test('creates GofileUploadService', () {
      final service = UploadServiceFactory.create('gofile');
      expect(service, isA<GofileUploadService>());
    });

    test('throws for diawi without token', () {
      expect(() => UploadServiceFactory.create('diawi'), throwsArgumentError);
    });

    test('throws for unknown provider', () {
      expect(() => UploadServiceFactory.create('unknown'), throwsArgumentError);
    });
  });
}
