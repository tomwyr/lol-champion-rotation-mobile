import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

abstract class ErrorService {
  void report(Object error, StackTrace stackTrace);
  void setUpReportingErrors();

  Future<void> runReporting(AsyncCallback body) async {
    try {
      await body();
    } catch (err, stack) {
      report(err, stack);
      rethrow;
    }
  }
}

class CrashlyticsErrorService extends ErrorService {
  CrashlyticsErrorService({required this.crashlytics});

  final FirebaseCrashlytics crashlytics;

  @override
  void report(Object error, StackTrace stackTrace) {
    crashlytics.recordError(error, stackTrace, fatal: true);
  }

  @override
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

class NoopErrorService extends ErrorService {
  @override
  void report(Object error, StackTrace stackTrace) {}

  @override
  void setUpReportingErrors() {}
}
