import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'common/app_config.dart';
import 'dependencies.dart';
import 'ui/app/app.dart';

void main() async {
  await initializeConfigs();
  setUpDependencies();
  runApp(const App());
}

Future<void> initializeConfigs() async {
  await AppConfig.initEnv();
  await Firebase.initializeApp();
}
