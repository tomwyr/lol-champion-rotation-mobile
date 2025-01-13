import 'package:firebase_messaging/firebase_messaging.dart';

import '../core/model/notifications.dart';

class FcmNotificationsService {
  FcmNotificationsService({
    required this.messages,
  });

  final Stream<RemoteMessage> messages;

  Stream<PushNotification> get notifications {
    return messages.map((message) {
      try {
        return PushNotification.fromJson(message.data);
      } catch (_) {
        // Add logging to Sentry or similar.
        throw FcmNotificationsError.unexpectedData;
      }
    });
  }
}

enum FcmNotificationsError {
  unexpectedData,
}
