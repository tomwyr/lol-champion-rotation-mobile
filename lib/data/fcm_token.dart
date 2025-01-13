import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FcmTokenService {
  FcmTokenService({
    required this.fcm,
    required this.sharedPrefs,
  });

  final FirebaseMessaging fcm;
  final SharedPreferencesAsync sharedPrefs;

  Future<bool> isSynced() async {
    return await sharedPrefs.getBool('FCM_TOKEN_SYNCED') == true;
  }

  Future<void> setSynced() async {
    await sharedPrefs.setBool('FCM_TOKEN_SYNCED', true);
  }

  Future<String> getToken() async {
    final token = await fcm.getToken();
    if (token == null) {
      throw FcmTokenError.tokenUnavailable;
    }
    return token;
  }

  Stream<String> get tokenChanged {
    return fcm.onTokenRefresh;
  }
}

enum FcmTokenError {
  tokenUnavailable,
}
