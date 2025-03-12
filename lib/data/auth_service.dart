import 'dart:convert';

import 'package:app_set_id/app_set_id.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService({
    required this.secretKey,
    required this.firebaseAuth,
    required this.appId,
  });

  final String secretKey;
  final FirebaseAuth firebaseAuth;
  final AppSetId appId;

  Future<String> authenticate() async {
    final user = await firebaseAuth.signInAnonymously();
    final accessToken = user.credential?.accessToken;
    if (accessToken == null) {
      throw AuthServiceError.firebaseTokenMissing;
    }
    final deviceId = await appId.getIdentifier();
    if (deviceId == null) {
      throw AuthServiceError.deviceIdMissing;
    }
    return _encodeToken(firebaseToken: accessToken, deviceId: deviceId);
  }

  String _encodeToken({required String firebaseToken, required String deviceId}) {
    final key = utf8.encode(secretKey);
    final data = utf8.encode(jsonEncode({
      'firebaseToken': firebaseToken,
      'deviceId': deviceId,
    }));
    final digest = Hmac(sha256, key).convert(data);
    return base64Encode(digest.bytes);
  }
}

enum AuthServiceError {
  firebaseTokenMissing,
  deviceIdMissing,
}
