#!/bin/bash

helm dependency update .
helm upgrade lsdmesp . -f ../../values-strimzi.yaml -n lsdmesp

