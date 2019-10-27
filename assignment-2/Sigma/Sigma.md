# SE-422

## Assignment #2

### Alibaba's Sigma System

Since Alibaba suffers from great network traffic every year, its system is also under great pressure. Furthermore, the traffic rush days are periodical: more requests will be made on the Double-eleven on-sale day. 

So that gives the "traffic controller" a chance to predict the traffic pressure and dynamically adjust the system in advance.

So Alibaba introduces its flexible scheduling system at ArchSummit: the Sigma.

#### References

This article mainly references Alibaba's open source account.

Alibaba opens its cluster data on official GitHub repository since 2017. The architecture graph is also provided. Let's take a look:

#### Architecture

This is the cluster-trace in 2017.

![2017 architecture graph](https://raw.githubusercontent.com/yuetsin/private-image-repo/master/2019/10/27/%5BE4956F47-3F71-478E-A922-7F243F72E195%5D%20sigma.png)

...and here's the 2018 version.

![2018 architecture graph](https://raw.githubusercontent.com/yuetsin/private-image-repo/master/2019/10/27/%5B91A368A6-E3D8-407F-9FD1-31C0EEF27B55%5D%20sigma-fuxi-collocation.jpg)


These graphs indicates how "SigmaMaster" and "FuxiMaster" works altogether.

##### SigmaMaster

The first notable node would be the "SigmaMaster".

Like other distributed systems, Sigma also has a key node that manages all slave nodes' schedule. The master node's job is to create virtual environments as its need (maybe when it notices that there will be a requests storm soon).

But SigmaMaster won't directly manages the details of computing tasks. All these 'task create' jobs are completed via the daemon node: "SigmaAgent".

##### SigmaAgent

SigmaAgent doesn't know anything about the traffic scheduling information (since that's managed by SigmaMaster). It can call OCI-Standard compatible methods like `RunC`, `RunV`, and `RunLXC` to create computing tasks that SigmaMaster requires.

We may notice that the jobs we created are not equal. SigmaAgent creates the so-called "Prod Jobs", and the FuxiAgent creates the "Non-prod Jobs". That indicates an hierarchy.

##### Prod Jobs / Non-Prod Jobs

SigmaAgent usually works for the front service that requires instant response with low delay, and FuxiAgent is more like a background data managing and analysing system, which doesn't require such quick respond.

So when we introduces the priority strategy, we can make best use of the computing resources: On the rush hours, production jobs will take most of the computations and response quickly; on the plain hours those computing resources won't be wasted because of FuxiAgent creates lots of Non-prod Jobs to fill in these computing hours.

Here's a simple graph that tells out the main idea of Prod/Non-Prod strategies.

![Shape indicator](https://raw.githubusercontent.com/yuetsin/private-image-repo/master/2019/10/27/%5B7AF8C685-B40B-473D-8FEB-FD8F9A361DDE%5D%2087914a812c66482b54cf7f396f1f3faa.png)

##### Pouch

[Pouch](https://github.com/alibaba/pouch) is yet-another container technique brought by Alibaba based on Golang.

The main reason developing `Pouch` is that the hierarchy above still needs many "SigmaSlave" computers to do the computing tasks.

Initially "slaves" are directly executed on the physical machine, with great performance loss.

So you can see in v2018 architecture, SigmaAgent will send OCI Standardized command to PouchContainer Daemon, and Pouch will complete it in distributed ways.

#### Features

##### Flexible Schedule

As it is described above, Sigma + Fuxi system could work altogether perfectly, and make best use of the computing resources both on rush and plain hours. And jobs with priority could ensure that production requests will always get settled down first.

##### Isolation

Isolation is the key feature of Sigma system, which is also critical because of the Sigma + Fuxi combination workflow. If it didn't isolate them property, those background jobs might affect the production jobs.

* CPU Scheduling Isolation

It is mainly based on Linux CFS scheduling, but added the task preempt feature.

The preempt feature could help implements the assertion that production jobs will always goes above the non-production jobs, thus the system could handle the peek requests better.

* CPU Cache Isolation

Even the cache are differently treating. Production jobs could earn more chances to use the CPU cache, while those non-prod ones get less.

That feature is implemented via Intel's CAT (Cache Allocation Technology) technique.

* Memory Isolation

It mainly implemented by CGroup and OOM Priority, just like Docker did.

CGroup is a feature provided by Linux kernel. It could set resource usage limit to a group of processes and give every process group different, isolated virtual network, mounting point, etc.

OOM killer is also Linux kernel's feature. OOM means Out-of-Memory. The OOM killer will kill processes with low priority when the memory is inadequate.

##### P2P Mirror Distribution

Pouch container uses P2P technique to speed up the mirror distribution, which could easily ensures the consistency of different nodes at high speed.


#### Thoughts

Since Alibaba didn't open-source its Sigma implementation, all we can try is just its Pouch containerized feature.

The best thing is that it has considered the isolation very well because it is built for conbination deployment. And it uses many Linux kernel features to implement the isolation, which ensures the high-performance and compatibility.

The lower level implementation is nice-looking. Looking forward to seeing the full Sigma system, especially the higher scheduling level.