#!/usr/bin/env bash 

docker pull yuxiqian/k8-example:latest

docker run -p 5000:5000 yuxiqian/k8-example:latest
