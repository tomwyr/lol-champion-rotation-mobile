import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_launch_store/flutter_launch_store.dart';
import 'package:in_app_update/in_app_update.dart';

class AppStoreService {
  Future<UpdateStatus> checkUpdateStatus() async {
    if (!Platform.isAndroid) {
      return UpdateStatus.unknown;
    }

    final AppUpdateInfo info;
    try {
      info = await InAppUpdate.checkForUpdate();
    } on PlatformException {
      // Add logging to Sentry or similar.
      return UpdateStatus.unknown;
    }

    if (info.flexibleUpdateAllowed) {
      return UpdateStatus.available;
    } else {
      return UpdateStatus.unavailable;
    }
  }

  Future<UpdateResult> installUpdate() async {
    if (!Platform.isAndroid) {
      return UpdateResult.aborted;
    }

    try {
      final result = await InAppUpdate.startFlexibleUpdate();
      if (result == AppUpdateResult.success) {
        await InAppUpdate.completeFlexibleUpdate();
      }
      return UpdateResult.completed;
    } on PlatformException {
      // Add logging to Sentry or similar.
      return UpdateResult.failed;
    }
  }

  void openStorePage() async {
    const appId = 'com.tomwyr.lolChampionRotation';
    await StoreLauncher.openWithStore(appId);
  }
}

enum UpdateStatus {
  available,
  unavailable,
  unknown,
}

enum UpdateResult {
  aborted,
  completed,
  failed,
}
