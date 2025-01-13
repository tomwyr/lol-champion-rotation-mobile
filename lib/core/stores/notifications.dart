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
      final data = await fcmToken.getTokenData();
      await _syncTokenData(data);
      await fcmToken.setSynced();
    }
    await for (var data in fcmToken.tokenDataChanged) {
      await _syncTokenData(data);
    }
  }

  Future<void> _syncTokenData(FcmTokenData data) async {
    final input = NotificationsTokenInput(deviceId: data.deviceId, token: data.token);
    await apiClient.updateNotificationsToken(input);
  }
}
