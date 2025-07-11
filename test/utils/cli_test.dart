import 'package:share_my_apk/src/models/cli_options.dart';
import 'package:share_my_apk/src/utils/command_line/arg_parser_util.dart';
import 'package:test/test.dart';

void main() {
  group('CLI Argument Parsing and Configuration', () {
    late ArgParserUtil argParser;

    setUp(() {
      argParser = ArgParserUtil();
    });

    group('ArgParserUtil', () {
      test('parses basic arguments correctly', () {
        final args = [
          '--provider',
          'gofile',
          '--path',
          '.',
          '--name',
          'test-app',
        ];

        final options = argParser.parse(args);

        expect(options.provider, equals('gofile'));
        expect(options.path, equals('.'));
        expect(options.customName, equals('test-app'));
      });

      test('parses token arguments correctly', () {
        final args = [
          '--diawi-token',
          'diawi-test-token',
          '--gofile-token',
          'gofile-test-token',
        ];

        final options = argParser.parse(args);

        expect(options.diawiToken, equals('diawi-test-token'));
        expect(options.gofileToken, equals('gofile-test-token'));
      });

      test('parses boolean flags correctly', () {
        final releaseArgs = ['--release', '--diawi-token', 'test-token'];
        final noReleaseArgs = ['--no-release', '--diawi-token', 'test-token'];

        final releaseOptions = argParser.parse(releaseArgs);
        final noReleaseOptions = argParser.parse(noReleaseArgs);

        expect(releaseOptions.isRelease, isTrue);
        expect(noReleaseOptions.isRelease, isFalse);
      });

      test('handles short argument aliases', () {
        final args = [
          '-p',
          '.',
          '-n',
          'short-name',
          '-e',
          'dev',
          '-o',
          'build',
          '--diawi-token',
          'test-token',
        ];

        final options = argParser.parse(args);

        expect(options.path, equals('.'));
        expect(options.customName, equals('short-name'));
        expect(options.environment, equals('dev'));
        expect(options.outputDir, equals('build'));
      });

      test('handles help flag', () {
        final args = ['--help'];

        expect(() => argParser.parse(args), throwsA(isA<ArgumentError>()));
      });

      test('handles init flag', () {
        final args = ['--init'];

        expect(() => argParser.parse(args), throwsA(isA<ArgumentError>()));
      });

      test('handles empty arguments', () {
        final args = ['--gofile-token', 'test-token'];
        final options = argParser.parse(args);

        expect(options.provider, equals('diawi')); // Default provider
        expect(options.isRelease, isTrue); // Default release mode
        expect(options.path, equals('.')); // Default path
      });

      test('handles unknown arguments gracefully', () {
        final args = ['--unknown-arg', 'value', '--diawi-token', 'test-token'];

        expect(() => argParser.parse(args), throwsA(isA<ArgumentError>()));
      });
    });

    group('CliOptions', () {
      test('creates with all parameters', () {
        final options = CliOptions(
          token: 'legacy-token',
          diawiToken: 'diawi-token',
          gofileToken: 'gofile-token',
          path: '/test/path',
          isRelease: true,
          provider: 'diawi',
          customName: 'test-app',
          environment: 'staging',
          outputDir: '/output',
        );

        expect(options.token, equals('legacy-token'));
        expect(options.diawiToken, equals('diawi-token'));
        expect(options.gofileToken, equals('gofile-token'));
        expect(options.path, equals('/test/path'));
        expect(options.isRelease, isTrue);
        expect(options.provider, equals('diawi'));
        expect(options.customName, equals('test-app'));
        expect(options.environment, equals('staging'));
        expect(options.outputDir, equals('/output'));
      });

      test('creates with minimal parameters', () {
        final options = CliOptions(
          token: null,
          diawiToken: null,
          gofileToken: null,
          path: null,
          isRelease: false,
          provider: 'gofile',
          customName: null,
          environment: null,
          outputDir: null,
        );

        expect(options.token, isNull);
        expect(options.diawiToken, isNull);
        expect(options.gofileToken, isNull);
        expect(options.path, isNull);
        expect(options.isRelease, isFalse);
        expect(options.provider, equals('gofile'));
        expect(options.customName, isNull);
        expect(options.environment, isNull);
        expect(options.outputDir, isNull);
      });

      test('copyWith creates new instance with updated values', () {
        final original = CliOptions(
          token: 'original-token',
          diawiToken: 'original-diawi',
          gofileToken: 'original-gofile',
          path: '/original/path',
          isRelease: true,
          provider: 'diawi',
          customName: 'original-name',
          environment: 'prod',
          outputDir: '/original/output',
        );

        final updated = original.copyWith(
          token: 'new-token',
          provider: 'gofile',
          isRelease: false,
        );

        // Updated values
        expect(updated.token, equals('new-token'));
        expect(updated.provider, equals('gofile'));
        expect(updated.isRelease, isFalse);

        // Unchanged values
        expect(updated.diawiToken, equals('original-diawi'));
        expect(updated.gofileToken, equals('original-gofile'));
        expect(updated.path, equals('/original/path'));
        expect(updated.customName, equals('original-name'));
        expect(updated.environment, equals('prod'));
        expect(updated.outputDir, equals('/original/output'));
      });

      test('copyWith with null values preserves originals', () {
        final original = CliOptions(
          token: 'original-token',
          diawiToken: 'original-diawi',
          gofileToken: 'original-gofile',
          path: '/original/path',
          isRelease: true,
          provider: 'diawi',
          customName: 'original-name',
          environment: 'prod',
          outputDir: '/original/output',
        );

        final copy = original.copyWith();

        expect(copy.token, equals(original.token));
        expect(copy.diawiToken, equals(original.diawiToken));
        expect(copy.gofileToken, equals(original.gofileToken));
        expect(copy.path, equals(original.path));
        expect(copy.isRelease, equals(original.isRelease));
        expect(copy.provider, equals(original.provider));
        expect(copy.customName, equals(original.customName));
        expect(copy.environment, equals(original.environment));
        expect(copy.outputDir, equals(original.outputDir));
      });

      test('handles special characters in values', () {
        final options = CliOptions(
          token: 'token-with-special-chars_123!@#',
          diawiToken: 'diawi_token.with.dots',
          gofileToken: 'gofile-token/with/slashes',
          path: '/path/with spaces/and-dashes',
          isRelease: true,
          provider: 'diawi',
          customName: 'app-name_with_special.chars',
          environment: 'staging-env',
          outputDir: '/output/dir with spaces',
        );

        expect(options.token, equals('token-with-special-chars_123!@#'));
        expect(options.diawiToken, equals('diawi_token.with.dots'));
        expect(options.gofileToken, equals('gofile-token/with/slashes'));
        expect(options.path, equals('/path/with spaces/and-dashes'));
        expect(options.customName, equals('app-name_with_special.chars'));
        expect(options.environment, equals('staging-env'));
        expect(options.outputDir, equals('/output/dir with spaces'));
      });

      test('handles empty string values', () {
        final options = CliOptions(
          token: '',
          diawiToken: '',
          gofileToken: '',
          path: '',
          isRelease: false,
          provider: '',
          customName: '',
          environment: '',
          outputDir: '',
        );

        expect(options.token, equals(''));
        expect(options.diawiToken, equals(''));
        expect(options.gofileToken, equals(''));
        expect(options.path, equals(''));
        expect(options.provider, equals(''));
        expect(options.customName, equals(''));
        expect(options.environment, equals(''));
        expect(options.outputDir, equals(''));
      });
    });

    group('Configuration Integration', () {
      test('handles complex argument combinations', () {
        final args = [
          '--provider',
          'gofile',
          '--gofile-token',
          'gofile-token-123',
          '--path',
          '/complex/project/path',
          '--name',
          'complex-app-name',
          '--environment',
          'production',
          '--output-dir',
          '/custom/output/directory',
          '--no-release',
        ];

        final options = argParser.parse(args);

        expect(options.provider, equals('gofile'));
        expect(options.gofileToken, equals('gofile-token-123'));
        expect(options.path, equals('/complex/project/path'));
        expect(options.customName, equals('complex-app-name'));
        expect(options.environment, equals('production'));
        expect(options.outputDir, equals('/custom/output/directory'));
        expect(options.isRelease, isFalse);
      });

      test('handles argument precedence correctly', () {
        final args = [
          '--provider',
          'diawi',
          '--diawi-token',
          'diawi-token-456',
          '--gofile-token',
          'gofile-token-789',
          '--release',
          '--path',
          '/precedence/test/path',
        ];

        final options = argParser.parse(args);

        expect(options.provider, equals('diawi'));
        expect(options.diawiToken, equals('diawi-token-456'));
        expect(options.gofileToken, equals('gofile-token-789'));
        expect(options.isRelease, isTrue);
        expect(options.path, equals('/precedence/test/path'));
      });
    });
  });
}
