import 'package:flutter/foundation.dart';

import '../data/services/error_service.dart';

ErrorService createErrorService() {
  if (kDebugMode) {
    return NoopErrorService();
  } else {
    return CrashlyticsErrorService(crashlytics: .instance);
  }
}
