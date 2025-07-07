# share_my_apk

A powerful command-line tool to build and upload your Flutter APKs directly to Diawi, inspired by `flutter_build_uploader`. This package can also be used as a library to integrate the APK building and uploading functionality into your own Dart applications.

## Features

- **Build & Upload:** Seamlessly build your Flutter application (in release or debug mode) and upload the generated APK to Diawi.
- **Command-Line Interface:** A user-friendly CLI for quick and easy use.
- **Extensible Library:** Use the underlying services as a library in your own projects.
- **Professional Logging:** Structured and informative logging using `snug_logger`.

## Getting Started

### Installation

To use `share_my_apk` as a command-line tool, you can activate it globally:

```bash
dart pub global activate share_my_apk
```

Or, you can add it to your project's `dev_dependencies` in `pubspec.yaml`:

```yaml
dev_dependencies:
  share_my_apk: ^0.0.1 # Replace with the latest version
```

Then, run `dart pub get`.

## Usage

### As a Command-Line Tool

Once activated, you can use the `share_my_apk` command in your terminal:

```bash
share_my_apk --token <your_diawi_token> [options]
```

**Options:**

| Option      | Abbreviation | Description                               |
|-------------|--------------|-------------------------------------------|
| `--token`   | `-t`         | **Required.** Your Diawi API token.       |
| `--path`    | `-p`         | Path to your Flutter project. Defaults to the current directory. |
| `--no-release` |            | Build in debug mode instead of release.   |

**Example:**

```bash
# Build and upload a release APK from the current project
share_my_apk -t YOUR_SECRET_DIAWI_TOKEN

# Build and upload a debug APK from a specific project path
share_my_apk -t YOUR_SECRET_DIAWI_TOKEN --no-release -p /path/to/your/project
```

### As a Library

You can also use the core services of this package in your own Dart code.

**Example:**

```dart
import 'package:share_my_apk/share_my_apk.dart';
import 'package:snug_logger/snug_logger.dart';

void main() async {
  final logger = SnugLogger(output: AnsiOutput());

  try {
    // 1. Initialize the services
    final apkBuilder = ApkBuilderService();
    final uploader = DiawiUploadService('YOUR_SECRET_DIAWI_TOKEN');

    // 2. Build the APK
    final apkPath = await apkBuilder.build(release: true);

    // 3. Upload the APK
    final downloadLink = await uploader.upload(apkPath);

    logger.info('Upload successful!');
    logger.info('Download Link: $downloadLink');

  } catch (e) {
    logger.severe('An error occurred: $e');
  }
}
```

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please file an issue or submit a pull request on the project's repository.

---

*This package is inspired by [flutter_build_uploader](https://pub.dev/packages/flutter_build_uploader).*
