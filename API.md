# API Documentation - Share My APK

## Overview

Share My APK provides both a CLI interface and a comprehensive Dart library for building and uploading Flutter Android APKs. This document covers the public API and integration patterns.

## Library API

### Core Services

#### FlutterBuildService

Orchestrates the APK building process.

```dart
import 'package:share_my_apk/share_my_apk.dart';

final buildService = FlutterBuildService();

// Build APK with all options
final apkPath = await buildService.build(
  release: true,              // Build mode (default: true)
  projectPath: '.',           // Flutter project path (default: '.')
  customName: 'MyApp_Beta',   // Custom APK name (optional)
  environment: 'staging',     // Environment folder (optional)
  outputDir: 'build/apks',    // Output directory (optional)
);
```

#### Upload Services

##### UploadServiceFactory

Factory for creating upload service instances.

```dart
import 'package:share_my_apk/share_my_apk.dart';

// Create Gofile service (no token required)
final gofileService = UploadServiceFactory.create('gofile');

// Create Gofile service with token (optional)
final gofileWithToken = UploadServiceFactory.create('gofile', token: 'your-token');

// Create Diawi service (token required)
final diawiService = UploadServiceFactory.create('diawi', token: 'your-diawi-token');
```

##### Upload Methods

```dart
// Upload APK and get download link
final downloadLink = await uploadService.upload('/path/to/your/app.apk');
print('Download link: $downloadLink');
```

##### GofileUploadService

Direct instantiation:

```dart
import 'package:share_my_apk/share_my_apk.dart';

final gofileService = GofileUploadService(apiToken: 'optional-token');
final downloadLink = await gofileService.upload('/path/to/app.apk');
```

**Features:**
- No token required for basic uploads
- Supports large files (tested with 113MB+ APKs)
- Automatic server selection
- Returns shareable download links

##### DiawiUploadService

Direct instantiation:

```dart
import 'package:share_my_apk/share_my_apk.dart';

final diawiService = DiawiUploadService('your-diawi-token');
final downloadLink = await diawiService.upload('/path/to/app.apk');
```

**Features:**
- Requires API token
- 70MB file size limit
- Asynchronous job processing with polling
- Automatic timeout handling (30 attempts, 5-second intervals)

### Build Helper Services

#### ApkParserService

Parses Flutter build output to extract APK paths.

```dart
import 'package:share_my_apk/share_my_apk.dart';

final parser = ApkParserService();
final apkPath = parser.getApkPath(buildOutput, projectPath);
```

#### ApkOrganizerService

Organizes and renames APK files.

```dart
import 'package:share_my_apk/share_my_apk.dart';

final organizer = ApkOrganizerService();
final finalPath = await organizer.organize(
  originalApkPath,
  projectPath,
  customName,
  environment,
  outputDir,
);
```

### Configuration

#### CliOptions Model

Immutable configuration model for CLI options.

```dart
import 'package:share_my_apk/share_my_apk.dart';

final options = CliOptions(
  token: 'legacy-token',           // Legacy token support
  diawiToken: 'diawi-token',       // Diawi-specific token
  gofileToken: 'gofile-token',     // Gofile-specific token
  path: '/project/path',           // Project path
  isRelease: true,                 // Release mode flag
  provider: 'diawi',               // Upload provider
  customName: 'MyApp',             // Custom APK name
  environment: 'prod',             // Environment folder
  outputDir: '/output/dir',        // Output directory
);

// Create updated copy
final updatedOptions = options.copyWith(
  provider: 'gofile',
  isRelease: false,
);
```

#### Configuration Service

Reads configuration from YAML files.

```dart
import 'package:share_my_apk/share_my_apk.dart';

final config = ConfigService.getConfig();
```

## Complete Example

