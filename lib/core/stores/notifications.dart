import '../../data/api_client.dart';
import '../../data/fcm_token.dart';
import '../model/notifications.dart';

class NotificationsStore {
  NotificationsStore({
    required this.apiClient,
    required this.fcmToken,
  });

  final AppApiClient apiClient;
  final FcmTokenService fcmToken;

  void initialize() async {
    if (!await fcmToken.isSynced()) {
      final token = await fcmToken.getToken();
      await _syncTokenData(token);
      await fcmToken.setSynced();
    }
    await for (var token in fcmToken.tokenChanged) {
      await _syncTokenData(token);
    }
  }

  Future<void> _syncTokenData(String token) async {
    await apiClient.updateNotificationsToken(NotificationsTokenInput(token: token));
  }
}
