#!/bin/bash

echo "$KEYSTORE" | base64 --decode > keystore.jks
echo "keyAlias=$KEY_ALIAS" >> key.properties
echo "keyPassword=$KEY_PASSWORD" >> key.properties
echo "storeFile=keystore.jks" >> key.properties
echo "storePassword$STORE_PASSWORD=" >> key.properties
