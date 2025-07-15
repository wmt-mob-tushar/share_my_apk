# 🚀 Share My APK - Usage Examples

This directory contains comprehensive examples demonstrating how to use the `share_my_apk` package programmatically in your Dart/Flutter projects.

## 📋 What's Included

### 📄 `main.dart` - Complete Usage Examples
A comprehensive example file showcasing:

- **Basic Build & Upload** - Simple APK build and upload workflow
- **Advanced Build Pipeline** - Complete configuration with all options
- **Configuration Management** - Working with YAML config files and CLI args
- **Multi-Provider Strategy** - Smart provider selection (Diawi/Gofile)
- **Error Handling** - Robust error handling patterns
- **Best Practices** - Production-ready implementation patterns

## 🚀 Running the Examples

### Prerequisites
- Dart SDK installed
- Flutter project (examples assume you're in a Flutter project root)
- Optional: API tokens for Diawi/Gofile

### Run All Examples
```bash
# From the share_my_apk package root
dart run example/main.dart
```

### Run Specific Example Sections
The main example file contains multiple demonstration functions that you can call individually by modifying the `main()` function.

## 🔧 Example Use Cases

### 1. **Basic Integration**
Perfect for getting started quickly:

```dart
import 'package:share_my_apk/share_my_apk.dart';

// Build and upload in one go
final buildService = FlutterBuildService();
final apkPath = await buildService.build(release: true);
final uploader = UploadServiceFactory.create('gofile');
final link = await uploader.upload(apkPath);
```

### 2. **Production Pipeline**
Enterprise-grade configuration:

```dart
final apkPath = await buildService.build(
  release: true,
  customName: 'MyApp_Production',
  environment: 'prod',
  clean: true,          // Clean build
  getPubDeps: true,     // Update dependencies
  generateL10n: true,   // Generate localizations
);
```

### 3. **CI/CD Integration**
Perfect for automated workflows:

```dart
// Configuration from environment/CI variables
final provider = Platform.environment['UPLOAD_PROVIDER'] ?? 'gofile';
final token = Platform.environment['UPLOAD_TOKEN'];
final uploader = UploadServiceFactory.create(provider, token: token);
```

### 4. **Custom File Organization**
Organize builds by environment and version:

```dart
await buildService.build(
  customName: 'MyApp_${version}',
  environment: 'staging',           // Creates staging/ folder
  outputDir: 'releases/${date}',    // Custom output location
);
```

## 🎯 Key Features Demonstrated

### ✅ **Build Pipeline**
- Flutter clean and dependency management
- Localization generation
- Release and debug builds
- Custom naming and organization

### ✅ **Upload Services**
- Gofile.io integration (no token required)
- Diawi integration (requires token)
- Smart provider switching
- Error handling and retries

### ✅ **Configuration**
- YAML configuration files
- CLI argument parsing
- Environment-based settings
- Default value handling

### ✅ **Error Handling**
- Network error recovery
- File validation
- Token verification
- Graceful degradation

## 🔧 Customization Tips

### Modify for Your Project
1. **Change APK Names**: Update `customName` parameters
2. **Set Environment**: Use `environment` for folder organization
3. **Choose Provider**: Select 'diawi' or 'gofile' based on needs
4. **Add Tokens**: Include API tokens for authenticated uploads

### Example Customizations
```dart
// For beta releases
await buildService.build(
  customName: 'MyApp_Beta',
  environment: 'beta',
  release: false,  // Debug build for testing
);

// For production releases
await buildService.build(
  customName: 'MyApp_${version}',
  environment: 'production',
  release: true,
  clean: true,
);
```

## 📚 Additional Resources

- **[API Documentation](https://pub.dev/documentation/share_my_apk/latest/)** - Complete API reference
- **[GitHub Repository](https://github.com/wm-jenildgohel/share_my_apk)** - Source code and issues
- **[Package Page](https://pub.dev/packages/share_my_apk)** - Installation and pub.dev info

## 💡 Pro Tips

1. **File Size Management**: Gofile has no size limits, Diawi has 70MB limit
2. **Token Security**: Store API tokens in environment variables, not in code
3. **Build Optimization**: Use `clean: false` for faster development builds
4. **Organization**: Use environment folders to separate builds by purpose
5. **Error Handling**: Always wrap upload operations in try-catch blocks

## 🆘 Troubleshooting

### Common Issues

**Build Fails**: Ensure you're in a Flutter project root
```bash
# Check if you're in a Flutter project
ls pubspec.yaml android/ ios/
```

**Upload Fails**: Check network connectivity and tokens
```dart
// Test with Gofile first (no token required)
final uploader = UploadServiceFactory.create('gofile');
```

**File Not Found**: Verify APK was built successfully
```dart
final apkFile = File(apkPath);
if (!await apkFile.exists()) {
  throw Exception('APK not found: $apkPath');
}
```

## 🚀 Ready to Integrate?

1. Add dependency to your `pubspec.yaml`
2. Copy relevant examples to your project
3. Customize for your build pipeline
4. Test with your Flutter project
5. Deploy to production! 🎉
