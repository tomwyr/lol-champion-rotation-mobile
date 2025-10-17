import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../data/services/error_service.dart';

ErrorService createErrorService() {
  if (kDebugMode) {
    return NoopErrorService();
  } else {
    return CrashlyticsErrorService(crashlytics: FirebaseCrashlytics.instance);
  }
}
