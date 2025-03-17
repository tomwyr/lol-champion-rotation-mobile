import 'package:dio/dio.dart';

import '../core/model/champion.dart';
import '../core/model/notifications.dart';
import '../core/model/rotation.dart';
import '../core/model/user.dart';
import 'services/auth_service.dart';

class AppApiClient {
  AppApiClient({
    required this.dio,
    required this.authService,
  });

  final Dio dio;
  final AuthService authService;

  Future<User> user() async {
    return await _get("/user").decode(User.fromJson);
  }

  Future<CurrentChampionRotation> currentRotation() async {
    return await _get("/rotations/current").decode(CurrentChampionRotation.fromJson);
  }

  Future<ChampionRotationPrediction> predictRotation() async {
    return await _get("/rotations/predict").decode(ChampionRotationPrediction.fromJson);
  }

  Future<ChampionRotationDetails> rotation({required String rotationId}) async {
    return await _get("/rotations/$rotationId").decode(ChampionRotationDetails.fromJson);
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

  Future<void> observeRotation(String rotationId, ObserveRotationInput input) async {
    await _post("/rotations/$rotationId/observe", data: input.toJson());
  }

  Future<ObservedRotationsData> observedRotations() async {
    return await _get("/rotations/observed").decode(ObservedRotationsData.fromJson);
  }

  Future<Response> _get(String path) async {
    return await dio.get(path, options: await _options());
  }

  Future<Response> _post(String path, {Object? data}) async {
    return await dio.post(path, options: await _options(), data: data);
  }

  Future<Response> _put(String path, {Object? data}) async {
    return await dio.put(path, options: await _options(), data: data);
  }

  Future<Options> _options() async {
    return Options(headers: await _headers());
  }

  Future<Map<String, String>> _headers() async {
    final accessToken = await authService.authenticate();
    return {'Authorization': 'Bearer $accessToken'};
  }
}

extension on Future<Response> {
  Future<T> decode<T>(T Function(Map<String, dynamic> json) fromJson) async {
    final response = await this;
    return fromJson(response.data);
  }
}
