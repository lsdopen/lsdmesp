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

kubectl create -f https://github.com/jetstack/cert-manager/releases/download/v1.16.2/cert-manager.yaml
echo "Sleeping a bit for cert-manager"
sleep 10
echo "Done!"
helm dependency update .
kubectl create ns lsdmesp
kubectl config set-context --current --namespace lsdmesp

kubectl create configmap cmf-keystore --from-file ./keystore.p12
kubectl create configmap cmf-truststore --from-file ./truststore.p12
kubectl create secret generic cmf-day2-tls --from-file=fullchain.pem=./lsdmesp.crt --from-file=privkey.pem=./lsdmesp.key --from-file=cacerts.pem=./ca.crt

helm install lsdmesp . -f ../../values.yaml -n lsdmesp

rm ./lsdmesp.crt
rm ./lsdmesp.key
rm ./lsdmesp.csr
rm ./truststore.p12
rm ./keystore.p12
rm ./ca.crt
rm ./ca.key
