import 'package:http/http.dart';

import '../core/model.dart';
import 'http.dart';

class RotationRepository {
  RotationRepository({required this.baseUrl});

  final String baseUrl;

  Future<ChampionRotation> currentRotation() async {
    try {
      return await get(Uri.parse(baseUrl)).decode(ChampionRotation.fromJson);
    } catch (_) {
      throw CurrentRotationError.unavailable;
    }
  }
}
