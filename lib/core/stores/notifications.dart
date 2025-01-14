import '../../data/api_client.dart';
import '../../data/fcm_token.dart';
import '../model/notifications.dart';

class NotificationsStore {
  NotificationsStore({
    required this.apiClient,
    required this.fcm,
  });

  final AppApiClient apiClient;
  final FcmService fcm;

  Stream<PushNotification> get notifications => fcm.notifications;

  void initialize() async {
    final user = await apiClient.user();
    if (!user.notificationsTokenSynced) {
      await fcm.getToken().then(_syncTokenData);
    }
    fcm.tokenChanged.listen(_syncTokenData);
  }

  Future<void> _syncTokenData(String token) async {
    await apiClient.updateNotificationsToken(NotificationsTokenInput(token: token));
  }
}
