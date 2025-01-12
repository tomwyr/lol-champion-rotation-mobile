import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config/app_config.dart';
import 'ui/app.dart';

void main() async {
  await initializeConfigs();
  configureSystem();
  runApp(const App());
}

Future<void> initializeConfigs() async {
  await AppConfig.initEnv();
  await Firebase.initializeApp();
}

void configureSystem() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}
