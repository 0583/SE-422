#!/usr/bin/env bash 

go get github.com/julienschmidt/httprouter
echo "[+] github.com/julienschmidt/httprouter"

go get -u -v k8s.io/client-go/...
echo "[+] k8s.io/client-go"

cd $GOPATH/src/k8s.io/client-go
git checkout kubernetes-1.15.0