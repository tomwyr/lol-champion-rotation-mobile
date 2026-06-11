#!/bin/bash
set -euo pipefail

PLIST="ios/Runner/GoogleService-Info.plist"
UPLOAD_SYMBOLS="scripts/upload-symbols"
# Vendored from firebase-ios-sdk 12.14.0, revision 8d5b4189f1f482df8d5c58c9985ea70491ef5382:
# Crashlytics/upload-symbols.

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

if [[ ! -x "$UPLOAD_SYMBOLS" ]]; then
  echo "Firebase Crashlytics upload-symbols missing or not executable at $UPLOAD_SYMBOLS"
  exit 1
fi

"$UPLOAD_SYMBOLS" -gsp "$PLIST" -p ios "$DSYM"
