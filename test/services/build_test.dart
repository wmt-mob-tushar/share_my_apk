import 'package:share_my_apk/src/services/build/flutter_build_service.dart';
import 'package:share_my_apk/src/services/build/apk_parser_service.dart';
import 'package:share_my_apk/src/services/build/apk_organizer_service.dart';
import 'package:test/test.dart';

void main() {
  group('Build and Organize Services', () {
    group('FlutterBuildService', () {
      late FlutterBuildService buildService;

      setUp(() {
        buildService = FlutterBuildService();
      });

      test('creates service instance', () {
        expect(buildService, isNotNull);
        expect(buildService, isA<FlutterBuildService>());
      });

      test('validates build method signature', () {
        // Test that the build method exists and has correct signature
        expect(buildService.build, isNotNull);

        // Test default parameters
        expect(() => buildService.build(), isA<Future<String>>());

        // Test with all parameters
        expect(
          () => buildService.build(
            release: true,
            projectPath: '/test/path',
            customName: 'test-app',
            environment: 'staging',
            outputDir: '/output',
          ),
          isA<Future<String>>(),
        );
      });

      test('handles different build configurations', () {
        // Test release build
        expect(() => buildService.build(release: true), isA<Future<String>>());

        // Test debug build
        expect(() => buildService.build(release: false), isA<Future<String>>());

        // Test with custom project path
        expect(
          () => buildService.build(projectPath: '/custom/path'),
          isA<Future<String>>(),
        );

        // Test with custom name
        expect(
          () => buildService.build(customName: 'custom-app'),
          isA<Future<String>>(),
        );

        // Test with environment
        expect(
          () => buildService.build(environment: 'production'),
          isA<Future<String>>(),
        );

        // Test with output directory
        expect(
          () => buildService.build(outputDir: '/custom/output'),
          isA<Future<String>>(),
        );
      });
    });

    group('ApkParserService', () {
      late ApkParserService parserService;

      setUp(() {
        parserService = ApkParserService();
      });

      test('creates service instance', () {
        expect(parserService, isNotNull);
        expect(parserService, isA<ApkParserService>());
      });

      test('parses valid build output', () {
        const buildOutput = '''
Running Gradle task 'assembleRelease'...
✓ Built build/app/outputs/flutter-apk/app-release.apk (113.4MB)
''';

        final result = parserService.getApkPath(buildOutput, '/test/project');
        expect(result, isNotNull);
        expect(result, contains('app-release.apk'));
      });

      test('parses build output with different APK names', () {
        const buildOutputs = [
          '✓ Built build/app/outputs/flutter-apk/app-release.apk (50.0MB)',
          '✓ Built build/app/outputs/flutter-apk/app-debug.apk (75.5MB)',
          '✓ Built build/app/outputs/flutter-apk/custom-app-release.apk (100.2MB)',
        ];

        for (final output in buildOutputs) {
          final result = parserService.getApkPath(output, '/test/project');
          expect(result, isNotNull);
          expect(result, contains('.apk'));
        }
      });

      test('handles malformed build output', () {
        const malformedOutputs = [
          '',
          'No APK found',
          'Build failed',
          'Random text without APK path',
          '✓ Built some/other/path/file.txt (10MB)',
        ];

        for (final output in malformedOutputs) {
          final result = parserService.getApkPath(output, '/test/project');
          expect(result, isNull);
        }
      });

      test('handles different project paths', () {
        const buildOutput =
            '✓ Built build/app/outputs/flutter-apk/app-release.apk (113.4MB)';

        final paths = [
          '/test/project',
          '/another/path',
          '.',
          '/complex/path/with/spaces',
          null,
        ];

        for (final path in paths) {
          final result = parserService.getApkPath(buildOutput, path);
          expect(result, isNotNull);
          expect(result, contains('app-release.apk'));
        }
      });

      test('handles build output with multiple APK references', () {
        const buildOutput = '''
Running Gradle task 'assembleRelease'...
Found old APK: build/app/outputs/flutter-apk/app-debug.apk
✓ Built build/app/outputs/flutter-apk/app-release.apk (113.4MB)
Also found: build/app/outputs/flutter-apk/app-profile.apk
''';

        final result = parserService.getApkPath(buildOutput, '/test/project');
        expect(result, isNotNull);
        expect(result, contains('app-release.apk'));
      });
    });

    group('ApkOrganizerService', () {
      late ApkOrganizerService organizerService;

      setUp(() {
        organizerService = ApkOrganizerService();
      });

      test('creates service instance', () {
        expect(organizerService, isNotNull);
        expect(organizerService, isA<ApkOrganizerService>());
      });

      test('validates organize method signature', () {
        // Test that the organize method exists and has correct signature
        expect(organizerService.organize, isNotNull);

        // Test method signature
        expect(
          () => organizerService.organize(
            '/source/path/app.apk',
            '/project/path',
            'custom-name',
            'staging',
            '/output/dir',
          ),
          isA<Future<String>>(),
        );
      });

      test('handles different organization scenarios', () {
        const originalPath = '/source/path/app.apk';

        // Test with all parameters
        expect(
          () => organizerService.organize(
            originalPath,
            '/project/path',
            'custom-name',
            'staging',
            '/output/dir',
          ),
          isA<Future<String>>(),
        );

        // Test with minimal parameters
        expect(
          () => organizerService.organize(originalPath, null, null, null, null),
          isA<Future<String>>(),
        );

        // Test with custom name only
        expect(
          () => organizerService.organize(
            originalPath,
            null,
            'custom-app',
            null,
            null,
          ),
          isA<Future<String>>(),
        );

        // Test with environment only
        expect(
          () => organizerService.organize(
            originalPath,
            null,
            null,
            'production',
            null,
          ),
          isA<Future<String>>(),
        );

        // Test with output directory only
        expect(
          () => organizerService.organize(
            originalPath,
            null,
            null,
            null,
            '/custom/output',
          ),
          isA<Future<String>>(),
        );
      });

      test('handles special characters in parameters', () {
        const originalPath = '/source/path/app.apk';

        final testCases = [
          {
            'customName': 'app-with-dashes',
            'environment': 'staging-env',
            'outputDir': '/output/with spaces',
          },
          {
            'customName': 'app_with_underscores',
            'environment': 'prod.env',
            'outputDir': '/output/with.dots',
          },
          {
            'customName': 'app123',
            'environment': 'dev',
            'outputDir': '/output/123',
          },
        ];

        for (final testCase in testCases) {
          expect(
            () => organizerService.organize(
              originalPath,
              '/project/path',
              testCase['customName'],
              testCase['environment'],
              testCase['outputDir'],
            ),
            isA<Future<String>>(),
          );
        }
      });

      test('handles empty and null parameters', () {
        const originalPath = '/source/path/app.apk';

        final testCases = [
          [null, null, null, null],
          ['', '', '', ''],
          ['/project', '', '', ''],
          ['/project', 'name', '', ''],
          ['/project', 'name', 'env', ''],
          ['/project', 'name', 'env', '/output'],
        ];

        for (final testCase in testCases) {
          expect(
            () => organizerService.organize(
              originalPath,
              testCase[0],
              testCase[1],
              testCase[2],
              testCase[3],
            ),
            isA<Future<String>>(),
          );
        }
      });
    });

    group('Build Services Integration', () {
      test('services can be used together', () {
        final buildService = FlutterBuildService();
        final parserService = ApkParserService();
        final organizerService = ApkOrganizerService();

        expect(buildService, isNotNull);
        expect(parserService, isNotNull);
        expect(organizerService, isNotNull);

        // Test that services can be instantiated together
        expect(buildService, isA<FlutterBuildService>());
        expect(parserService, isA<ApkParserService>());
        expect(organizerService, isA<ApkOrganizerService>());
      });

      test('services handle workflow scenarios', () {
        final buildService = FlutterBuildService();
        final parserService = ApkParserService();
        final organizerService = ApkOrganizerService();

        // Test a typical workflow scenario
        const mockBuildOutput =
            '✓ Built build/app/outputs/flutter-apk/app-release.apk (113.4MB)';

        // Step 1: Parse the build output
        final apkPath = parserService.getApkPath(
          mockBuildOutput,
          '/test/project',
        );
        expect(apkPath, isNotNull);
        expect(apkPath, contains('app-release.apk'));

        // Step 2: Organize the APK (would be called if file existed)
        expect(
          () => organizerService.organize(
            apkPath!,
            '/test/project',
            'test-app',
            'staging',
            '/output/dir',
          ),
          isA<Future<String>>(),
        );

        // Step 3: Build service orchestrates everything
        expect(
          () => buildService.build(
            release: true,
            projectPath: '/test/project',
            customName: 'test-app',
            environment: 'staging',
            outputDir: '/output/dir',
          ),
          isA<Future<String>>(),
        );
      });
    });
  });
}
