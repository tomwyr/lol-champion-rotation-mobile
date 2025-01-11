import 'package:flutter/widgets.dart';

import '../dependencies.dart';

class AppNotifications extends StatefulWidget {
  const AppNotifications({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<AppNotifications> createState() => _AppNotificationsState();
}

class _AppNotificationsState extends State<AppNotifications> {
  final store = notificationsStore();

  @override
  void initState() {
    super.initState();
    store.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
