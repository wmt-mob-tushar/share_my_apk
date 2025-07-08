/// Comprehensive examples demonstrating share_my_apk package usage.
///
/// This file contains multiple examples showing different ways to use
/// the share_my_apk package for building and uploading Flutter APKs.

import 'package:share_my_apk/share_my_apk.dart';
import 'package:logging/logging.dart';

/// Main function demonstrating various usage patterns.
void main() async {
  // Configure logging to see detailed output
  _setupLogging();

  print('=== Share My APK Examples ===\n');

  // Run examples (uncomment to test specific scenarios)
  await _basicBuildExample();
  await _customNamingExample();
  await _environmentOrganizationExample();
  await _fullWorkflowExample();
  await _errorHandlingExample();
  _cliOptionsExample();
  await _advancedConfigurationExample();
}

/// Configures logging to display all messages with timestamps.
void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    final timestamp = record.time.toIso8601String().substring(0, 19);
    print('[$timestamp] ${record.level.name}: ${record.message}');
  });
}

/// Example 1: Basic APK build with default settings.
Future<void> _basicBuildExample() async {
  print('📱 Example 1: Basic APK Build\n');

  try {
    final apkBuilder = ApkBuilderService();
    
    // Build APK with default settings (release mode, current directory)
    final apkPath = await apkBuilder.build();
    
    print('✅ APK built successfully: $apkPath\n');
  } catch (e) {
    print('❌ Build failed: $e\n');
  }
}

/// Example 2: Custom file naming with timestamps.
Future<void> _customNamingExample() async {
  print('📝 Example 2: Custom File Naming\n');

  try {
    final apkBuilder = ApkBuilderService();
    
    // Build APK with custom name
    final apkPath = await apkBuilder.build(
      release: true,
      customName: 'MyAwesomeApp_Beta',
    );
    
    print('✅ Custom named APK: $apkPath\n');
  } catch (e) {
    print('❌ Custom naming failed: $e\n');
  }
}

/// Example 3: Environment-based directory organization.
Future<void> _environmentOrganizationExample() async {
  print('📁 Example 3: Environment Organization\n');

  try {
    final apkBuilder = ApkBuilderService();
    
    // Build and organize by environment
    final stagingApk = await apkBuilder.build(
      environment: 'staging',
      customName: 'App_Staging',
    );
    
    print('✅ Staging APK: $stagingApk');
    
    // Build for production environment
    final prodApk = await apkBuilder.build(
      environment: 'production',
      customName: 'App_Production',
      outputDir: '/tmp/production_builds',
    );
    
    print('✅ Production APK: $prodApk\n');
  } catch (e) {
    print('❌ Environment organization failed: $e\n');
  }
}

/// Example 4: Complete build and upload workflow.
Future<void> _fullWorkflowExample() async {
  print('🚀 Example 4: Complete Build & Upload Workflow\n');

  try {
    // Step 1: Build the APK
    final apkBuilder = ApkBuilderService();
    final apkPath = await apkBuilder.build(
      release: true,
      customName: 'MyApp_Release',
      environment: 'prod',
    );
    
    print('📦 APK built: $apkPath');
    
    // Step 2: Upload to Gofile.io (no token required)
    final uploader = UploadServiceFactory.create('gofile');
    final downloadUrl = await uploader.upload(apkPath);
    
    print('🌐 Download URL: $downloadUrl');
    print('✅ Complete workflow finished!\n');
    
  } catch (e) {
    print('❌ Workflow failed: $e\n');
  }
}

/// Example 5: Error handling and recovery patterns.
Future<void> _errorHandlingExample() async {
  print('⚠️  Example 5: Error Handling\n');

  final apkBuilder = ApkBuilderService();
  
  try {
    // Attempt to build from non-existent directory
    await apkBuilder.build(
      projectPath: '/non/existent/path',
    );
  } on Exception catch (e) {
    print('🔍 Caught expected error: $e');
  }
  
  try {
    // Attempt upload with invalid file
    final uploader = UploadServiceFactory.create('gofile');
    await uploader.upload('/non/existent/file.apk');
  } on Exception catch (e) {
    print('🔍 Caught upload error: $e');
  }
  
  print('✅ Error handling examples completed\n');
}

/// Example 6: Using CLI options programmatically.
void _cliOptionsExample() {
  print('⚙️  Example 6: CLI Options Usage\n');

  // Create configuration for different scenarios
  final devOptions = CliOptions(
    path: '/path/to/dev/project',
    isRelease: false, // Debug build for development
    customName: 'DevBuild',
    environment: 'dev',
    provider: 'gofile',
  );

  final prodOptions = CliOptions(
    token: 'your_diawi_token',
    path: '/path/to/prod/project',
    isRelease: true, // Release build for production
    customName: 'ProdRelease',
    environment: 'production',
    outputDir: '/builds/production',
    provider: 'diawi',
  );

  print('Dev config: $devOptions');
  print('Prod config: $prodOptions');
  print('✅ CLI options examples completed\n');
}

/// Example 7: Advanced configuration patterns.
Future<void> _advancedConfigurationExample() async {
  print('🔧 Example 7: Advanced Configuration\n');

  // Example of building multiple variants
  final variants = [
    {'env': 'dev', 'name': 'DevBuild', 'debug': true},
    {'env': 'staging', 'name': 'StagingBuild', 'debug': false},
    {'env': 'prod', 'name': 'ProductionBuild', 'debug': false},
  ];

  final apkBuilder = ApkBuilderService();

  for (final variant in variants) {
    try {
      print('Building ${variant['name']} variant...');
      
      final apkPath = await apkBuilder.build(
        release: !(variant['debug'] as bool),
        customName: variant['name'] as String,
        environment: variant['env'] as String,
      );
      
      print('✅ Built ${variant['name']}: $apkPath');
    } catch (e) {
      print('❌ Failed to build ${variant['name']}: $e');
    }
  }
  
  print('🏁 Advanced configuration examples completed\n');
}