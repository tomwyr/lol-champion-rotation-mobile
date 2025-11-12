import 'package:dio/dio.dart';

import '../core/model/champion.dart';
import '../core/model/feedback.dart';
import '../core/model/notifications.dart';
import '../core/model/rotation.dart';
import '../core/model/user.dart';
import 'services/auth_service.dart';

class AppApiClient {
  AppApiClient({required this.dio, required this.authService});

  final Dio dio;
  final AuthService authService;

  Future<User> user() async {
    final response = await _get("/user");
    return .fromJson(response.data);
  }

  Future<ChampionRotationsOverview> rotationsOverview() async {
    final response = await _get("/rotations/overview");
    return .fromJson(response.data);
  }

  Future<ChampionRotationPrediction> predictRotation() async {
    final response = await _get("/rotations/predict");
    return .fromJson(response.data);
  }

  Future<ChampionRotationDetails> rotation({required String rotationId}) async {
    final response = await _get("/rotations/$rotationId");
    return .fromJson(response.data);
  }

  Future<ChampionRotation> nextRotation({required String token}) async {
    final response = await _get("/rotations?nextRotationToken=$token");
    return .fromJson(response.data);
  }

  Future<ChampionDetails> championDetails({required String championId}) async {
    final response = await _get("/champions/$championId");
    return .fromJson(response.data);
  }

  Future<void> observeChampion(String championId, ObserveChampionInput input) async {
    await _post("/champions/$championId/observe", data: input.toJson());
  }

  Future<ObservedChampionsData> observedChampions() async {
    final response = await _get("/champions/observed");
    return .fromJson(response.data);
  }

  Future<SearchChampionsResult> searchChampions({required String championName}) async {
    final response = await _get("/champions/search?name=$championName");
    return .fromJson(response.data);
  }

  Future<NotificationsSettings> notificationsSettings() async {
    final response = await _get("/notifications/settings");
    return .fromJson(response.data);
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
    final response = await _get("/rotations/observed");
    return .fromJson(response.data);
  }

  Future<void> addFeedback(UserFeedback feedback) async {
    await _post("/feedbacks", data: feedback.toJson());
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
