/// 🚀 **Share My APK - Complete Usage Examples**
/// 
/// This example demonstrates all the ways you can use Share My APK programmatically.
/// Run this from the root of a Flutter project to see it in action.
/// 
/// ```bash
/// dart run example/main.dart
/// ```

import 'package:share_my_apk/share_my_apk.dart';
import 'package:logging/logging.dart';

void main() async {
  print('🚀 Share My APK - Library Usage Examples\n');
  
  // Configure logging to see detailed output
  _setupLogging();

  // Run different examples
  await _basicExample();
  await _advancedBuildExample();
  await _configurationExample();
  await _multiProviderExample();
}

/// **Example 1: Basic APK Build and Upload**
/// 
/// The simplest way to build and upload an APK.
Future<void> _basicExample() async {
  print('\n📦 Example 1: Basic Build & Upload');
  print('=' * 50);
  
  try {
    // Build APK with default settings
    final buildService = FlutterBuildService();
    final apkPath = await buildService.build(release: true);
    
    print('✅ APK built: $apkPath');
    
    // Upload to Gofile (no token required)
    final uploader = UploadServiceFactory.create('gofile');
    final downloadLink = await uploader.upload(apkPath);
    
    print('🔗 Download: $downloadLink');
  } catch (e) {
    print('❌ Error: $e');
  }
}

/// **Example 2: Advanced Build Configuration**
/// 
/// Shows all the build pipeline options available.
Future<void> _advancedBuildExample() async {
  print('\n🔧 Example 2: Advanced Build Pipeline');
  print('=' * 50);
  
  try {
    final buildService = FlutterBuildService();
    
    // Build with comprehensive pipeline configuration
    final apkPath = await buildService.build(
      release: true,                    // Release mode
      projectPath: '.',                 // Current directory
      customName: 'MyApp_Production',   // Custom APK name
      environment: 'prod',              // Environment folder
      outputDir: 'build/releases',      // Custom output directory
      clean: true,                      // Run flutter clean
      getPubDeps: true,                 // Run flutter pub get
      generateL10n: true,               // Generate localizations
      verbose: true,                    // Verbose logging
    );
    
    print('✅ Advanced build completed: $apkPath');
  } catch (e) {
    print('❌ Build failed: $e');
  }
}

/// **Example 3: Configuration Management**
/// 
/// Demonstrates how to work with configuration files.
Future<void> _configurationExample() async {
  print('\n⚙️ Example 3: Configuration Management');
  print('=' * 50);
  
  try {
    // Read configuration from YAML files
    final config = ConfigService.getConfig();
    print('📄 Config loaded: ${config.keys.join(', ')}');
    
    // Parse CLI arguments
    final argParser = ArgParserUtil();
    final options = argParser.parse([
      '--name', 'ConfigExample',
      '--environment', 'staging',
      '--provider', 'gofile',
    ]);
    
    print('🎯 Parsed options: ${options.customName}, ${options.environment}');
    
    // Use configuration in builds
    final buildService = FlutterBuildService();
    final apkPath = await buildService.build(
      customName: options.customName,
      environment: options.environment,
      release: options.isRelease,
    );
    
    print('✅ Config-based build: $apkPath');
  } catch (e) {
    print('❌ Configuration error: $e');
  }
}

/// **Example 4: Multi-Provider Upload Strategy**
/// 
/// Shows how to handle different upload providers intelligently.
Future<void> _multiProviderExample() async {
  print('\n☁️ Example 4: Smart Provider Selection');
  print('=' * 50);
  
  // Example APK path (replace with actual path in real usage)
  const exampleApkPath = './build/app/outputs/flutter-apk/app-release.apk';
  
  try {
    // Strategy 1: Use Gofile for large files (no size limit)
    print('📤 Strategy 1: Gofile.io (unlimited size)');
    final gofileUploader = UploadServiceFactory.create('gofile');
    // In real usage: await gofileUploader.upload(exampleApkPath);
    print('   ✅ Would upload to Gofile.io');
    
    // Strategy 2: Use Diawi for team sharing (requires token)
    print('📤 Strategy 2: Diawi (team sharing)');
    try {
      final diawiUploader = UploadServiceFactory.create(
        'diawi', 
        token: 'your_diawi_token_here',
      );
      // In real usage: await diawiUploader.upload(exampleApkPath);
      print('   ✅ Would upload to Diawi');
    } catch (e) {
      print('   ⚠️ Diawi requires token: $e');
    }
    
    // Strategy 3: Smart provider switching based on file size
    print('📤 Strategy 3: Smart switching (recommended)');
    print('   💡 Use Diawi for <70MB files, Gofile for larger files');
    print('   💡 Implement size checking in your app logic');
    
  } catch (e) {
    print('❌ Provider error: $e');
  }
}

/// **Utility Examples**

/// Example of using retry utility for robust operations
void _retryExample() {
  print('\n🔄 Retry Utility Example');
  print('=' * 50);
  
  // Example: Retry a network operation with exponential backoff
  // Note: This is a conceptual example - adapt to your needs
  print('💡 RetryUtil available for robust network operations');
  print('   - Exponential backoff');
  print('   - Configurable retry conditions');
  print('   - Network error handling');
}

/// Example of APK organization
void _organizationExample() {
  print('\n📁 File Organization Example');
  print('=' * 50);
  
  print('💡 APK files are automatically organized:');
  print('   build/releases/');
  print('   ├── prod/');
  print('   │   └── MyApp_1.0.0_2025_01_15_14_30_45.apk');
  print('   ├── staging/');
  print('   │   └── MyApp_Beta_1.0.0_2025_01_15_12_15_30.apk');
  print('   └── dev/');
  print('       └── MyApp_Dev_1.0.0_2025_01_15_10_00_00.apk');
}

/// Configures logging to display all messages with timestamps.
void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    final logger = Logger('main');
    final timestamp = record.time.toIso8601String().substring(0, 19);
    logger.info('[$timestamp] ${record.level.name}: ${record.message}');
  });
}
