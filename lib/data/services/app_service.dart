import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_launch_store/flutter_launch_store.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../common/app_assets.dart';
import '../../common/app_config.dart';
import '../../common/utils/changelog_parser.dart';

class AppService {
  AppService({required this.appConfig, required this.changelogParser});

  final AppConfig appConfig;
  final ChangelogParser changelogParser;

  Future<AppInfo> getAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return AppInfo(version: packageInfo.version, flavor: appConfig.flavor);
  }

  Future<Changelog> getAppChangelog() async {
    final changelogString = await rootBundle.loadString(AppAssets.changelog);
    return changelogParser.parse(changelogString);
  }

  Future<UpdateStatus> checkUpdateStatus() async {
    if (!Platform.isAndroid) {
      return .unknown;
    }

    final AppUpdateInfo info;
    try {
      info = await InAppUpdate.checkForUpdate();
    } on PlatformException {
      // Add logging to Sentry or similar.
      return .unknown;
    }

    if (info.flexibleUpdateAllowed) {
      return .available;
    } else {
      return .unavailable;
    }
  }

  Future<UpdateResult> installUpdate() async {
    if (!Platform.isAndroid) {
      return .aborted;
    }

    try {
      final result = await InAppUpdate.startFlexibleUpdate();
      if (result == .success) {
        await InAppUpdate.completeFlexibleUpdate();
      }
      return .completed;
    } on PlatformException {
      // Add logging to Sentry or similar.
      return .failed;
    }
  }

  void openStorePage() async {
    const appId = 'com.tomwyr.lolChampionRotation';
    await StoreLauncher.openWithStore(appId);
  }
}

class AppInfo {
  AppInfo({required this.version, required this.flavor});

  final String version;
  final AppFlavor flavor;
}

enum UpdateStatus { available, unavailable, unknown }

enum UpdateResult { aborted, completed, failed }
