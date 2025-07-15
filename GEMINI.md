# GEMINI.md - Share My APK Project Knowledge Base

> **Last Updated:** 2025-07-15  
> **Version:** 1.0.0  
> **Status:** Production Ready - Stable Release

## Project Overview

**Share My APK** is a Flutter CLI tool and Dart library that automates building and uploading Android APK files to file sharing services. It eliminates the manual "build-and-drag-drop" workflow developers face when sharing APKs for testing.

### Key Features
- 🚀 One-command APK build and upload
- ☁️ Multiple upload providers (Diawi, Gofile.io) with **fixed API integration**
- 🔄 Intelligent provider switching based on file size (>70MB → Gofile)
- 🎨 Custom file naming and organization
- 📁 Environment-based directory structure
- ⚙️ Flexible configuration system
- 📦 Available as CLI tool and Dart library
- 🧪 **Comprehensive testing suite** with 100+ tests
- 🛡️ **Rock-solid reliability** with enhanced error handling
- ✅ **Production-ready** with thorough API validation

## Architecture Overview

```
share_my_apk/
├── bin/share_my_apk.dart           # CLI entry point
├── lib/
│   ├── share_my_apk.dart           # Library exports
│   └── src/
│       ├── models/
│       │   └── cli_options.dart     # Configuration model
│       ├── services/
│       │   ├── build/               # APK building services
│       │   │   ├── flutter_build_service.dart
│       │   │   ├── apk_parser_service.dart
│       │   │   └── apk_organizer_service.dart
│       │   ├── upload/              # Upload services
│       │   │   ├── upload_service.dart          # Interface
│       │   │   ├── diawi_upload_service.dart
│       │   │   ├── gofile_upload_service.dart
│       │   │   └── upload_service_factory.dart
│       │   └── config_service.dart  # Configuration management
│       └── utils/command_line/      # CLI utilities
│           ├── arg_parser_util.dart
│           ├── help_util.dart
│           └── init_util.dart
├── test/                           # Unit tests
├── example/                        # Usage examples
└── doc/api/                       # Generated API docs
```

## Core APIs and Services

### Build Services

#### FlutterBuildService
**Purpose:** Orchestrates APK building process

```dart
class FlutterBuildService {
  /// Builds APK and returns organized file path
  Future<String> build({
    bool release = true,        // Release/debug mode
    String? projectPath,        // Flutter project path
    String? customName,         // Custom APK name
    String? environment,        // Environment folder (dev/staging/prod)
    String? outputDir,         // Custom output directory
  });
}
```

#### ApkParserService
**Purpose:** Extracts APK path from Flutter build output

```dart
class ApkParserService {
  /// Parses build output to find APK location
  String? getApkPath(String buildOutput, String? projectPath);
}
```

#### ApkOrganizerService
**Purpose:** Handles file organization and naming

```dart
class ApkOrganizerService {
  /// Organizes APK with custom naming and directory structure
  Future<String> organize(
    String originalApkPath,
    String? projectPath,
    String? customName,
    String? environment,
    String? outputDir,
  );
}
```

### Upload Services

#### Upload Service Interface
```dart
abstract class UploadService {
  Future<String> upload(String filePath);
}
```

#### DiawiUploadService
**Purpose:** Uploads to Diawi (requires token, 70MB limit)

```dart
class DiawiUploadService implements UploadService {
  final String apiToken;
  
  DiawiUploadService(this.apiToken);
  
  @override
  Future<String> upload(String filePath);
}
```

#### GofileUploadService
**Purpose:** Uploads to Gofile.io (no token required, higher limits)

```dart
class GofileUploadService implements UploadService {
  final String? apiToken;  // Optional
  
  GofileUploadService({this.apiToken});
  
  @override
  Future<String> upload(String filePath);
}
```

#### UploadServiceFactory
**Purpose:** Creates upload service instances

```dart
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
```

### Configuration Services

#### ConfigService
**Purpose:** Manages configuration from YAML files

```dart
class ConfigService {
  /// Reads config from share_my_apk.yaml or pubspec.yaml
  static Map<String, dynamic> getConfig();
}
```

#### CliOptions Model
**Purpose:** Immutable configuration model

