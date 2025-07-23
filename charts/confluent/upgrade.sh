#!/bin/bash

helm dependency update .
helm upgrade lsdmesp . -f ../../values.yaml -n lsdmesp
