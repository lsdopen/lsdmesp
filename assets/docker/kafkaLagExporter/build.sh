#!/bin/bash

docker buildx build --platform linux/amd64,linux/arm64 --push -f Dockerfile -t lsdtrip/kafka-lag-exporter:latest .
