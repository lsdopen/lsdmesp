#!/bin/bash

openssl genrsa -out $PROJECT_HOME/assets/credentials/mds-tokenkeypair.pem 2048

openssl rsa -in $PROJECT_HOME/assets/credentials/mds-tokenkeypair.pem -outform PEM -pubout -out $PROJECT_HOME/assets/credentials/mds-publickey.pem

openssl genrsa -out $PROJECT_HOME/assets/credentials/ca-key.pem 2048

openssl req -new -key $PROJECT_HOME/assets/credentials/ca-key.pem -x509 -days 3650 -out $PROJECT_HOME/assets/credentials/ca.pem -subj "/C=US/ST=CA/L=MountainView/O=Confluent/OU=Operator/CN=LocalCA"