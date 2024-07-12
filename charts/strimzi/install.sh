#!/bin/bash

openssl genrsa -out ca.key 2048
openssl req -new -key ca.key -x509 -days 3650 -out ca.crt -subj "/C=ZA/ST=GP/L=Johannesburg/O=io.strimzi/OU=Operator/CN=LocalCA"
openssl x509 -in ca.crt -noout -text

keytool -keystore keystore.p12 -alias lsdmesp -keyalg RSA -validity 3650 -genkey -storepass 112233 -keypass 112233 -dname "CN=lsdmesp"
keytool -keystore keystore.p12 -alias lsdmesp -certreq -file lsdmesp.csr -storepass 112233
openssl x509 -req -CA ca.crt -CAkey ca.key -in lsdmesp.csr -out lsdmesp.crt -days 3650 -set_serial "01" -extfile lsdmesp-sans.conf -passin pass:112233 -extensions 'v3_req'
openssl pkcs12 -in keystore.p12 -nodes -nocerts -out lsdmesp.key -password pass:112233
keytool -keystore keystore.p12 -alias CARoot -importcert -file ca.crt -storepass 112233 -noprompt
keytool -keystore keystore.p12 -alias lsdmesp -importcert -file lsdmesp.crt -storepass 112233 -noprompt
keytool -keystore truststore.p12 -alias CARoot -importcert -file ca.crt -storepass 112233 -noprompt

kubectl label node kind-worker accept-pod=lsdmesp-broker-0
kubectl label node kind-worker2 accept-pod=lsdmesp-broker-1
kubectl label node kind-worker3 accept-pod=lsdmesp-broker-2

helm dependency update .
kubectl create ns lsdmesp
kubectl config set-context --current --namespace lsdmesp
kubectl create secret generic lsdmesp-tls --from-file=ca.crt=ca.crt --from-file=tls.crt=lsdmesp.crt --from-file=tls.key=lsdmesp.key --from-file=keystore.p12=keystore.p12 --from-file=truststore.p12=truststore.p12 --from-literal=password=112233 --from-literal=jksPassword.txt=jksPassword=112233
helm install lsdmesp . -f ../../values-strimzi.yaml -n lsdmesp

rm ./lsdmesp.crt
rm ./lsdmesp.key
rm ./lsdmesp.csr
rm ./truststore.p12
rm ./keystore.p12
rm ./ca.crt
rm ./ca.key
