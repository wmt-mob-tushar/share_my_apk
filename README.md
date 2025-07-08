<p align="center">
  <img src="https://raw.githubusercontent.com/wm-jenildgohel/share_my_apk/master/assets/logo.png" alt="Share My APK Logo" width="200">
</p>

<h1 align="center">Share My APK</h1>

<p align="center">
  <strong>Tired of the build-and-drag-drop dance? 🕺💃</strong>
  <br />
  Share My APK is your new best friend! This command-line tool automates building and uploading your Flutter Android APKs to services like Diawi and Gofile.io, so you can share your builds faster than you can say "It's compiling!"
  <br />
  <br />
  <a href="https://pub.dev/packages/share_my_apk"><img src="https://img.shields.io/pub/v/share_my_apk.svg" alt="Pub Version"></a>
  <a href="https://github.com/wm-jenildgohel/share_my_apk/blob/master/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License"></a>
  <a href="https://github.com/wm-jenildgohel/share_my_apk/actions"><img src="https://github.com/wm-jenildgohel/share_my_apk/workflows/build/badge.svg" alt="Build Status"></a>
</p>

> **Note:** This package is currently in its alpha stage and only supports Android APKs. Please use with a dash of adventurous spirit! 🧪

## ✨ Features

-   **🚀 Build & Upload:** Seamlessly build your Flutter app and upload the APK.
-   **☁️ Multiple Providers:** Supports Diawi and Gofile.io. It even auto-switches to Gofile.io for larger files!
-   **📝 Smart Configuration:** Use a `share_my_apk.yaml` file for project-specific settings.
-   **🎨 Customization Galore:** Customize file names, directory structures, and build environments.
-   **💻 User-Friendly CLI:** A simple and intuitive command-line interface.
-   **🔧 Extensible Library:** Use the core services in your own Dart projects.

## 📦 Installation

Activate `share_my_apk` globally to use it from anywhere:

```bash
dart pub global activate share_my_apk
```

Or, add it to your project's `dev_dependencies` in `pubspec.yaml`:

```yaml
dev_dependencies:
  share_my_apk: ^0.3.0-alpha # Get the latest version from pub.dev
```

Then, run `dart pub get`.

## 🚀 Usage

### 1. Initialize (Recommended)

Generate a `share_my_apk.yaml` config file in your project root. It's the best way to manage your settings.

```bash
share_my_apk --init
```

This creates a `share_my_apk.yaml` file with all available options, ready for you to customize.

### 2. Run from the Command Line

Once activated, use the `share_my_apk` command. Check out `share_my_apk --help` for all the options.

```bash
share_my_apk [options]
```

**Key Options:**

| Option           | Alias | Description                                                  |
| ---------------- | ----- | ------------------------------------------------------------ |
| `--help`         | `-h`  | Shows the help message.                                      |
| `--init`         |       | Generates a `share_my_apk.yaml` config file.                 |
| `--diawi-token`  |       | Your Diawi API token.                                        |
| `--gofile-token` |       | Your Gofile API token.                                       |
| `--path`         | `-p`  | Path to your Flutter project (defaults to current dir).      |
| `--release`      |       | Build in release mode (use `--no-release` for debug).        |
| `--provider`     |       | Upload provider: `diawi` or `gofile` (defaults to `diawi`).  |
| `--name`         | `-n`  | Custom name for the APK file.                                |
| `--environment`  | `-e`  | Environment folder (e.g., `dev`, `prod`, `staging`).         |
| `--output-dir`   | `-o`  | Output directory for the built APK.                          |

**Examples:**

```bash
# Generate a config file
share_my_apk --init

# Build and upload using your config file
share_my_apk

# Override the provider
share_my_apk --provider gofile

# Build a debug APK
share_my_apk --no-release
```

### 3. Use as a Library

Integrate `share_my_apk`'s services directly into your Dart code.

**Example:**

```dart
import 'package:share_my_apk/share_my_apk.dart';
import 'package:logging/logging.dart';

void main() async {
  // Set up logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  final logger = Logger('MyApp');

  try {
    // 1. Build the APK
    final apkPath = await FlutterBuildService().build(
      release: true,
      projectPath: '.',
      customApkName: 'MyApp_Beta',
      environment: 'staging',
      outputDir: 'build/my_apks',
    );
    logger.info('✅ APK built: $apkPath');

    // 2. Upload the APK
    final uploader = UploadServiceFactory.create(
      'gofile', // or 'diawi'
      token: 'YOUR_DIAWI_TOKEN', // Only for Diawi
    );

    final downloadLink = await uploader.upload(apkPath);
    logger.info('🚀 Upload successful! Download here: $downloadLink');

  } catch (e) {
    logger.severe('🔥 An error occurred: $e');
  }
}
```

## 📁 File Naming & Organization

-   **Custom Naming:** Use `--name` to get `{customName}_{version}_{timestamp}.apk`.
-   **Default Naming:** Get `{appName}_{version}_{timestamp}.apk`.
-   **Environments:** Use `--environment` to sort builds into folders like `dev`, `prod`, etc.
-   **Custom Output:** Use `--output-dir` to save APKs wherever you want.

## 🧪 Testing

This package is in alpha. Please test it in your dev environment before relying on it for production.

## 🤝 Contributing

Got ideas? Found a bug? Contributions are welcome! Please file an issue or submit a pull request on our [GitHub repo](https://github.com/wm-jenildgohel/share_my_apk).

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.