#!/bin/bash
set -euo pipefail

PLIST="ios/Runner/GoogleService-Info.plist"
if [[ ! -f "$PLIST" ]]; then
  echo "GoogleService-Info.plist missing"
  exit 1
fi

if [[ "$FLAVOR" == "development" ]]; then
  DSYM="build/ios/Release-development-iphoneos/Runner.app.dSYM"
elif [[ "$FLAVOR" == "production" ]]; then
  DSYM="build/ios/archive/Runner.xcarchive/dSYMs/Runner.app.dSYM"
else
  echo "Unknown FLAVOR '$FLAVOR'"
  exit 1
fi

if [[ ! -d "$DSYM" ]]; then
  echo "Runner.app.dSYM not found at $DSYM"
  exit 0
fi

ios/Pods/FirebaseCrashlytics/upload-symbols -gsp "$PLIST" -p ios "$DSYM"
