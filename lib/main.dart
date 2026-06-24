import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'common/app_config.dart';
import 'data/cache/data_cache.dart';
import 'dependencies/factories.dart';
import 'dependencies/locate.dart';
import 'dependencies/register.dart';
import 'ui/app/app_bootstrap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AppBootstrap(initialize: initializeApp));
}

Future<void> initializeApp() async {
  await Firebase.initializeApp();
  await setUpErrorHandling(() async {
    await AppConfig.initEnv();
    setUpDependencies();
    await setUpCache();
  });
}

Future<void> setUpErrorHandling(AsyncCallback initializeApp) async {
  final errorService = createErrorService();
  errorService.setUpReportingErrors();
  await errorService.runReporting(initializeApp);
}

Future<void> setUpCache() async {
  await locateUnique<DataCache>().initialize();
}
