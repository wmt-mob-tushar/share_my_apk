# share_my_apk

A powerful command-line tool to build and upload your Flutter Android APKs directly to various services like Diawi and Gofile.io. This package can also be used as a library to integrate the APK building and uploading functionality into your own Dart applications.

**Developed by the Mobile Department at [Webmob Technologies](https://www.webmobtech.com/)**

> **Note:** This package is currently in alpha version and only supports Android APKs. Please test thoroughly before using in production environments.

## Features

- **Build & Upload:** Seamlessly build your Flutter Android application (in release or debug mode) and upload the generated APK.
- **Multiple Providers:** Supports Diawi and Gofile.io for APK uploads, with automatic switching to Gofile.io for large files (over 70MB) when Diawi is selected.
- **Custom File Naming:** Generate APK files with custom names, timestamps, and version information.
- **Directory Organization:** Organize builds by environment (dev, prod, staging) and custom output directories.
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
  share_my_apk: ^0.2.0-alpha # Replace with the latest version
```

Then, run `dart pub get`.

## Usage

### Configuration File (Recommended)

For easier project-specific configuration, you can generate a `share_my_apk.yaml` file in the root of your project. This allows you to set default values for any of the command-line options.

To generate the configuration file, run:

```bash
share_my_apk --init
```

This will create a `share_my_apk.yaml` file with all the available options, commented out and ready to be configured.

### As a Command-Line Tool

Once activated, you can use the `share_my_apk` command in your terminal. Use `share_my_apk --help` to see all available options.

```bash
share_my_apk [options]
```

**Options:**

| Option           | Abbreviation | Description                                                                 |
|------------------|--------------|-----------------------------------------------------------------------------|
| `--help`         | `-h`         | Displays the help message.                                                  |
| `--init`         |              | Generates a `share_my_apk.yaml` configuration file.                         |
| `--diawi-token`  |              | Your API token for Diawi.                                                   |
| `--gofile-token` |              | Your API token for Gofile.                                                  |
| `--path`         | `-p`         | Path to your Flutter project. Defaults to the current directory.            |
| `--release`      |              | Build in release mode (default). Use `--no-release` for debug mode.       |
| `--provider`     |              | The upload provider to use ('diawi' or 'gofile'). Defaults to 'diawi'.    |
| `--name`         | `-n`         | Custom name for the APK file (without extension).                          |
| `--environment`  | `-e`         | Environment folder (dev, prod, staging, etc.).                             |
| `--output-dir`   | `-o`         | Output directory for the built APK.                                        |

**Examples:**

```bash
# Generate a configuration file
share_my_apk --init

# Build and upload a release APK using settings from share_my_apk.yaml
share_my_apk

# Override the provider from the config file
share_my_apk --provider gofile

# Build a debug APK
share_my_apk --no-release

# Provide a token via the command line
share_my_apk --diawi-token YOUR_SECRET_DIAWI_TOKEN
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

    // 2. Build the APK with custom naming and organization
    final apkPath = await apkBuilder.build(
      release: true, 
      projectPath: '.',
      customName: 'MyApp_Beta',
      environment: 'staging',
      outputDir: '/path/to/builds',
    );
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

## File Naming and Organization

### Custom File Naming
When you use the `--name` option, the APK will be named using the format:
- **Custom name:** `{customName}_{version}_{timestamp}.apk`
- **Default name:** `{appName}_{version}_{timestamp}.apk`

The timestamp format is: `YYYY_MM_DD_HH_MM_SS`

### Directory Organization
- **Environment folders:** Use `--environment` to organize builds by environment (dev, prod, staging, etc.)
- **Custom output directory:** Use `--output-dir` to specify where APK files should be saved
- **Default structure:** `{projectPath}/build/apk/{environment}/`

### Examples of Generated Files
```bash
# Default naming
my_app_1.0.0_2024_01_15_14_30_45.apk

# Custom naming
MyApp_Beta_1.0.0_2024_01_15_14_30_45.apk

# With environment organization
/path/to/builds/staging/MyApp_Beta_1.0.0_2024_01_15_14_30_45.apk
```

## Testing

This package is currently in alpha version. Please test it thoroughly in your development environment before using in production. We recommend:

1. Testing with different Flutter project structures
2. Verifying uploads work correctly with both providers
3. Testing both release and debug builds
4. Checking the automatic provider switching feature

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please file an issue or submit a pull request on the [project's repository](https://github.com/wm-jenildgohel/share_my_apk).

## License

This project is licensed under the MIT License - see the LICENSE file for details.
