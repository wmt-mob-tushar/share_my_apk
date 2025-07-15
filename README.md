<div align="start">

# 🚀 Share My APK

**The Ultimate Flutter APK Build & Upload Automation Tool**

*Stop the build-and-drag-drop dance! 💃 Your mouse deserves a break.*

[![Pub Version](https://img.shields.io/pub/v/share_my_apk?style=for-the-badge&logo=dart&logoColor=white)](https://pub.dev/packages/share_my_apk)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](https://github.com/wm-jenildgohel/share_my_apk/blob/master/LICENSE)
[![Status](https://img.shields.io/badge/Status-Production%20Ready-brightgreen?style=for-the-badge&logo=rocket&logoColor=white)](https://github.com/wm-jenildgohel/share_my_apk)

**From code to shareable link in one command** ⚡

*Automate your Flutter Android APK builds and uploads with the power of magic (and some really good code)*

</div>

---

## 🎯 **Why Share My APK?**

<table>
<tr>
<td width="50%">

### 😩 **Before Share My APK**
- Manual `flutter build apk` commands
- Drag & drop APKs to upload sites
- Manually manage file names and versions
- Deal with upload failures and size limits
- Remember different tokens for different services
- Copy-paste download links manually

</td>
<td width="50%">

### 🚀 **After Share My APK**
- **One command** builds and uploads
- **Automatic** FVM detection and Flutter commands
- **Comprehensive** build pipeline (clean, pub get, gen-l10n)
- **Fully automated** - no manual confirmations needed
- **Smart** file naming with versions
- **Robust** error handling and retries
- **Unified** configuration management
- **Instant** shareable links

</td>
</tr>
</table>

---

## ✨ **What Makes It Special?**

<div align="center">

| 🏆 **Feature** | 🎯 **Benefit** | 🔥 **Why It Matters** |
|---|---|---|
| **🚀 One-Command Magic** | `share_my_apk` does it all | Save hours of manual work |
| **🔧 Comprehensive Pipeline** | Clean, deps, l10n, build | Enterprise-grade reliability |
| **☁️ Multi-Provider Support** | Diawi + Gofile.io | Never worry about size limits |
| **🔄 Smart Auto-Switching** | Diawi → Gofile for 70MB+ files | Zero upload failures |
| **📝 Smart Configuration** | YAML-based setup | Set once, use forever |
| **🛡️ Reliable & Tested** | Production-ready | Works every time |
| **🎨 Flexible Organization** | Custom naming & folders | Keep your builds organized |

</div>

---

## 📚 **Usage**

See the [Quick Start](#⚡-quick-start) and [Usage Examples](#🎮-usage-examples) sections below for detailed instructions.

---

## ⬇️ **Installation**

Refer to the [Installation Options](#-installation-options) section for how to install `share_my_apk`.

---

## 💡 **Examples**

Check out the [Usage Examples](#🎮-usage-examples) section for various ways to use this tool.

---

## 🎉 **What's New in v1.0.0?**

> **🚀 Production Ready - First Stable Release!**

<div align="start">
 
### ✨ **Key Improvements**

✅ **Production Ready** - Upgraded from beta to stable 1.0.0 release after comprehensive testing  
✅ **Zero Issues** - Passed all quality checks with 100+ tests and complete validation  
✅ **Comprehensive Documentation** - Complete API docs, examples, and guides  
✅ **Enterprise-Grade Quality** - Rock-solid reliability for production workflows  
✅ **Full Pub.dev Compliance** - Maximum scoring and best practices  

</div>

<details>
<summary>👀 Click to see the new logs in action!</summary>

```ansi
 [32mℹ️ [12:55:55] 🚀 Starting comprehensive APK build (mode: release)... [0m
 [32mℹ️ [12:55:55] Using Flutter command: fvm flutter [0m
 [32mℹ️ [12:55:55] 🧹 [1/4] Cleaning project... [0m
 [32mℹ️ [12:55:58] 📦 [2/4] Getting dependencies... [0m
 [32mℹ️ [12:56:02] 🌍 [3/4] Generating localizations... [0m
 [32mℹ️ [12:56:04] 🔨 [4/4] Building APK (release mode)... [0m
 [36m✨ [12:56:15] Build output: ✓ Built build/app/outputs/flutter-apk/app-release.apk (55.1MB) [0m
 [32mℹ️ [12:56:15] ✅ APK built successfully: ./build/app/outputs/flutter-apk/app-release.apk [0m
 [32mℹ️ [12:56:15] Uploading APK... [0m
 [32mℹ️ [12:56:15] File: ./moonnote_1.0.1+a2_2025_07_09_12_55_55.apk [0m
 [32mℹ️ [12:56:15] Size: 55.10 MB [0m
 [32mℹ️ [12:56:15] Provider: diawi [0m
 [32mℹ️ [12:56:25] Upload successful: https://i.diawi.com/SzSiZc [0m
 [32m╔═════════════════════╗ [0m
 [32m║ APK successfully uploaded to diawi!                                    ║ [0m
 [32m║ Download link: https://i.diawi.com/SzSiZc                              ║ [0m
 [32m╚═════════════════════╝ [0m
```

</details>

---

## ⚡ **Quick Start**

### 1️⃣ **Install**
```bash
dart pub global activate share_my_apk
```

### 2️⃣ **Configure**
```bash
share_my_apk --init
```

### 3️⃣ **Build & Upload**
```bash
share_my_apk
```

### 4️⃣ **Share** 
*Get instant download link!* 🔗

---

##  **Installation Options**

<table>
<tr>
<td width="50%">

### 🌍 **Global Installation**
```bash
dart pub global activate share_my_apk
```
*Perfect for CLI usage across all projects*

</td>
<td width="50%">

### 📦 **Project Dependency**
```yaml
dev_dependencies:
  share_my_apk: ^1.0.0
```
*Perfect for team projects and CI/CD pipelines*

</td>
</tr>
</table>

---

## 🎮 **Usage Examples**

### 🔧 **Basic Usage**

```bash
# Initialize configuration (one-time setup)
share_my_apk --init

# Build and upload with default settings
share_my_apk

# Use specific provider
share_my_apk --provider gofile

# Custom naming and environment
share_my_apk --name MyApp_Beta --environment staging

# Debug build
share_my_apk --no-release

# Skip build pipeline steps (for faster builds)
share_my_apk --no-clean --no-pub-get
```

### ⚙️ **Advanced Configuration**

Create `share_my_apk.yaml` in your project root:

```yaml
# Provider settings
provider: diawi

# API tokens
diawi_token: your_diawi_token_here
gofile_token: your_gofile_token_here

# Build settings
release: true
path: .

# Build pipeline controls
clean: true          # Run flutter clean
pub-get: true        # Run flutter pub get
gen-l10n: true       # Generate localizations

# File organization
name: MyApp_Production
environment: prod
output-dir: build/releases
```

### 🔬 **Library Usage**

```dart
import 'package:share_my_apk/share_my_apk.dart';

void main() async {
  // Build APK with comprehensive pipeline
  final buildService = FlutterBuildService();
  final apkPath = await buildService.build(
    release: true,
    customName: 'MyApp_Beta',
    environment: 'staging',
    clean: true,           // Run flutter clean
    getPubDeps: true,      // Run flutter pub get
    generateL10n: true,    // Generate localizations
  );

  // Upload to cloud
  final uploader = UploadServiceFactory.create('gofile');
  final downloadLink = await uploader.upload(apkPath);
  
  print('🚀 Download link: $downloadLink');
}
```

---

## 🎯 **Command Reference**

<div align="center">

| Command | Alias | Description | Example |
|---------|-------|-------------|---------|
| `--help` | `-h` | Show help message | `share_my_apk --help` |
| `--init` | - | Generate config file | `share_my_apk --init` |
| `--path` | `-p` | Project path | `share_my_apk -p /my/project` |
| `--provider` | - | Upload provider | `share_my_apk --provider gofile` |
| `--name` | `-n` | Custom APK name | `share_my_apk -n MyApp_Beta` |
| `--environment` | `-e` | Environment folder | `share_my_apk -e staging` |
| `--output-dir` | `-o` | Output directory | `share_my_apk -o build/apks` |
| `--diawi-token` | - | Diawi API token | `share_my_apk --diawi-token abc123` |
| `--gofile-token` | - | Gofile API token | `share_my_apk --gofile-token xyz789` |
| `--release` | - | Release build (default) | `share_my_apk --release` |
| `--no-release` | - | Debug build | `share_my_apk --no-release` |
| `--clean` | - | Run flutter clean (default) | `share_my_apk --clean` |
| `--no-clean` | - | Skip flutter clean | `share_my_apk --no-clean` |
| `--pub-get` | - | Run flutter pub get (default) | `share_my_apk --pub-get` |
| `--no-pub-get` | - | Skip flutter pub get | `share_my_apk --no-pub-get` |
| `--gen-l10n` | - | Generate localizations (default) | `share_my_apk --gen-l10n` |
| `--no-gen-l10n` | - | Skip localization generation | `share_my_apk --no-gen-l10n` |

</div>



> **💡 Pro Tip:** Share My APK automatically switches from Diawi to Gofile for files >70MB!

---

## 🚀 **Fully Automated Workflow**

<div align="start">

Share My APK now provides a completely automated experience, perfect for CI/CD pipelines and production workflows.

```
🧹 [1/4] Cleaning project...
📦 [2/4] Getting dependencies...
🌍 [3/4] Generating localizations...
🔨 [4/4] Building APK (release mode)...
ℹ️ [12:56:05] Uploading APK...
ℹ️ [12:56:05] File: /path/to/your/app.apk
ℹ️ [12:56:05] Size: 55.10 MB
ℹ️ [12:56:05] Provider: diawi
```

</div>

---

## 🛡️ **Reliability & Quality**

<div align="left">

Share My APK is **production-ready** and **thoroughly tested** to ensure it works reliably in real-world scenarios.

### ✅ **What We've Tested**
- **✅ Large File Uploads** - Successfully tested with 113MB+ APKs
- **✅ Network Resilience** - Handles connection issues gracefully
- **✅ Provider Switching** - Automatic fallback works seamlessly
- **✅ Build Pipeline** - Comprehensive testing with FVM, clean builds, dependencies
- **✅ Edge Cases** - Handles special characters, long paths, and more
- **✅ Cross-Platform** - Works on Windows, macOS, and Linux
- **✅ CI/CD Ready** - Fully automated for production deployments

**Ready for your production workflow!** 🚀

</div>

---

## 📁 **File Organization Magic**

Share My APK keeps your builds organized with smart naming:

```
output-directory/
├── environment/                    # Optional environment folder
│   ├── MyApp_1.0.0_2025_07_09_14_30_45.apk
│   ├── MyApp_1.0.1_2025_07_09_15_15_30.apk
│   └── ...
├── staging/
│   ├── MyApp_Beta_1.0.0_2025_07_09_12_00_00.apk
│   └── ...
└── prod/
    ├── MyApp_Production_1.0.0_2025_07_09_16_45_30.apk
    └── ...
```

**Naming Pattern:** `{name}_{version}_{timestamp}.apk`



## 📚 **Need More Info?**

<div align="center">

| 📖 **Resource** | 🎯 **What's Inside** |
|----------------|---------------------|
| **[API Documentation](https://pub.dev/documentation/share_my_apk/latest/)** | Complete API reference and guides |
| **[Release Notes](RELEASE_NOTES.md)** | What's new and version history |
| **[Changelog](CHANGELOG.md)** | Detailed version changes |
| **[Examples](example/)** | Working code examples and use cases |

</div>


## 🎉 **Ready to Get Started?**

<div align="left">


```bash
dart pub global activate share_my_apk
share_my_apk --init
share_my_apk
```

**That's it! You're now sharing APKs like a pro!** 🎯

</div>

---

<div align="left">

### 💬 **Need Help?**

- 📖 [Read the docs](https://github.com/wm-jenildgohel/share_my_apk#documentation)
- 🐛 [Report issues](https://github.com/wm-jenildgohel/share_my_apk/issues)
- 💡 [Request features](https://github.com/wm-jenildgohel/share_my_apk/discussions)
- ⭐ [Star on GitHub](https://github.com/wm-jenildgohel/share_my_apk)

</div>

---

<div align="center">

**Made with ❤️ for the Flutter community**

[![GitHub](https://img.shields.io/badge/GitHub-wm--jenildgohel-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/wm-jenildgohel)
[![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](LICENSE)

*Because sharing should be simple, not a chore* ✨

</div>