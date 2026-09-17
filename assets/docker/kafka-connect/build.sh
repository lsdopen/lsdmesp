#!/bin/bash

docker buildx build --platform linux/amd64,linux/arm64 --push -f Dockerfile.1.0.1-kafka-4.1.2-cdc-iceberg-aws -t rschamm/kafka-connect:1.0.1-kafka-4.1.2 .

