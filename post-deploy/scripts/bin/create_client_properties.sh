#!/bin/bash

KS_PASSWORD=changeit
USER_NAME=$1
ROOT_DIR=~/lsdmesp/post-deploy/scripts
KEY_PASSWORD=$(<$ROOT_DIR/mtls/$USER_NAME.password)
if [ $# -eq 1 ]
  then
    echo $KEY_PASSWORD
    echo "$ROOT_DIR/mtls/$USER_NAME-ca.crt"
    echo "$ROOT_DIR/config/kafka.$USER_NAME.truststore.jks"
    keytool -import -v -trustcacerts -alias FNBCA -file $ROOT_DIR/mtls/$USER_NAME-ca.crt -keystore $ROOT_DIR/config/kafka.$USER_NAME.truststore.jks -storepass $KS_PASSWORD -noprompt
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
