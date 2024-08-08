#!/bin/bash

CURRENT_DIR="$(readlink -f $(dirname $(readlink -f $0)))"
PARENT_DIR="$(readlink -f $CURRENT_DIR/..)"

KS_PASSWORD=changeit
USER_NAME=$1
ROOT_DIR=$PARENT_DIR
KEY_PASSWORD=$(<$ROOT_DIR/mtls/$USER_NAME.password)
if [ $# -eq 1 ]
  then
    echo "$ROOT_DIR/mtls/$USER_NAME-ca.crt"
    if [ ! -f "$ROOT_DIR/mtls/$USER_NAME-ca.crt" ]; then
      echo "MISSING FILE   : $ROOT_DIR/mtls/$USER_NAME-ca.crt"
      exit 1
    fi
    echo "$ROOT_DIR/config/kafka.$USER_NAME.truststore.jks"

    if [ -f "$ROOT_DIR/config/kafka.$USER_NAME.truststore.jks" ]; then
      keytool -delete -alias LSDMESPCA -keystore $ROOT_DIR/config/kafka.$USER_NAME.truststore.jks -storepass $KS_PASSWORD -noprompt
    fi

    keytool -import -v -trustcacerts -alias LSDMESPCA -file $ROOT_DIR/mtls/$USER_NAME-ca.crt -keystore $ROOT_DIR/config/kafka.$USER_NAME.truststore.jks -storepass $KS_PASSWORD -noprompt
    openssl pkcs12 -inkey $ROOT_DIR/mtls/$USER_NAME.key -in $ROOT_DIR/mtls/$USER_NAME.crt -export -out $ROOT_DIR/config/$USER_NAME.p12 -password pass:$KEY_PASSWORD
    keytool -importkeystore -srckeystore $ROOT_DIR/config/$USER_NAME.p12 -srcstoretype pkcs12 -srcstorepass $KEY_PASSWORD -destkeystore $ROOT_DIR/config/kafka.$USER_NAME.keystore.jks -deststoretype jks -deststorepass $KS_PASSWORD

    rm $ROOT_DIR/config/$USER_NAME.p12
    cat >$ROOT_DIR/config/$USER_NAME.properties << EOF
security.protocol=SSL
ssl.truststore.location=$ROOT_DIR/config/kafka.$USER_NAME.truststore.jks
ssl.truststore.password=$KS_PASSWORD
ssl.keystore.location=$ROOT_DIR/config/kafka.$USER_NAME.keystore.jks
ssl.keystore.password=$KS_PASSWORD
ssl.key.password=$KEY_PASSWORD
EOF
fi
chmod 600 $ROOT_DIR/config/$USER_NAME.properties
