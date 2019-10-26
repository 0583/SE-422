# Apollo: Scalable and Coordinated Scheduling for Cloud-Scale Computing

## The tough nut to crack

Efficiently scheduling data-parallel computation jobs
over cloud-scale computing clusters with growing
cluster sizes and more complex workloads with diverse
characteristics.

### A deeper glimpse into the crux of the matter

1. Tremendous size of clusters, aggregating to more than 20000 servers each.
2. Very high peak rates of submit due to large amount of users.
3. Considerable Diversity in input volume, degree of parallelism, complexity of computation logic and resource requirement of jobs due to variety across users.

### A clearer peak to surmount
Implementing and deploying scheduler that is capable of

+ (i) scaling to make tens of thousands of scheduling decisions
per second on a cluster with tens of thousands of servers;

+ (ii) maintaining fair sharing of resources among different
users and groups; and 

+ (iii) making high-quality scheduling
decisions that take into account factors such as data local
ity,
job characteristics, and server load, to minimize job
latencies while utilizing the resources in a cluster fully.
## Authors' solution (in general)

Apollo, a highly scalable and coordinated scheduling framework,which has been deployed on production clusters at Microsoft
to schedule thousands of computations with millions of
tasks efficiently and effectively on tens of thousands of
machines daily.

## Key terminologies
### Task
>A task is a basic unit of compu
tation
that is scheduled to execute on a server.
### Stage
>Tasks that perform the same computation on different parti
tions of the same inputs are logically grouped together
in stages. The number of tasks per stage indicates the
degree of parallelism (DOP).
### Token
>Each token is defined as the right to execute a regular task, consuming up to a predefined
amount of CPU and memory, on a machine in the cluster.
### Job Manager
>Job Manager (JM), also called a scheduler, is assigned
to manage the life cycle of each job.
### Process Node(PN)
>A PN process running on each server is responsible for managing the local resources on that server and performing local scheduling
### Resource Monitor
>RM aggregates load information
from PNs across the cluster continuously, providing a
global view of the cluster status for each JM to make
informed scheduling decisions.
## Core techniques

### PN Queue and Wait-Time Matrix
+ The PN on each server manages a queue of tasks assigned
to the server in order to provide projections on
future resource availability.
+ The use of task queues enables schedulers to dispatch
tasks to the PNs proactively based on future resource
availability, instead of based on instantaneous availability.
+ The PN also provides feedback to the JM to help improve
accuracy of task runtime estimation.
+ The PN further exposes the load on the current server
to be aggregated by its RM by way of Wait-Time Matrix which is contructed based on the current running and queued tasks.
   1. A matrix is sent with timestamp to achieve real-time scheduling.
   2. Each cell corresponds to the expected wait time for a task that requires a certain amount of CPU and memory.

### Estimation-Based Scheduling
+ A JM has to decide which server to schedule a particular
task to using the wait-time matrices in the aggregated
view provided by the RM and the individual characteristics
of the task to be scheduled.

+ Factors taken into consideration when scheduling
   1. Initialization time for fetching the needed
files for the task
   2. Expected wait time, which comes from a lookup in the wait-time matrix of the target server with the task resource requirement.
   3. The task runtime, which consists of both I/O time and CPU time.
   4. The probability of task failure
+ Task Priorities decided according to directed acyclic graph of  job.
+ Stable Matching
   1. Apollo schedules tasks
with similar priorities in batches and turns the problem of
task scheduling into that of matching between tasks and
servers.
   2. Apollo limits the search space for a task to a candidate set ofservers, including (i) a set of servers on which inputs of significant sizes are located (ii) a set of servers in the same rack as those from the first group (iii) two servers randomly picked from a set of lightly-loaded servers; the list is curated in the background.
   3. A conflict arises when more than one task proposes to the same server. In this case, the server picks the task whose completion time saving is the greatest if it is assigned to the server.
   4. The scheduler then sorts all the matched pairs based on their quality to decide the dispatch order. A match is considered with a higher quality if its task has a lower server wait time.