```dart
class CliOptions {
  final String? token;           // Legacy token support
  final String? diawiToken;      // Diawi-specific token
  final String? gofileToken;     // Gofile-specific token
  final String? path;            // Project path
  final bool isRelease;          // Release mode flag
  final String provider;         // Upload provider
  final String? customName;      // Custom APK name
  final String? environment;     // Environment folder
  final String? outputDir;       // Output directory
  
  // Includes copyWith() for immutable updates
}
```

## CLI Interface

### Available Commands and Options

| Option | Alias | Type | Default | Description |
|--------|-------|------|---------|-------------|
| `--help` | `-h` | Flag | - | Show help message |
| `--init` | - | Flag | - | Generate config file |
| `--diawi-token` | - | String | - | Diawi API token |
| `--gofile-token` | - | String | - | Gofile API token |
| `--path` | `-p` | String | `.` | Flutter project path |
| `--release` | - | Flag | `true` | Build in release mode |
| `--provider` | - | String | - | Upload provider (reads from config) |
| `--name` | `-n` | String | - | Custom APK name |
| `--environment` | `-e` | String | - | Environment folder |
| `--output-dir` | `-o` | String | - | Output directory |

### Usage Examples

```bash
# Initialize configuration
share_my_apk --init

# Basic usage (uses config file)
share_my_apk

# Specific provider with custom naming
share_my_apk --provider gofile --name MyApp_Beta --environment staging

# Debug build to custom location
share_my_apk --no-release --output-dir build/debug_apks

# Override config file settings
share_my_apk --diawi-token new_token --path /custom/project/path
```

## Configuration System

### Configuration Priority (Highest to Lowest)
1. **CLI Arguments** - Command line options
2. **share_my_apk.yaml** - Dedicated config file
3. **pubspec.yaml** - Legacy config location
4. **Defaults** - Built-in defaults

### share_my_apk.yaml Example
```yaml
# Provider settings
provider: diawi

# API tokens
diawi_token: your_diawi_token_here
gofile_token: your_gofile_token_here

# Build configuration
path: .
release: true

# File organization
name: MyApp_Production
environment: prod
output-dir: build/releases

# Additional settings can be added here
```

### pubspec.yaml Integration (Legacy Support)
```yaml
name: my_flutter_app
# ... other pubspec content ...

share_my_apk:
  provider: diawi
  diawi_token: your_token
  release: true
```

## Workflow Details

### Build Workflow
1. **Parse Arguments**: Merge CLI args with config files
2. **Execute Flutter Build**: Run `flutter build apk --release/--debug`
3. **Parse Build Output**: Extract APK path from Flutter output
4. **Organize File**: Copy/rename APK based on configuration
5. **Return Path**: Provide final APK location for upload

### Upload Workflow
1. **Check File Size**: Determine if file exceeds provider limits
2. **Smart Provider Switching**: Auto-switch Diawi→Gofile for files >70MB
3. **Create Service**: Use factory to instantiate upload service
4. **Upload File**: Execute provider-specific upload logic
5. **Return Download Link**: Provide shareable URL

### File Naming Convention
```
Pattern: {name}_{version}_{timestamp}.apk

Examples:
- MyApp_1.0.0_2025_07_15_12_30_45.apk
- staging_build_1.2.3_2025_07_15_14_15_30.apk
```

### Directory Organization
```
{outputDir}/
├── {environment}/                    # Optional environment folder
│   ├── MyApp_1.0.0_timestamp.apk   # Organized APK files
│   └── MyApp_1.0.1_timestamp.apk
└── other_env/
    └── MyApp_dev_timestamp.apk
```

## Intelligent Features

### Automatic Provider Switching
```dart
// In bin/share_my_apk.dart
if (provider == 'diawi' && fileSize > 70 * 1024 * 1024) {
  logger.warning(
    'APK size is greater than 70MB. Forcefully using gofile.io instead of diawi.',
  );
  provider = 'gofile';
  token = options.gofileToken;
}
```

### Error Handling Strategy
- **Build Failures**: Detect and report Flutter build errors
- **File Validation**: Verify APK existence before upload
- **Token Validation**: Ensure required tokens are provided
- **Network Errors**: Handle upload failures gracefully
- **Configuration Errors**: Validate config file syntax

