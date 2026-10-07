#!/bin/bash

docker buildx build --platform linux/amd64,linux/arm64 --push -f Dockerfile.1.2.0-kafka-4.3.1-cdc-iceberg-aws -t lsdtrip/kafka-connect:1.2.0-kafka-4.3.1 .

