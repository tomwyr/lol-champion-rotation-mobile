import 'package:app_set_id/app_set_id.dart';
import 'package:http/http.dart';

import '../core/model/notifications.dart';
import '../core/model/rotation.dart';
import 'http.dart';

class AppApiClient {
  AppApiClient({
    required this.baseUrl,
    required this.appId,
  });

  final String baseUrl;
  final AppSetId appId;

  Future<ChampionRotation> currentRotation() async {
    return await _get("rotation/current").decode(ChampionRotation.fromJson);
  }

  Future<NotificationsSettings> notificationsSettings() async {
    return await _get("notifications/settings").decode(NotificationsSettings.fromJson);
  }

  Future<void> updateNotificationsSettings(NotificationsSettings settings) async {
    await _put("notifications/settings", body: settings.toJson());
  }

  Future<void> updateNotificationsToken(NotificationsTokenInput input) async {
    await _put("notifications/token", body: input.toJson());
  }

  Future<Response> _get(String path) async {
    return await get("$baseUrl/$path".uri, headers: await _headers());
  }

  Future<Response> _put(String path, {Object? body}) async {
    return await put("$baseUrl/$path".uri, headers: await _headers(), body: body);
  }

  Future<Map<String, String>> _headers() async {
    final deviceId = await appId.getIdentifier();
    if (deviceId == null) {
      throw AppApiClientError.unknownDeviceId;
    }

    return {'X-Device-Id': deviceId};
  }
}

enum AppApiClientError {
  unknownDeviceId,
}
