# Share My APK Example

This directory contains a simple example demonstrating how to use the `share_my_apk` package as a library in a Dart project.

## 🚀 Running the Example

To run the example, execute the following command from the root of the project:

```bash
dart run example/main.dart
```

This will build a release APK from the current Flutter project, organize it, and upload it to Gofile.io.

## 🔧 Customizing the Example

You can modify the `example/main.dart` file to test different scenarios, such as:

-   Building a debug APK by setting `release: false`.
-   Changing the `customName` and `environment` to see how the file organization works.
-   Switching the `provider` to `'diawi'` and providing a valid token.
