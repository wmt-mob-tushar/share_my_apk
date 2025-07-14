# Gemini Project Context

This file contains the context of the `share_my_apk` project, used by the Gemini AI to understand the project's structure and functionality.

## Project Overview

`share_my_apk` is a command-line tool and library for building and uploading Flutter Android APKs to various services like Diawi and Gofile.io. It simplifies the build and distribution process for developers.

## Key Features

-   **Build & Upload:** Seamlessly build your Flutter Android application and upload the generated APK.
-   **Multiple Providers:** Supports Diawi and Gofile.io, with automatic switching to Gofile.io for large files.
-   **Configuration:** Uses a `share_my_apk.yaml` file for project-specific configurations.
-   **Command-Line Interface:** Provides a user-friendly CLI with commands like `init` and `help`.
-   **Clean Output:** Provides clean, non-colored console output for better readability across various terminals.
-   **Customization:** Allows custom file naming, directory organization, and environment-based builds.
-   **Extensible Library:** The core services can be used as a library in other Dart projects.

## Main Components

### 1. `bin/share_my_apk.dart`

The main entry point for the command-line tool. It parses arguments, builds the APK, and uploads it. The CLI banner has been removed from this file.

### 2. `lib/src/utils/command_line`

-   **`arg_parser_util.dart`**: Handles command-line argument parsing.
-   **`help_util.dart`**: Displays the help message.
-   **`init_util.dart`**: Generates the `share_my_apk.yaml` configuration file.

### 3. `lib/src/services/build`

-   **`flutter_build_service.dart`**: Executes the `flutter build apk` command.
-   **`apk_parser_service.dart`**: Parses the build output to find the APK path.
-   **`apk_organizer_service.dart`**: Renames and moves the APK to its final destination.

### 4. `lib/src/services/upload`

-   **`upload_service.dart`**: An abstract base class for APK upload services.
-   **`diawi_upload_service.dart`**: Implementation of the `UploadService` for Diawi.
-   **`gofile_upload_service.dart`**: Implementation of the `UploadService` for Gofile.io.
-   **`upload_service_factory.dart`**: A factory for creating upload service instances.

### 5. `lib/src/services/config_service.dart`

Reads the `share_my_apk.yaml` configuration file to get default values for the command-line options.

### 6. `lib/src/models/cli_options.dart`

A data class that encapsulates all the configurable options for the command-line tool.

### 7. `lib/src/utils/console_logger.dart`

Handles console logging, now providing clean, non-colored output.

## How to Use

1.  **Initialize:** Run `share_my_apk --init` to generate a `share_my_apk.yaml` file.
2.  **Configure:** Edit the `share_my_apk.yaml` file to set your default options.
3.  **Run:** Execute `share_my_apk` to build and upload your APK.

This context will help me to provide more accurate and relevant assistance in the future.