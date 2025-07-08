# share_my_apk

A powerful command-line tool to build and upload your Flutter APKs directly to various services like Diawi and Gofile.io, inspired by `flutter_build_uploader`. This package can also be used as a library to integrate the APK building and uploading functionality into your own Dart applications.

## Features

- **Build & Upload:** Seamlessly build your Flutter application (in release or debug mode) and upload the generated APK.
- **Multiple Providers:** Supports Diawi and Gofile.io for APK uploads, with automatic switching to Gofile.io for large files (over 70MB) when Diawi is selected.
- **Command-Line Interface:** A user-friendly CLI for quick and easy use.
- **Extensible Library:** Use the underlying services as a library in your own projects.
- **Professional Logging:** Structured and informative logging using the standard `logging` package.

## Getting Started

### Installation

To use `share_my_apk` as a command-line tool, you can activate it globally:

```bash
dart pub global activate share_my_apk
```

Or, you can add it to your project's `dev_dependencies` in `pubspec.yaml`:

```yaml
dev_dependencies:
  share_my_apk: ^1.0.0 # Replace with the latest version
```

Then, run `dart pub get`.

## Usage

### As a Command-Line Tool

Once activated, you can use the `share_my_apk` command in your terminal:

```bash
share_my_apk [options]
```

**Options:**

| Option      | Abbreviation | Description                                                                 |
|-------------|--------------|-----------------------------------------------------------------------------|
| `--token`   | `-t`         | Your API token (required for Diawi, optional for Gofile.io).                |
| `--path`    | `-p`         | Path to your Flutter project. Defaults to the current directory.            |
| `--release` |              | Build in release mode (default). Use `--no-release` for debug mode.       |
| `--provider`|              | The upload provider to use ('diawi' or 'gofile'). Defaults to 'diawi'. |

**Examples:**

```bash
# Build and upload a release APK to Diawi from the current project
share_my_apk --token YOUR_SECRET_DIAWI_TOKEN

# Build and upload a debug APK to Gofile.io from a specific project path
share_my_apk --no-release --path /path/to/your/project --provider gofile

# Build and upload a release APK to Diawi, even if it's larger than 70MB (will switch to gofile.io automatically)
share_my_apk --token YOUR_SECRET_DIAWI_TOKEN --provider diawi
```

### As a Library

You can also use the core services of this package in your own Dart code.

**Example:**

```dart
import 'package:share_my_apk/share_my_apk.dart';
import 'package:logging/logging.dart';

void main() async {
  // Configure logging (optional)
  Logger.root.level = Level.ALL; // Set to desired logging level
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  final logger = Logger('main');

  try {
    // 1. Initialize the APK builder service
    final apkBuilder = ApkBuilderService();

    // 2. Build the APK
    final apkPath = await apkBuilder.build(release: true, projectPath: '.');
    logger.info('APK built successfully: $apkPath');

    // 3. Choose the upload provider and upload the APK
    // The token is only required for Diawi.
    final uploader = UploadServiceFactory.create(
      'gofile', // or 'diawi'
      token: 'YOUR_DIAWI_TOKEN', // Replace with your token if using Diawi
    );

    final downloadLink = await uploader.upload(apkPath);

    logger.info('Upload successful!');
    logger.info('Download Link: $downloadLink');

  } on ProcessException catch (e) {
    logger.severe('Failed to build APK: ${e.message}');
  } catch (e) {
    logger.severe('An unexpected error occurred: $e');
  }
}
```

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please file an issue or submit a pull request on the project's repository.

---