```dart
import 'package:share_my_apk/share_my_apk.dart';
import 'package:logging/logging.dart';

void main() async {
  // Setup logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  try {
    // 1. Build APK
    final buildService = FlutterBuildService();
    final apkPath = await buildService.build(
      release: true,
      projectPath: '.',
      customName: 'MyApp_Beta',
      environment: 'staging',
      outputDir: 'build/releases',
    );
    
    print('✅ APK built successfully: $apkPath');

    // 2. Upload to cloud service
    final uploader = UploadServiceFactory.create('gofile');
    final downloadLink = await uploader.upload(apkPath);
    
    print('🚀 Upload successful!');
    print('Download link: $downloadLink');

  } catch (e) {
    print('❌ Error: $e');
  }
}
```

## Provider-Specific Details

### Gofile.io Integration

**API Endpoints:**
- Server list: `https://api.gofile.io/servers`
- Upload: `https://{server}.gofile.io/contents/uploadfile`

**Features:**
- No authentication required for basic uploads
- Large file support (no practical size limit)
- Automatic server selection
- Fast uploads

**Response Format:**
```json
{
  "status": "ok",
  "data": {
    "downloadPage": "https://gofile.io/d/ABC123"
  }
}
```

### Diawi Integration

**API Endpoints:**
- Upload: `https://upload.diawi.com/`
- Status: `https://upload.diawi.com/status?token={token}&job={job}`

**Features:**
- Requires API token
- 70MB file size limit
- Asynchronous processing
- Installation page with device management

**Upload Response:**
```json
{
  "job": "job_id_here"
}
```

**Status Response:**
```json
{
  "status": 2,
  "hash": "abc123def456"
}
```

## Error Handling

### Common Exceptions

```dart
try {
  final result = await uploadService.upload(apkPath);
} catch (e) {
  if (e.toString().contains('File not found')) {
    print('APK file does not exist');
  } else if (e.toString().contains('token')) {
    print('Invalid or missing API token');
  } else if (e.toString().contains('timeout')) {
    print('Upload timed out');
  } else {
    print('Unexpected error: $e');
  }
}
```

### Validation

- **File Existence**: All services validate file existence before upload
- **Token Validation**: Diawi service validates token presence
- **Provider Validation**: Factory validates provider names
- **Size Limits**: Automatic handling of Diawi's 70MB limit

## Best Practices

### 1. Error Handling

Always wrap upload operations in try-catch blocks:

```dart
try {
  final link = await uploadService.upload(apkPath);
  // Handle success
} catch (e) {
  // Handle error
  logger.severe('Upload failed: $e');
}
```

### 2. Logging

Use the logging package for better debugging:

```dart
import 'package:logging/logging.dart';

final logger = Logger('MyApp');
logger.info('Starting upload...');
```

### 3. Provider Selection

Use the factory pattern for flexible provider selection:

```dart
final provider = userPreference; // 'diawi' or 'gofile'
final service = UploadServiceFactory.create(provider, token: apiToken);
```

### 4. Large File Handling

For files that might exceed Diawi's 70MB limit:

```dart
// Check file size
final file = File(apkPath);
final sizeInMB = await file.length() / (1024 * 1024);

final provider = sizeInMB > 70 ? 'gofile' : 'diawi';
final service = UploadServiceFactory.create(provider, token: diawiToken);
```

## Testing

The library includes comprehensive test coverage:

- Unit tests for all services
- Integration tests for workflows
- Error handling tests
- Edge case coverage

Run tests:
```bash
dart test
```

See [TESTING.md](TESTING.md) for detailed testing information.

## Version Information

- **Current Version**: 0.4.0-beta
- **Stability**: Beta (ready for production testing)
- **API Stability**: Stable (no breaking changes planned)
- **Testing**: Comprehensive test suite with 100+ tests

## Support

- **Documentation**: [README.md](README.md)
- **Testing Info**: [TESTING.md](TESTING.md)
- **Issues**: [GitHub Issues](https://github.com/wm-jenildgohel/share_my_apk/issues)
- **Changelog**: [CHANGELOG.md](CHANGELOG.md)