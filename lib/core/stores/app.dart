import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppStore {
  final version = ValueNotifier('');

  void initialize() async {
    final info = await PackageInfo.fromPlatform();
    version.value = info.version;
  }
}
