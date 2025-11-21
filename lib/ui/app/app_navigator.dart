import 'package:flutter/material.dart';

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key, required this.builder});

  final Widget Function(GlobalKey<NavigatorState> navigatorKey) builder;

  static NavigatorState of(BuildContext context) {
    final state = context.findAncestorStateOfType<_AppNavigatorState>();
    if (state == null) {
      throw FlutterError(
        'AppNavigator was requested with a context that does not contain a AppNavigator widget.',
      );
    }
    final navigator = state._navigatorKey.currentState;
    if (navigator == null) {
      throw FlutterError(
        'Global key used to obtain the navigator was not attached to a navigator state.',
      );
    }
    return navigator;
  }

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return widget.builder(_navigatorKey);
  }
}
