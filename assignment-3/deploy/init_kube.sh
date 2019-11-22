#!/usr/bin/env bash 

sudo apt-get update && sudo apt-get install -y apt-transport-https

sudo apt install containerd docker.io

sudo systemctl start docker
sudo systemctl enable docker

sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add

echo "Now add `deb http://apt.kubernetes.io/ kubernetes-xenial main` into the /etc/apt/sources.list.d/kubernetes.list."

sleep 2

sudo nano /etc/apt/sources.list.d/kubernetes.list

echo "Done?"

sleep 1

sudo apt-get update

sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni
