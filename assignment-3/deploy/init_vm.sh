#!/usr/bin/env bash 

sudo snap install kubectl --classic

# AWS
export KUBERNETES_PROVIDER=aws; wget -q -O - https://get.k8s.io | bash

kubectl run k8s-example-node --image=yuxiqian/k8-example:latest --port=5000
kubectl get deployment k8s-example-node

kubectl scale deployment k8s-example-node --replicas=4
kubectl get deployment k8s-example-node

kubectl expose deployment k8s-example-node --type="LoadBalancer"
kubectl get services k8s-example-node

