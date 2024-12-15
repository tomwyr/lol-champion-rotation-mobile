#!/bin/bash

set -e

cd ios

echo "$CERTIFICATE_P12" | base64 --decode > certificate.p12

echo "$PROVISIONING_PROFILE" | base64 --decode > profile.mobileprovision

echo "$EXPORT_OPTIONS" | base64 --decode > ExportOptions.plist
