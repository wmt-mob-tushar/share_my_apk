<h1 align="center">Share My APK</h1>

<p align="center">
  <strong>Tired of the build-and-drag-drop dance? 🕺💃 Is your mouse complaining about all the extra mileage?</strong>
  <br />
  Give your mouse a break! Share My APK is your new best friend, built with love and a sprinkle of magic to automate building and uploading your Flutter Android APKs. Share your builds faster than you can say "Why wasn't this a feature in the first place?!"
  <br />
  <br />
  <a href="https://pub.dev/packages/share_my_apk"><img src="https://img.shields.io/pub/v/share_my_apk.svg" alt="Pub Version"></a>
  <a href="https://github.com/wm-jenildgohel/share_my_apk/blob/master/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License"></a>
  <a href="https://github.com/wm-jenildgohel/share_my_apk/actions"><img src="https://github.com/wm-jenildgohel/share_my_apk/workflows/build/badge.svg" alt="Build Status"></a>
  <a href="https://github.com/wm-jenildgohel/share_my_apk/blob/master/TESTING.md"><img src="https://img.shields.io/badge/testing-comprehensive-green.svg" alt="Testing"></a>
</p>

> **🚀 Beta Release:** This package is in beta with comprehensive testing! We've fixed API integration issues and added 100+ tests. Ready for production testing - use with confidence! 🛡️

## ✨ Features (The Fun Stuff)

-   **🚀 Build & Upload:** Go from code to shareable link in one command. It's so fast, you'll have time for an extra coffee break.
-   **☁️ Multiple Providers:** Supports Diawi and Gofile.io with fixed API integration. Tested with 113MB+ APKs!
-   **🔄 Smart Provider Switching:** Automatically switches from Diawi to Gofile for files >70MB. No more upload failures!
-   **📝 Smart Configuration:** Use a `share_my_apk.yaml` file. Because who wants to type the same thing over and over? Not you, that's who.
-   **🎨 Customization Galore:** Customize file names, directory structures, and build environments. Make it yours!
-   **💻 User-Friendly CLI:** A CLI so friendly, it might just ask you about your day.
-   **🔧 Extensible Library:** Want to build your own sharing empire? Use our core services in your Dart projects.
-   **🧪 Comprehensive Testing:** 100+ tests covering all scenarios. No more "it works on my machine" moments!
-   **🛡️ Rock-Solid Reliability:** Fixed API integration issues and added robust error handling.

## 📦 Installation

Activate `share_my_apk` globally. It's like giving it a key to your terminal's heart.

```bash
dart pub global activate share_my_apk
```

Or, if you're the "keep your friends close" type, add it to your project's `dev_dependencies`:

```yaml
dev_dependencies:
  share_my_apk: ^0.4.0-beta # Always check for the latest version!
```

Then, run `dart pub get`.

## 🚀 Usage

### 1. Initialize (The Smart Move)

Generate a `share_my_apk.yaml` config file. Your future self will thank you.

```bash
share_my_apk --init
```

This creates a `share_my_apk.yaml` file, your personal instruction manual for the tool.

### 2. Run from the Command Line

Time to let the magic happen. Use `share_my_apk --help` if you need a reminder of its awesome powers.

```bash
share_my_apk [options]
```

**Key Options:**

| Option           | Alias | Description                                                  |
| ---------------- | ----- | ------------------------------------------------------------ |
| `--help`         | `-h`  | Shows the help message. It's like a map to treasure.         |
| `--init`         |       | Generates the magical `share_my_apk.yaml` config file.       |
| `--diawi-token`  |       | Your Diawi API token. Keep it secret, keep it safe.          |
| `--gofile-token` |       | Your Gofile API token. Also a secret.                        |
| `--path`         | `-p`  | Path to your Flutter project. Defaults to wherever you are.  |
| `--release`      |       | Build in release mode (use `--no-release` for debug).        |
| `--provider`     |       | Upload provider: `diawi` or `gofile`. Choose your champion.  |
| `--name`         | `-n`  | Custom name for the APK file. Be creative!                   |
| `--environment`  | `-e`  | Environment folder (e.g., `dev`, `prod`, `staging`).         |
| `--output-dir`   | `-o`  | Where to save the APK. Your treasure chest.                  |

**Examples:**

```bash
# Let's get started!
share_my_apk --init

# Unleash the power!
share_my_apk

# "I choose you, Gofile!"
share_my_apk --provider gofile

# For when you're feeling a bit buggy.
share_my_apk --no-release
```

### 3. Use as a Library

Want to get your hands dirty? Integrate `share_my_apk`'s services into your own code.

**Example:**

```dart
import 'package:share_my_apk/share_my_apk.dart';
import 'package:logging/logging.dart';

void main() async {
  // Let's see what's happening under the hood.
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  final logger = Logger('MyApp');

  try {
    // 1. Build the APK. Abracadabra!
    final apkPath = await FlutterBuildService().build(
      release: true,
      projectPath: '.',
      customApkName: 'MyApp_SuperCool_Beta',
      environment: 'staging',
      outputDir: 'build/my_apks',
    );
    logger.info('✅ APK built! Find it at: $apkPath');

    // 2. Send it to the cloud!
    final uploader = UploadServiceFactory.create(
      'gofile', // or 'diawi'
      token: 'YOUR_DIAWI_TOKEN', // Only for Diawi, remember?
    );

    final downloadLink = await uploader.upload(apkPath);
    logger.info('🚀 Houston, we have a download link: $downloadLink');

  } catch (e) {
    logger.severe('🔥 Uh oh, something went wrong: $e');
  }
}
```

## 📁 File Naming & Organization

-   **Custom Naming:** `--name` gives you `{customName}_{version}_{timestamp}.apk`.
-   **Default Naming:** You get `{appName}_{version}_{timestamp}.apk`.
-   **Environments:** `--environment` helps you avoid mixing up your `dev` and `prod` builds. Phew!
-   **Custom Output:** `--output-dir` lets you be the boss of your file system.

## 🧪 Testing & Reliability

This package is in beta with comprehensive testing! We've implemented:

- **100+ Unit Tests** covering all major components
- **6 Test Categories** including upload services, build services, CLI, error handling, and integration
- **Real API Testing** with successful uploads to both Diawi and Gofile
- **Edge Case Coverage** for file handling, network errors, and configuration issues
- **Continuous Integration** with static analysis and automated testing

See [TESTING.md](TESTING.md) for complete testing documentation.

### What's New in 0.4.0-beta
- ✅ Fixed Gofile API integration (now works with large files)
- ✅ Enhanced Diawi API with proper polling mechanism
- ✅ Automatic provider switching for files >70MB
- ✅ Comprehensive error handling and validation
- ✅ All tests passing with static analysis

**Ready for Production Testing!** While we've thoroughly tested in development, we recommend testing in your specific environment before production use.

## 🤝 Contributing

Got a joke to add? Or maybe a feature? Contributions are welcome! File an issue or a pull request on our [GitHub repo](https://github.com/wm-jenildgohel/share_my_apk).

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details. Don't worry, it's a friendly license.