### Logging System
```dart
// Structured logging throughout application
final Logger logger = Logger('ServiceName');

logger.info('APK successfully uploaded to $provider!');
logger.warning('APK size is greater than 70MB...');
logger.severe('An unexpected error occurred: $error');
```

## Production Release v1.0.0

### What's New in v1.0.0
- **✅ Production Ready**: Stable release with comprehensive testing
- **🐛 Configuration Fix**: Resolved YAML config priority issue for provider selection
- **📚 Complete Documentation**: Full API documentation and examples
- **🏆 Quality Assurance**: Zero analysis issues and 100+ tests passing
- **📦 Package Validation**: Optimized for maximum pub.dev scoring

### Critical Configuration Fix
**Issue**: Tool was ignoring `provider: gofile` in YAML configuration due to hardcoded `defaultsTo: 'diawi'` in CLI parser.

**Solution**: Removed hardcoded default to allow YAML configuration to take proper precedence:

```dart
// Before (bug):
_parser.addOption(
  _provider,
  help: 'The upload provider to use.',
  allowed: ['diawi', 'gofile'],
  defaultsTo: 'diawi',  // This overrode YAML config
);

// After (fixed):
_parser.addOption(
  _provider,
  help: 'The upload provider to use.\n[diawi, gofile] (reads from config file)',
  allowed: ['diawi', 'gofile'],
  // No defaultsTo - allows YAML config to work
);
```

### Configuration Priority Order
Now properly implemented as:
1. CLI arguments (highest priority)
2. share_my_apk.yaml configuration
3. pubspec.yaml configuration (legacy)
4. Built-in defaults (lowest priority)

## Dependencies and Their Roles

### Runtime Dependencies
- **`args: ^2.7.0`** - CLI argument parsing and validation
- **`http: ^1.4.0`** - HTTP client for upload API calls
- **`logging: ^1.3.0`** - Structured logging system
- **`path: ^1.9.1`** - Cross-platform path manipulation
- **`process_run: ^1.2.4`** - Execute Flutter build commands
- **`yaml: ^3.1.3`** - Configuration file parsing

### Development Dependencies
- **`lints: ^6.0.0`** - Dart code analysis and linting
- **`test: ^1.26.2`** - Unit testing framework

## Testing Strategy

### Test Coverage (v1.0.0)
- **Total Test Files**: 6
- **Individual Tests**: 100+
- **Categories**: Upload services, build services, CLI, error handling, integration
- **Coverage**: All major components and edge cases
- **Status**: All tests passing with comprehensive validation

### Test Execution
```bash
# Run all tests
dart test

# Run specific test categories
dart test test/services/upload/
dart test test/services/build_test.dart
dart test test/utils/cli_test.dart
dart test test/error_handling_test.dart

# Run with verbose output
dart test --reporter expanded

# Run with coverage
dart test --coverage=coverage
```

## Development Commands

### Local Development
```bash
# Setup project
dart pub get

# Code quality checks
dart analyze                    # Static analysis
dart format .                   # Code formatting
dart test                      # Run tests

# Documentation
dart doc                       # Generate API docs

# Local testing
dart run bin/share_my_apk.dart --help
dart run example/main.dart
```

### Package Development
```bash
# Activate locally for testing
dart pub global activate --source path .

# Validate package
dart pub publish --dry-run

# Publish to pub.dev
dart pub publish

# Check pub points
dart pub deps
```

## Library Usage Examples

### Basic Library Usage
```dart
import 'package:share_my_apk/share_my_apk.dart';

void main() async {
  // Build APK
  final buildService = FlutterBuildService();
  final apkPath = await buildService.build(
    release: true,
    customName: 'MyApp_Beta',
    environment: 'staging',
  );

  // Upload to provider
  final uploader = UploadServiceFactory.create('gofile');
  final downloadLink = await uploader.upload(apkPath);
  
  print('Download link: $downloadLink');
}
```

