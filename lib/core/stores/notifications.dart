import '../../data/api_client.dart';
import '../../data/fcm_notifications.dart';
import '../../data/fcm_token.dart';
import '../model/notifications.dart';

class NotificationsStore {
  NotificationsStore({
    required this.apiClient,
    required this.fcmToken,
    required this.fcmNotifications,
  });

  final AppApiClient apiClient;
  final FcmTokenService fcmToken;
  final FcmNotificationsService fcmNotifications;

  Stream<PushNotification> get notifications => fcmNotifications.notifications;

  void initialize() async {
    if (!await fcmToken.isSynced()) {
      await fcmToken.getToken().then(_syncTokenData);
      await fcmToken.setSynced();
    }
    fcmToken.tokenChanged.listen(_syncTokenData);
  }

  Future<void> _syncTokenData(String token) async {
    await apiClient.updateNotificationsToken(NotificationsTokenInput(token: token));
  }
}
