# SE-422

## Assignment #2

### Alibaba's Sigma System

Since Alibaba suffers from great network traffic every year, its system is also under great pressure. Furthermore, the traffic rush days are periodical: more requests will be made on the Double-eleven on-sale day. 

So that gives the "traffic controller" a chance to predict the traffic pressure and dynamically adjust the system in advance.

So Alibaba introduces its flexible scheduling system at ArchSummit: the Sigma.

#### Architecture

Alibaba opens its cluster data on its official GitHub repository since 2017. The architecture graph is also provided. Let's take a look:

This is the cluster-trace in 2017.

![2017 architecture graph](https://raw.githubusercontent.com/yuetsin/private-image-repo/master/2019/10/27/%5BE4956F47-3F71-478E-A922-7F243F72E195%5D%20sigma.png)

...and here's the 2018 version.

![2018 architecture graph](https://raw.githubusercontent.com/yuetsin/private-image-repo/master/2019/10/27/%5B91A368A6-E3D8-407F-9FD1-31C0EEF27B55%5D%20sigma-fuxi-collocation.jpg)

##### v2017

This graph indicates how "SigmaMaster" and "FuxiMaster" works altogether.

###### SigmaMaster

The first notable node would be the "SigmaMaster".

Like other distributed systems, Sigma also has a key node that manages all slave nodes' schedule. The master node's job is to create virtual environments as its need (maybe when it notices that there will be a requests storm soon).

But SigmaMaster won't directly manages the details of computing tasks. All these 'task create' jobs are completed via the daemon node: "SigmaAgent".

###### SigmaAgent

SigmaAgent doesn't know anything about the traffic scheduling information (since that's managed by SigmaMaster). It can call OCI-Standard compatible methods like `RunC`, `RunV`, and `RunLXC` to create computing tasks that SigmaMaster requires.

We may notice that the jobs we created are not equal. SigmaAgent creates the so-called "Prod Jobs", and the FuxiAgent creates the "Non-prod Jobs". That indicates an hierarchy.

###### Prod Jobs / Non-Prod Jobs

SigmaAgent usually works for the front service that requires instant response with low delay, and FuxiAgent is more like a background data managing and analysing system, which doesn't require such quick respond.

So when we introduces the priority strategy, we can make best use of the computing resources: On the rush hours, production jobs will take most of the computations and response quickly; on the plain hours those computing resources won't be wasted because of FuxiAgent creates lots of Non-prod Jobs to fill in these computing hours.

