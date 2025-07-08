# Share My APK Examples

This directory contains comprehensive examples demonstrating how to use the `share_my_apk` package effectively.

## 📁 Files Overview

### `main.dart`
Basic example showing the core workflow of building and uploading an APK file. Perfect for getting started quickly.

### `comprehensive_example.dart`
Detailed examples covering all major features:
- Basic APK building
- Custom file naming
- Environment organization
- Complete build & upload workflow
- Error handling patterns
- CLI options usage
- Advanced configuration

## 🚀 Running the Examples

### Prerequisites
1. Ensure you have Flutter installed and configured
2. Make sure you're in a valid Flutter project directory
3. Add the package to your dependencies

### Basic Example
```bash
dart run example/main.dart
```

### Comprehensive Examples
```bash
dart run example/comprehensive_example.dart
```

## 📝 Example Scenarios

### 1. Development Workflow
```dart
// Build debug APK for development testing
final apkBuilder = ApkBuilderService();
final apkPath = await apkBuilder.build(
  release: false,
  customName: 'DevBuild',
  environment: 'dev',
);
```

### 2. Staging Deployment
```dart
// Build release APK for staging environment
final apkPath = await apkBuilder.build(
  release: true,
  customName: 'StagingRelease',
  environment: 'staging',
  outputDir: '/builds/staging',
);

// Upload to Gofile.io for easy sharing
final uploader = UploadServiceFactory.create('gofile');
final downloadUrl = await uploader.upload(apkPath);
```

### 3. Production Release
```dart
// Build production APK with custom naming
final apkPath = await apkBuilder.build(
  release: true,
  customName: 'ProductionRelease_v1.2.3',
  environment: 'production',
  outputDir: '/builds/production',
);

// Upload to Diawi with authentication
final uploader = UploadServiceFactory.create('diawi', token: 'your_token');
final downloadUrl = await uploader.upload(apkPath);
```

## 🔧 Configuration Examples

### Environment-Based Configuration
```dart
final environments = {
  'dev': CliOptions(
    isRelease: false,
    customName: 'DevBuild',
    environment: 'dev',
    provider: 'gofile',
  ),
  'prod': CliOptions(
    token: 'diawi_token',
    isRelease: true,
    customName: 'ProdRelease',
    environment: 'production',
    provider: 'diawi',
  ),
};
```

### Multi-Variant Builds
```dart
final variants = [
  {'name': 'DevBuild', 'env': 'dev', 'debug': true},
  {'name': 'StagingBuild', 'env': 'staging', 'debug': false},
  {'name': 'ProdBuild', 'env': 'production', 'debug': false},
];

for (final variant in variants) {
  final apkPath = await apkBuilder.build(
    release: !(variant['debug'] as bool),
    customName: variant['name'] as String,
    environment: variant['env'] as String,
  );
}
```

## 📊 Generated File Structure

When using environment organization, your builds will be organized like:

```
project/
├── build/
│   └── apk/
│       ├── dev/
│       │   └── DevBuild_1.0.0_2024_01_15_14_30_45.apk
│       ├── staging/
│       │   └── StagingBuild_1.0.0_2024_01_15_14_30_45.apk
│       └── production/
│           └── ProdBuild_1.0.0_2024_01_15_14_30_45.apk
```

## ⚠️  Error Handling

The examples demonstrate proper error handling patterns:

```dart
try {
  final apkPath = await apkBuilder.build();
  final downloadUrl = await uploader.upload(apkPath);
  print('Success: $downloadUrl');
} on ProcessException catch (e) {
  print('Build failed: ${e.message}');
} on FileSystemException catch (e) {
  print('File operation failed: ${e.message}');
} catch (e) {
  print('Unexpected error: $e');
}
```

## 🔍 Logging

Enable detailed logging to troubleshoot issues:

```dart
Logger.root.level = Level.ALL;
Logger.root.onRecord.listen((record) {
  print('${record.level.name}: ${record.message}');
});
```

## 📚 Additional Resources

- [Package Documentation](../README.md)
- [API Reference](../lib/share_my_apk.dart)
- [Diawi API Documentation](https://dashboard.diawi.com/docs/apis/upload)
- [Gofile.io API Documentation](https://gofile.io/api)

---

**Developed by the Mobile Department at [Webmob Technologies](https://www.webmobtech.com/)**