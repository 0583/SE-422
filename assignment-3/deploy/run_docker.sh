#!/usr/bin/env bash 

sudo docker run -d --restart=always -e DOMAIN=cluster --name k8example -p 5000:5000 yuxiqian/k8-example:latest

# Or: 
# kubectl run --image=yuxiqian/k8-example:latest k8example --port=5000 --env="DOMAIN=cluster"
# deployment "nginx-app" created