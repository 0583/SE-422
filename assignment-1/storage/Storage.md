
# Ceph Storage

Ceph is a distributed file system that provides excellent performance, reliability, and scalability. Ceph maximizes the separation between data and metadata management by replacing allocation tables with a pseudorandom data distribution function (CRUSH) designed for heterogeneous and dynamic clusters of unreliable object storage devices (OSDs).

## Background and motivation


* Performance of file systems is critical to the overall performance of  applications.

* The centralization inherent in the C/S model is a significant obstacle to scalable performance.

* More recent distributed file systems have adopted architectures based on object-based storage.

## Features

### Excellent performance & reliability

Ceph decouples data and metadata operations by eliminating file allocation tables and replacing them with generating functions.
This allows Ceph to leverage the intelligence present in OSDs to distribute the complexity surrounding data access, update serialization, replication and reliability, failure detection, and recovery.

### Unparalleled scalability

Ceph utilizes a highly adaptive distributed metadata cluster architecture that dramatically improves the scalability of metadata access, and with it, the scalability of the entire system.

## Main components

![avatar](https://upload-images.jianshu.io/upload_images/13632999-eb098bd1e93bcaf4.png)

* **the client**, each instance of which exposes a near-POSIX file system interface to a host or process
* **a cluster of OSDs**, which collectively stores all data and metadata
* **a metadata server cluster**, which manages the namespace (file names and directories) while coordinating security, consistency and coherence

## Approach

* **Decoupled Data and Metadata**—Ceph maximizes the separation of file metadata management from the storage of file data.

* **Dynamic Distributed Metadata Management**——Ceph utilizes a novel metadata cluster architecture based on Dynamic Subtree Partitioning that adaptively and intelligently distributes responsibility for managing the file system directory hierarchy among tens or even hundreds of MDSs.

* **Reliable Autonomic Distributed Object Storage**——Large systems composed of many thousands of devices are inherently dynamic.

## Evaluation
> We evaluate our prototype under a range of microbenchmarks to demonstrate its performance, reliability, and scalability. In all tests, clients, OSDs, and MDSs are user processes running on a dual-processor Linux cluster with SCSI disks and communicating using TCP. In general, each OSD or MDS runs on its own host, while tens or hundreds of client instances may share the same host while generating workload.
    ——「Ceph: A Scalable, High-Performance Distributed File System》」



### Data Performance

#### 1. OSD Throughput
By measuring the I/O performance of a 14-node cluster of OSDs

#### 2. Write Latency

By measuring the synchronous write latency for a single writer with varying write sizes and replication

#### 3. Data Distribution and Scalability

### Metadata Performance

#### 1. Metadata Update Latency

#### 2. Metadata Read Latency

#### 3. Metadata Scaling

Evaluate metadata scalability using a 430 node partition of the alc Linux cluster at Lawrence Livermore National Laboratory (LLNL).


## Pros and Cons

### Pros

* Replication – In ceph storage, all the data are automatically copied from one node to another node. So even one node is failed it will work from other node automatically. So the data can be retried at any point of time. This is the great feature in cloud hosting.
* Protection – In ceph storage it uses erasure coded pools. It is a data protection mechanism where the data is broken into small fragments, encoded and stored in distributed manner. It provides additional data protection to uses.
* Thin provisioning – Ceph uses thin provisioning option to efficiently store the data. It make sure the storage space is not occupied until the data is saved.
* Open Source – It is a open source technology which will help many vendors to lower the cost in storage option.
* Unified Storage – Ceph offers technology to save all three types of storage like block storage, file storage and image storage. Hence it is highly flexible.

### Cons

* Very difficult to set up
* The I/O path is too long
* Business continuity will be affected




