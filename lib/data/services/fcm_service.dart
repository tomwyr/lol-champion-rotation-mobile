import 'package:firebase_messaging/firebase_messaging.dart';

import '../../core/model/notifications.dart';

class FcmService {
  FcmService({required this.messaging, required this.messages});

  final FirebaseMessaging messaging;
  final Stream<RemoteMessage> messages;

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

  Stream<PushNotification> get notifications {
    return messages.map((message) {
      try {
        return .fromJson(message.data);
      } catch (_) {
        // Add logging to Sentry or similar.
        throw FcmNotificationError.unexpectedData;
      }
    });
  }
}

enum FcmTokenError { tokenUnavailable }

enum FcmNotificationError { unexpectedData }