### Advanced Configuration
```dart
import 'package:share_my_apk/share_my_apk.dart';

void main() async {
  // Parse CLI arguments
  final argParser = ArgParserUtil();
  final options = argParser.parse([
    '--provider', 'diawi',
    '--diawi-token', 'your_token',
    '--name', 'MyApp_Production',
    '--environment', 'prod',
    '--output-dir', '/custom/output/path'
  ]);

  // Build with custom options
  final buildService = FlutterBuildService();
  final apkPath = await buildService.build(
    release: options.isRelease,
    projectPath: options.path,
    customName: options.customName,
    environment: options.environment,
    outputDir: options.outputDir,
  );

  // Upload with appropriate service
  final uploader = UploadServiceFactory.create(
    options.provider,
    token: options.diawiToken ?? options.gofileToken,
  );
  
  final downloadLink = await uploader.upload(apkPath);
  print('APK uploaded: $downloadLink');
}
```

## Package Information

### Publishing Details
- **Package Name**: `share_my_apk`
- **Current Version**: `1.0.0`
- **Repository**: https://github.com/wm-jenildgohel/share_my_apk
- **Pub.dev**: Production ready for publishing
- **License**: As specified in LICENSE file
- **Status**: Stable production release

### Supported Platforms
- **Primary**: Android (APK building and uploading)
- **CLI Support**: All platforms (Windows, macOS, Linux)
- **Flutter Version**: Compatible with current stable Flutter

### Version History
- **1.0.0**: **Production Ready Release**
  - Stable release with comprehensive testing and validation
  - Fixed configuration priority issue for provider selection
  - Complete documentation suite and API reference
  - Zero analysis issues and optimized for maximum pub.dev scoring
  - Production-ready with thorough testing and quality assurance
- **0.4.0-beta**: Major API fixes, comprehensive testing, production-ready
- **0.3.2**: Bug fixes, improved documentation, test coverage
- **0.3.0**: Major refactor, improved code organization
- **0.2.0-alpha**: Init command, provider-specific tokens
- **0.1.0-alpha**: Initial release with core functionality

## Troubleshooting Guide

### Common Issues

#### Configuration Priority Issues
If your YAML configuration is being ignored:

1. **Check Configuration Order**: Ensure you understand the priority:
   - CLI arguments override everything
   - share_my_apk.yaml overrides pubspec.yaml
   - pubspec.yaml overrides defaults

2. **Validate YAML Syntax**:
   ```bash
   # Generate a valid config file
   share_my_apk --init
   ```

3. **Debug Configuration Loading**:
   ```bash
   # Use CLI args to test
   share_my_apk --provider gofile --verbose
   ```

#### Build Failures
```bash
# Ensure Flutter is properly installed
flutter doctor

# Check project is valid Flutter app
flutter packages get
flutter build apk --debug  # Test manual build
```

#### Upload Failures
```bash
# Test network connectivity
curl -I https://upload.diawi.com/
curl -I https://store1.gofile.io/

# Verify token validity (Diawi)
curl -F "token=YOUR_TOKEN" -F "file=@test.apk" https://upload.diawi.com/
```

### Debug Mode
```bash
# Enable verbose logging
share_my_apk --verbose

# Test with debug build
share_my_apk --no-release
```

## Future Enhancement Ideas

### Potential Features
- **Additional Providers**: Firebase App Distribution, TestFlight
- **Webhook Integration**: Slack/Discord notifications
- **CI/CD Integration**: GitHub Actions, GitLab CI
- **Advanced Configuration**: JSON schema validation
- **Progress Indicators**: Upload progress bars
- **Batch Operations**: Multiple APK handling

### Architecture Improvements
- **Plugin System**: Extensible provider architecture
- **Caching**: Build cache optimization
- **Retry Logic**: Automatic retry for failed uploads
- **Async Operations**: Parallel upload support

---

## Maintenance Notes

This GEMINI.md file should be updated whenever:
- New features are added
- APIs change
- Dependencies are updated
- Configuration options change
- New providers are added
- Breaking changes occur

**Last maintained by**: Claude AI Assistant (Shared Context)  
**Next review**: When significant changes occur

---

*This knowledge base is designed to provide comprehensive understanding of the share_my_apk project for both Claude and Gemini AI assistants, ensuring consistent context and assistance quality.*