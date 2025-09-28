import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../data/services/error_service.dart';

ErrorService createErrorService() {
  return ErrorService(crashlytics: FirebaseCrashlytics.instance);
}
