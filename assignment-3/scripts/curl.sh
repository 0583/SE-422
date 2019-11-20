#!/usr/bin/env bash 

curl -LO https://github.com/kubermatic/kubeone/releases/download/v0.10.0/kubeone_0.10.0_linux_amd64.zip

unzip kubeone_0.10.0_linux_amd64.zip

sudo mv kubeone /usr/local/bin