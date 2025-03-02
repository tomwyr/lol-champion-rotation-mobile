import 'package:app_set_id/app_set_id.dart';
import 'package:dio/dio.dart';

import '../core/model/champion.dart';
import '../core/model/notifications.dart';
import '../core/model/rotation.dart';
import '../core/model/user.dart';

class AppApiClient {
  AppApiClient({
    required this.dio,
    required this.appId,
  });

  final Dio dio;
  final AppSetId appId;

  Future<User> user() async {
    return await _get("/user").decode(User.fromJson);
  }

  Future<CurrentChampionRotation> currentRotation() async {
    return await _get("/rotations/current").decode(CurrentChampionRotation.fromJson);
  }

  Future<ChampionRotation> nextRotation({required String token}) async {
    return await _get("/rotations?nextRotationToken=$token").decode(ChampionRotation.fromJson);
  }

  Future<ChampionDetails> championDetails({required String championId}) async {
    return await _get("/champions/$championId").decode(ChampionDetails.fromJson);
  }

  Future<SearchChampionsResult> searchChampions({required String championName}) async {
    return await _get("/champions/search?name=$championName")
        .decode(SearchChampionsResult.fromJson);
  }

  Future<NotificationsSettings> notificationsSettings() async {
    return await _get("/notifications/settings").decode(NotificationsSettings.fromJson);
  }

  Future<void> updateNotificationsSettings(NotificationsSettings settings) async {
    await _put("/notifications/settings", data: settings.toJson());
  }

  Future<void> updateNotificationsToken(NotificationsTokenInput input) async {
    await _put("/notifications/token", data: input.toJson());
  }

  Future<Response> _get(String path) async {
    return await dio.get(path, options: await _options());
  }

  Future<Response> _put(String path, {Object? data}) async {
    return await dio.put(path, options: await _options(), data: data);
  }

  Future<Options> _options() async {
    return Options(headers: await _headers());
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

extension on Future<Response> {
  Future<T> decode<T>(T Function(Map<String, dynamic> json) fromJson) async {
    final response = await this;
    return fromJson(response.data);
  }
}
