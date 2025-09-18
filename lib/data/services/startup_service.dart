import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartupService {
  StartupService({required this.sharedPrefs});

  final SharedPreferencesAsync sharedPrefs;

  static const _firstRunKey = 'FIRST_RUN';

  Future<void> initialize({required AsyncCallback onFirstRun}) async {
    final firstRun = await sharedPrefs.getBool(_firstRunKey) ?? true;
    if (firstRun) {
      await onFirstRun();
    }
    await sharedPrefs.setBool(_firstRunKey, false);
  }
}
