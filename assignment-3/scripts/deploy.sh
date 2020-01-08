# transfer
sudo apt-get update
sudo apt-get install lrzsz

# docker
curl -fsSL https://get.docker.com -o get-docker.sh
chmod +x get-docker.sh
./get-docker.sh

echo "docker installed"

# kube
sudo groupadd microk8s
curl https://raw.githubusercontent.com/ycheng/microk8s-kubeflow-install/master/microk8s-install.bash > microk8s-install.sh
chmod +x microk8s-install.sh
sudo ./microk8s-install.sh
sudo usermod -a -G microk8s ubuntu
microk8s.status --wait-ready

echo "microkube installed"
