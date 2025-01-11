import 'package:http/http.dart';

import '../core/model/notifications.dart';
import '../core/model/rotation.dart';
import 'http.dart';

class AppApiClient {
  AppApiClient({required this.baseUrl});

  final String baseUrl;

  Future<ChampionRotation> currentRotation() async {
    final url = "$baseUrl/rotation/current".uri;
    return await get(url).decode(ChampionRotation.fromJson);
  }

  Future<void> updateNotificationsToken(NotificationsTokenInput input) async {
    final url = "$baseUrl/notifications/token".uri;
    await put(url, body: input.toJson());
  }
}
