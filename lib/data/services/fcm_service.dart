import 'package:async/async.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../core/model/notifications.dart';

class FcmService {
  FcmService({required this.messaging, required this.onMessage, required this.onMessageOpenedApp});

  final FirebaseMessaging messaging;
  final Stream<RemoteMessage> onMessage;
  final Stream<RemoteMessage> onMessageOpenedApp;

  Future<String> getToken() async {
    final token = await messaging.getToken();
    if (token == null) {
      throw FcmTokenError.tokenUnavailable;
    }
    return token;
  }

  Stream<String> get tokenChanged {
    return messaging.onTokenRefresh;
  }

  Stream<PushNotificationEvent> get notificationEvents {
    final initialMessage = Stream.fromFuture(messaging.getInitialMessage());
    return StreamGroup.merge([
      _processMessages(initialMessage, .launch),
      _processMessages(onMessageOpenedApp, .background),
      _processMessages(onMessage, .foreground),
    ]);
  }

  Stream<PushNotificationEvent> _processMessages(
    Stream<RemoteMessage?> stream,
    PushNotificationContext context,
  ) async* {
    await for (var message in stream) {
      if (message == null) continue;
      final notification = _messageToNotification(message);
      yield PushNotificationEvent(notification: notification, context: context);
    }
  }

  PushNotification _messageToNotification(RemoteMessage message) {
    try {
      final json = _mergeNotificationData(message);
      return .fromJson(json);
    } catch (_) {
      // Add logging to Sentry or similar.
      throw FcmNotificationError.unexpectedData;
    }
  }

  Map<String, dynamic> _mergeNotificationData(RemoteMessage message) {
    final payload = message.data;
    final notification = message.notification;

    if (payload case {'title': _} || {'body': _}) {
      // Log warning about title or body being overriden.
    }

    final title = notification?.title ?? '';
    final body = notification?.body ?? '';

    return {...payload, 'title': title, 'body': body};
  }
}

enum FcmTokenError { tokenUnavailable }

enum FcmNotificationError { unexpectedData }
