#!/bin/bash

helm dependency update .
helm upgrade lsdmesp . -f ../../values-kind.yaml -n lsdmesp
