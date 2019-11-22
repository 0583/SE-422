#!/usr/bin/env bash

sudo apt-get update && sudo apt-get install -y apt-transport-https

sudo apt install docker.io

sudo systemctl start docker
sudo systemctl enable docker

echo "Done starting docker. If unit was masked, run ./fix_mask.sh to solve this."

sudo swapoff -a

sudo kubeadm init

