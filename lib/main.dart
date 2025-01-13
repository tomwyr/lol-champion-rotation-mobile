import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'common/app_config.dart';
import 'dependencies.dart';
import 'ui/app.dart';

void main() async {
  await initializeConfigs();
  setUpDependencies();
  configureSystemUI();
  runApp(const App());
}

Future<void> initializeConfigs() async {
  await AppConfig.initEnv();
  await Firebase.initializeApp();
}

void configureSystemUI() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}
