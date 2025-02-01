import 'dart:async';

import 'package:flutter/material.dart';

import '../app.dart';

class EventsListener<T> extends StatefulWidget {
  const EventsListener({
    super.key,
    required this.events,
    required this.onEvent,
    required this.child,
  });

  final Stream<T> events;
  final void Function(T event, AppNotifications notifications) onEvent;
  final Widget child;

  @override
  State<EventsListener> createState() => _EventsListenerState();
}

class _EventsListenerState extends State<EventsListener> {
  late StreamSubscription subscription;

  AppNotifications get notifications => AppNotifications.of(context);

  @override
  void initState() {
    super.initState();
    subscription = widget.events.listen((event) => widget.onEvent(event, notifications));
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
