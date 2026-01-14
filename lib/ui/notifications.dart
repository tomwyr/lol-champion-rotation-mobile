import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/application/notifications/notifications_cubit.dart';
import '../core/application/notifications/notifications_state.dart';
import '../core/events.dart';
import '../core/model/notifications.dart';
import 'app/app_notifications.dart';
import 'champion_details/champion_details_page.dart';
import 'rotation_list/rotation_list_page.dart';

class NotificationsInitializer extends StatefulWidget {
  const NotificationsInitializer({super.key, required this.appEvents, required this.child});

  final AppEvents appEvents;
  final Widget child;

  @override
  State<NotificationsInitializer> createState() => NotificationsInitializerState();
}

class NotificationsInitializerState extends State<NotificationsInitializer> {
  late StreamSubscription notificationsSubscription;
  late StreamSubscription eventsSubscription;

  AppNotificationsState get notifications => AppNotifications.of(context);

  @override
  void initState() {
    super.initState();
    final cubit = context.read<NotificationsCubit>();
    notificationsSubscription = cubit.notifications.listen(_onNotification);
    eventsSubscription = cubit.events.stream.listen(_onEvent);
    cubit.initialize();
  }

  @override
  void dispose() {
    eventsSubscription.cancel();
    notificationsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _onNotification(PushNotificationEvent event) {
    final notification = event.notification;

    switch (notification) {
      case ChampionReleasedNotification(:var championId):
        void showChampionDetails() {
          ChampionDetailsPage.replaceAll(context, championId: championId);
        }

        if (event.context case .foreground) {
          notifications.showInfo(message: notification.body, onTap: showChampionDetails);
        } else {
          showChampionDetails();
        }

      case RotationChangedNotification():
        if (event.context case .foreground) {
          notifications.showInfo(
            message: notification.body,
            onTap: () => RotationListPage.showCurrent(context),
          );
        }
        if (event.context case .background || .foreground) {
          widget.appEvents.currentRotationChanged.notify();
        }

      case _:
    }
  }

  void _onEvent(NotificationsEvent event) {
    switch (event) {
      case .initializationFailed:
        notifications.showError(
          message: 'Failed to initialize notifications. Some features may not work properly.',
        );
      case .permissionDesynced:
        notifications.showWarning(
          message: 'Grant permission in the system settings to receive notifications.',
        );
    }
  }
}
