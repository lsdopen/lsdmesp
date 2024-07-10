#!/bin/bash

USER_NAME=$1
if [ $# -eq 1 ]
  then
    kubectl -n lsdmesp get secret lsdmesp-tls -o=jsonpath='{.data.tls\.crt}' | base64 --decode >../mtls/$USER_NAME-ca.crt
    kubectl -n lsdmesp get secret $USER_NAME -o=jsonpath='{.data.user\.crt}' | base64 --decode >../mtls/$USER_NAME.crt
    kubectl -n lsdmesp get secret $USER_NAME -o=jsonpath='{.data.user\.key}' | base64 --decode >../mtls/$USER_NAME.key
    kubectl -n lsdmesp get secret $USER_NAME -o=jsonpath='{.data.user\.password}' | base64 --decode >../mtls/$USER_NAME.password
fi
