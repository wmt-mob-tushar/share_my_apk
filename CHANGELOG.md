## 1.0.0

*   **Breaking Change:** Replaced `snug_logger` with the standard `logging` package. This requires updating any direct usage of `snug_logger` in consuming applications.
*   **New Feature:** Added support for Gofile.io as an upload provider.
*   **New Feature:** Implemented automatic provider switching to Gofile.io if Diawi is selected and the APK size exceeds 70MB.
*   Updated `README.md` with new features, usage examples, and logging configuration.
*   Updated dependencies in `pubspec.yaml`.