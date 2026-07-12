import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../common/theme.dart';

import 'app.dart';

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key, required this.initialize});

  final AsyncCallback initialize;

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  late final Future<void> _initialization = widget.initialize();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState != .done || snapshot.hasError) {
          return const AppLaunchBackground();
        }
        return const App();
      },
    );
  }
}

class AppLaunchBackground extends StatelessWidget {
  const AppLaunchBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    final color = switch (brightness) {
      .light => AppColors.lightBackground,
      .dark => AppColors.darkBackground,
    };
    return ColoredBox(color: color);
  }
}
