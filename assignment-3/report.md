# Report for HW3
## Preps on Environment
We ran a shell script to set up a microk8s on 4 servers applied on aws.
```
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
```
Then for three times we ran "microk8s add-node" on master node to get a token each time and ran "microk8s join" command with one of the three tokens on each slave node to build up the cluster.
## Default Scheduler
We configured the default scheduler with a .json file,
```
{
"kind" : "Policy",
"apiVersion" : "v1",
"predicates" : [
	{"name" : "PodFitsHostPorts"},
	{"name" : "PodFitsResources"},
	{"name" : "NoDiskConflict"},
	{"name" : "NoVolumeZoneConflict"},
	{"name" : "MatchNodeSelector"},
	{"name" : "HostName"}
	],
"priorities" : [
	{"name" : "LeastRequestedPriority", "weight" : 1},
	{"name" : "BalancedResourceAllocation", "weight" : 1},
	{"name" : "ServiceSpreadingPriority", "weight" : 1},
	{"name" : "EqualPriority", "weight" : 1}
	],
"hardPodAffinitySymmetricWeight" : 10,
"alwaysCheckAllPredicates" : false
}
```

And loaded it by adding the following two lines of configuration to ${SNAP_DATA}/args/kube-scheduler,
```
--use-legacy-policy-config=true
--policy-config-file=${SNAP_DATA}/args/scheduler-policy-config.json
```
and restarting the service.
```
echo '-l=debug' | sudo tee -a /var/snap/microk8s/current/args/containerd
sudo systemctl restart snap.microk8s.daemon-scheduler.service
```
## Customized Scheduler
We referred to the repository at https://github.com/everpeace/k8s-scheduler-extender-example to complete this part. Our work was done as the following steps:

### 0. checkout the repo

```shell
$ git clone git@github.com:everpeace/k8s-scheduler-extender-example.git
$ cd k8s-scheduler-extender-example
$ git submodule update --init
```

### 1. buid a docker image

```
$ IMAGE=yuanzhuo/k8s-scheduler:v1.0

$ docker build . -t "${IMAGE}"
$ docker push "${IMAGE}"
```

### 2. deploy `my-scheduler` in `kube-system` namespace
```
# bring up the kube-scheduler along with the extender image you've just built
$ sed 's/a\/b:c/'$(echo "yuanzhuo/k8s-scheduler:v1.0" | sed 's/\//\\\//')'/' extender.yaml | kubectl apply -f -
```

For ease of observation, start streaming logs from the extender:

```console
$ kubectl -n kube-system logs deploy/my-scheduler -c my-scheduler-extender-ctr -f
[  warn ] 2018/11/07 08:41:40 main.go:84: LOG_LEVEL="" is empty or invalid, fallling back to "INFO".
[  info ] 2018/11/07 08:41:40 main.go:98: Log level was set to INFO
[  info ] 2018/11/07 08:41:40 main.go:116: server starting on the port :80
```

## Comparison
We deployed three pods scheduled by the default scheduler and three by customized scheduler
The yamls are as follow:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment-custom
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2
  template:
    metadata:
      labels:
        app: nginx
    spec:
      hostNetwork: true
      schedulerName: my-scheduler
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
```

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment-default
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2
  template:
    metadata:
      labels:
        app: nginx
    spec:
      hostNetwork: true
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
```

![f](./1.jpg)
As can be observed from the output in shell, all of the pods scheduled by our customized scheduler are running and one is pending.

## Test
### Predicates
We put "PodFitsHostResources" at the first place, ran five pods (their .yaml files in the testing directory), and derived the following results: 
![pri](./predicate.jpg)

### Priority
We changed the weight of EqualPriority to 10, ran five pods, and derived the following results:
![pre](./priority.jpg)
