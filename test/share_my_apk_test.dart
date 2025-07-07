import 'package:flutter_test/flutter_test.dart';
import 'package:share_my_apk/share_my_apk.dart';

void main() {
  test('APK builder service initialization', () {
    final apkBuilder = ApkBuilderService();
    expect(apkBuilder, isNotNull);
  });
}
