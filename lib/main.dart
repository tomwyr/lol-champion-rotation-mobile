import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'common/app_config.dart';
import 'dependencies/factories.dart';
import 'dependencies/register.dart';
import 'ui/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setUpErrorHandling(() async {
    await AppConfig.initEnv();
    setUpDependencies();
  });
  runApp(const App());
}

Future<void> setUpErrorHandling(AsyncCallback initializeApp) async {
  final errorService = createErrorService();
  errorService.setUpReportingErrors();
  await errorService.runReporting(initializeApp);
}
