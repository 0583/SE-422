
# Mesos

Mesos introduces a distributed two-level scheduling mechanism called **resource offers**. Mesos decides **how many** resources to offer each framework, while frameworks decide **which** resources to accept and which computations to run on them.

## Background and motivation


The solutions of choice to share a cluster today are either to statically partition the cluster and run one framework per partition, or allocate a set of VMs to each framework. Unfortunately, these solutions achieve neither high utilization nor efficient data sharing.

## Approach

### A new scheduling strategy: Delegating control

Mesos decides how many resources to offer each framework, based on an organizational policy such as fair sharing, while frameworks decide which resources to accept and which tasks to run on them.

## Advantages

* Even organizations that only use one framework can use Mesos to run multiple instances of that framework in the same cluster, or multiple versions of the framework.
* By providing a means of sharing resources across frameworks, Mesos allows framework developers to build specialized frameworks targeted at particular problem domains rather than one-size-fits-all abstractions. Frameworks can therefore evolve faster and provide better support for each problem domain.

## Architecture

### master / slaver

To support a diverse set of policies, the master employs a modular architecture that makes it easy to add new allocation modules via a pluggin mechanism. To make the master fault-tolerant, **ZooKeeper** is used to implement the failover mechanism.

A framework running on top of Mesos consists of two components: 
* a scheduler that registers with the master to be offered resources
* an executor process that is launched on slave nodes to run the framework’s tasks

## Evaluation

Mesos can achieve near-optimal data locality when sharing the cluster among diverse frameworks, can scale to 50,000 (emulated) nodes, and is resilient to failures.

## My Comment

* The goal of Mesos is to efficiently share hardware resources between different frameworks, while simplifying its own scheduling logic to make it as compatible and scalable as possible to ensure robustness in large-scale cluster environments.

* One problem with distributed scheduling systems is the lack of centralized global planning, which can lead to various non-optimal scheduling situations. For example, when a job of different sizes is mixed, the resource requirements of the small job may be quickly satisfied and continuously executed, and the resources of the large job are difficult to be satisfied and cannot be executed.

* Mesos is most suitable for tasks with short task duration and flexible resource requirements, such as MapReduce. For jobs that need to occupy a large number of resource types for a long time, non-global resource scheduling may be difficult to achieve optimal scheduling.