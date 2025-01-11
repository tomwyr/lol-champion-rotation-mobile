import 'package:app_set_id/app_set_id.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FcmTokenService {
  FcmTokenService({
    required this.fcm,
    required this.appId,
    required this.sharedPrefs,
  });

  final FirebaseMessaging fcm;
  final AppSetId appId;
  final SharedPreferencesAsync sharedPrefs;

  Future<bool> isSynced() async {
    return await sharedPrefs.getBool('FCM_TOKEN_SYNCED') == true;
  }

  Future<void> setSynced() async {
    await sharedPrefs.setBool('FCM_TOKEN_SYNCED', true);
  }

  Future<FcmTokenData> getTokenData() async {
    return (
      deviceId: await _requireDeviceId(),
      token: await _requireToken(),
    );
  }

  Stream<FcmTokenData> get tokenDataChanged async* {
    await for (var token in fcm.onTokenRefresh) {
      yield (
        token: token,
        deviceId: await _requireDeviceId(),
      );
    }
  }

  Future<String> _requireToken() async {
    final token = await fcm.getToken();
    if (token == null) {
      throw FcmTokenError.tokenUnavailable;
    }
    return token;
  }

  Future<String> _requireDeviceId() async {
    final deviceId = await appId.getIdentifier();
    if (deviceId == null) {
      throw FcmTokenError.deviceIdUnknown;
    }
    return deviceId;
  }
}

typedef FcmTokenData = ({String deviceId, String token});

enum FcmTokenError {
  tokenUnavailable,
  deviceIdUnknown,
}
