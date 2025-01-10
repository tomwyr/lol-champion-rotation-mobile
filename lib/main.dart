import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config/app_config.dart';
import 'config/firebase_config.dart';
import 'ui/app.dart';

void main() async {
  await initializeConfigs();
  configureSystem();
  runApp(const App());
}

Future<void> initializeConfigs() async {
  final appConfig = await AppConfig.initEnv();
  await FirebaseConfig.initialize(appConfig);
}

void configureSystem() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}
