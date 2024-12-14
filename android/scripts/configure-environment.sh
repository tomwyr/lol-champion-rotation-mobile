#!/bin/bash

set -e

echo "$GOOGLE_AUTH_KEY" | base64 --decode > google_auth_key.json

echo "$KEYSTORE" | base64 --decode > app/keystore.jks

echo "keyAlias=upload" >> key.properties
echo "keyPassword=$KEY_PASSWORD" >> key.properties
echo "storeFile=keystore.jks" >> key.properties
echo "storePassword=$STORE_PASSWORD" >> key.properties
