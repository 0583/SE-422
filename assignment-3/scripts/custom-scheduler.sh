sed 's/a\/b:c/'$(echo "yuanzhuo/k8s-scheduler:v1.0" | sed 's/\//\\\//')'/' extender.yaml | kubectl apply -f -
kubectl create -f custom-deployment.yaml
kubectl create -f default-deployment.yaml
kubectl get nodes