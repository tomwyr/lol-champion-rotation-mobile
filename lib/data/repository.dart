import 'package:http/http.dart';

import '../core/model.dart';
import 'http.dart';

class RotationRepository {
  Future<ChampionRotation> currentRotation() async {
    const url = "https://lol-champion-rotation.fly.dev/api/rotation/current";
    try {
      return await get(Uri.parse(url)).decode(ChampionRotation.fromJson);
    } catch (_) {
      throw CurrentRotationError.unavailable;
    }
  }
}