### Correction Mechanisms

#### Apollo optimistically defers any correction until after tasks are dispatched to PN queues. This design choice is based on our observation that conflicts are not always harmful.

+ Duplicate Scheduling
   + The scheduler re-evaluates the decision if 
   + (i) the updated expected wait time is significantly higher than the original;
   + (ii) the expected wait time is greater than the average among the tasks in the same stage; 
   + (iii) the elapsed wait time is already greater than the average.
   + Any change in the decision triggers scheduling a duplicate task to a new desired server. Duplicates are discarded when one task starts.
+ Randomization
   + Apollo adds a
small random number to each completion time estima
tion.
This random factor helps reduce the chances of
conflicts by having different JMs choose different, al
most
equally desirable, servers.
+ Confidence
   + When the confidence in the wait-time matrix is low, the scheduler will produce a pessimistic estimate by looking up the wait time of a task consuming more CPU and memory.
+ Straggler Detection
   + When the time it would take to rerun a task is significantly less than the time it would take to let it complete, a duplicate copy is started.

### Opportunistic Scheduling

#### Two classes of tasks:
1. Rugular tasks
2. Opportunistic tasks

+ Randomized Allocation Mechanism
   + maximum opportunistic allowance for a given job proportionally to its token allocation
   + When a PN has spare capacity and the regular queue is empty, the PN picks a random task to execute from the opportunistic-task queue
   + Each scheduler is allowed to increase the weight of an opportunistic task during random selection, to compensate for the reduction in the number of tasks.
+ Task Upgrade
   + Because a job requires at least one token to run and there is a finit amount of tasks in a job, the scheduler is able to transition a starving opportunistic task to a regular task at one point, thus preventing job starvation.
   + When scheduling a regular task, the scheduler considers both unscheduled tasks and previously scheduled opportunistic tasks that still wait for execution.

## Evaluation
+ On average, the job latency improved around 22% with Apollo over the baseline scheduler
+ At the 95th percentile, the tasks show less than 1 second queuing time across the entire cluster
+ When the demand surges, Apollo makes use of all the available resources and only leaves a 3% gap between the 20th and the 80th percentiles of CPU
+ Over 95% tasks have a wait time estimation error of less than 1 second
+ For 75% of tasks, the CPU time predicted when the task is scheduled is within 25% of the actual CPU consumption.
+ However, with estimation enabled, Apollo achieves much more balanced scheduling across servers, which in turn leads to shorter task queuing latency.
+ Correction has 82% success rates, and accounts for less than 0.5% of task creations
+ the stable matching algorithm performs within 5% of the optimal matching under the simulated conditions where Each server has a single execution slot and have an expected wait time that is exponentially distributed with an average of 1. The expected runtime of each tasks is exponentially distributed
with an average of 1. Each task is randomly assigned a server preference and runs faster on the preferred server.

## My own thoughts
From this paper I would conclude that Apollo is a fine combination of ideas of both centralized and decentralized distributed system.

The difficulties of designing a distributed system surely encompass the question on what to integrate and what to separate. Apollo made a wise dicision by integrating information of the whole system while separating the task of making decisions.

In On Liberty by John Mill he mentioned that a good government should leave the various policital regions in a country autonomous while integrating information across the whole country to provide counsel for the different regions to reference so that they can decide what's best for themselves according to both their optimal awareness of their distinct interests and the government's comprehensive and detailed information. I see an analog system in Apollo. It also resembles GFS in the way that information is decoupled from control.

One other intriguing point to me is the way the designers view workloads and harm. While I may end up obsessed with locality for input, they realized that loading of executalbes can be a bigger threat. More over, locality is considered along with other factors in the end, further stressing the integity of the evaluation. The obeservation that conflicts are not always harming is also inspiring. I believe such knowledge mostly won't come from theory, but from practice. After all, it's when the system runs will you truly know whether your design works.