#!/usr/bin/env bash 

sudo systemctl unmask docker.service
sudo systemctl unmask docker.socket
sudo systemctl start docker.service
