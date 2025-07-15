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

      test('validates build method signature', () async {
        // Test that the build method exists and has correct signature
        expect(buildService.build, isNotNull);

        // Test default parameters
        await expectLater(buildService.build(), completes);

        // Test with all parameters
        await expectLater(
          buildService.build(
            release: true,
            projectPath: '/test/path',
            customName: 'test-app',
            environment: 'staging',
            outputDir: '/output',
          ),
          completes,
        );
      });

      test('handles different build configurations', () async {
        // Test release build
        await expectLater(buildService.build(release: true), completes);

        // Test debug build
        await expectLater(buildService.build(release: false), completes);

        // Test with custom project path
        await expectLater(
          buildService.build(projectPath: '/custom/path'),
          completes,
        );

        // Test with custom name
        await expectLater(
          buildService.build(customName: 'custom-app'),
          completes,
        );

        // Test with environment
        await expectLater(
          buildService.build(environment: 'production'),
          completes,
        );

        // Test with output directory
        await expectLater(
          buildService.build(outputDir: '/custom/output'),
          completes,
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

      test('validates organize method signature', () async {
        // Test that the organize method exists and has correct signature
        expect(organizerService.organize, isNotNull);

        // Test method signature
        await expectLater(
          organizerService.organize(
            '/source/path/app.apk',
            '/project/path',
            'custom-name',
            'staging',
            '/output/dir',
          ),
          completes,
        );
      });

      test('handles different organization scenarios', () async {
        const originalPath = '/source/path/app.apk';

        // Test with all parameters
        await expectLater(
          organizerService.organize(
            originalPath,
            '/project/path',
            'custom-name',
            'staging',
            '/output/dir',
          ),
          completes,
        );

        // Test with minimal parameters
        await expectLater(
          organizerService.organize(originalPath, null, null, null, null),
          completes,
        );

        // Test with custom name only
        await expectLater(
          organizerService.organize(
            originalPath,
            null,
            'custom-app',
            null,
            null,
          ),
          completes,
        );

        // Test with environment only
        await expectLater(
          organizerService.organize(
            originalPath,
            null,
            null,
            'production',
            null,
          ),
          completes,
        );

        // Test with output directory only
        await expectLater(
          organizerService.organize(
            originalPath,
            null,
            null,
            null,
            '/custom/output',
          ),
          completes,
        );
      });

      test('handles special characters in parameters', () async {
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
          await expectLater(
            organizerService.organize(
              originalPath,
              '/project/path',
              testCase['customName'],
              testCase['environment'],
              testCase['outputDir'],
            ),
            completes,
          );
        }
      });

      test('handles empty and null parameters', () async {
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
          await expectLater(
            organizerService.organize(
              originalPath,
              testCase[0],
              testCase[1],
              testCase[2],
              testCase[3],
            ),
            completes,
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

      test('services handle workflow scenarios', () async {
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
        await expectLater(
          organizerService.organize(
            apkPath!,
            '/test/project',
            'test-app',
            'staging',
            '/output/dir',
          ),
          completes,
        );

        // Step 3: Build service orchestrates everything
        await expectLater(
          buildService.build(
            release: true,
            projectPath: '/test/project',
            customName: 'test-app',
            environment: 'staging',
            outputDir: '/output/dir',
          ),
          completes,
        );
      });
    });
  });
}
