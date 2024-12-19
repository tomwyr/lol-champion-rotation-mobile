import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_config.dart';
import 'ui/app.dart';

void main() async {
  await AppConfig.initEnv();
  configureSystem();
  runApp(const App());
}

void configureSystem() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}
