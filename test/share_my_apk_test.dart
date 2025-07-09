import 'package:share_my_apk/share_my_apk.dart';
import 'package:test/test.dart';

// Import all test files
import 'services/upload/gofile_upload_service_test.dart' as gofile_tests;
import 'services/upload/diawi_upload_service_test.dart' as diawi_tests;
import 'services/upload/upload_service_factory_test.dart' as factory_tests;
import 'services/build_test.dart' as build_tests;
import 'utils/cli_test.dart' as cli_tests;
import 'error_handling_test.dart' as error_tests;

void main() {
  // Original factory tests
  group('UploadServiceFactory (Original)', () {
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

  // Run all comprehensive tests
  group('Comprehensive Test Suite', () {
    group('Gofile Upload Service Tests', () {
      gofile_tests.main();
    });

    group('Diawi Upload Service Tests', () {
      diawi_tests.main();
    });

    group('Upload Service Factory Tests', () {
      factory_tests.main();
    });

    group('Build Services Tests', () {
      build_tests.main();
    });

    group('CLI Tests', () {
      cli_tests.main();
    });

    group('Error Handling Tests', () {
      error_tests.main();
    });
  });
}
