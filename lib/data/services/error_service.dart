import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class ErrorService {
  ErrorService({required this.crashlytics});

  final FirebaseCrashlytics crashlytics;

  Future<void> runReporting(AsyncCallback body) async {
    try {
      await body();
    } catch (err, stack) {
      report(err, stack);
      rethrow;
    }
  }

  void report(Object error, StackTrace stackTrace) {
    crashlytics.recordError(error, stackTrace, fatal: true);
  }

  void setUpReportingErrors() {
    FlutterError.onError = (errorDetails) {
      crashlytics.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      crashlytics.recordError(error, stack, fatal: true);
      return true;
    };
  }
}
