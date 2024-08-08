#!/bin/bash

kubectl get secret lsdmesp-cluster-ca-cert -ojsonpath='{.data.ca\.crt}' | base64 -d >./strimzi-ca.crt
kubectl get secret lsdmesp-tls -ojsonpath='{.data.ca\.crt}' | base64 -d >./lsdmesp-ca.crt
keytool -keystore truststore.p12 -import -v -trustcacerts -alias StrimziCA -file strimzi-ca.crt -storepass 112233 -noprompt
keytool -keystore truststore.p12 -import -v -trustcacerts -alias LSDMESPCA -file lsdmesp-ca.crt -storepass 112233 -noprompt

kubectl create secret generic lsdmesp-combined-ca --from-file=truststore.p12=truststore.p12 --from-literal=password=112233

rm ./truststore.p12
rm ./lsdmesp-ca.crt
rm ./strimzi-ca.crt