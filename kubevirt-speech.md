## KubeVirt Speech(@yzhao)

* Firstly, thank you for all attending.

* Today, I will give a simple presentation about the new project "KubeVirt" which develop owner is fabiand.

* The agenda is:
 * first is Kubernetes
 * second is KubeVirt(extendation for kubernetes)
 * Third is demo for Kubevirt

 ### OK, first， what is Kubernetes?
 * kubernetes is creating by Google, based on google Borg system(Borg system is a based on container, large-scale cluster management system，kubernetes borrowed its experience). Also, it is an open source system for managing containerized applications and its code hosted on Github. [KubeVirt](https://github.com/kubevirt/kubevirt)

 * Due to based on docker and its souce code written by Golang , so kubernetes
 deployment need Go and docker environment.

 * OK, let's view its componments and architecture.
   * Ok, firstly, we should know some main objects about Kubernetes.

      * ***pod: the basic building block of kubernetes---the smallest and simplest unit in the kubernetes object model that you can create or deploy. The pod represents a running process on your cluster. and the pod can run a single container or run multiple containers that need to work together. The multiple containers run as a pod , will share resources and dependencies,communicate with one another ,and coordinate when and how they are terminated.***

      * *** ***

      * ***RC(replication controller): define a specified number of the pod "replicas" are running at any time. for example, if there are some pods dead, the RC will automatically re-created according to the definition of the specified number.***

      * *** ***

      * ***Service: a set of external access interfaces that provide the same service pods.***

      * *** ***

   * The kubernetes cluster is consist of the master and node. So, some componments must be run on the master,and some must be run on the node.

   * On the master host,there are  the etcd,apiserver,scheduler,controller-manager componments .
     * The `etcd` is a HA(highly available) storage system. Be used to persist all resource objects in the storage cluster, for example: node, service, pod, RC, namespace.

     * The `apiserver` provides the only operations of the resource objects entry, all other componments must be provided by the API to operate the resource data. the apiserver mainly processes REST operations, validates them, and updates the corresponding objects in etcd.

     * `Controller-manager`, the kubernetes cluster management and control centre, the main purpose is to realize the automation of fault detection and recovery. such as copying and deleting pods according the definition. according to service and pods management of the relationship, finish the service to create and update the endpoints; node discovery,management,status monitoring, local cache of the image file cleanup.

     * `Scheduler`, automatically chooses hosts to run the pod(containers) on.
     You can define the pod run on the specified host via add the labels.

   * On the node host, there are the kubelet, proxy, container time componments.
     * `Kubelet`, is responsible for the node to create, modify, monitor, delete and other lifecycle management, while kubelet regularly reported the status of the node information to the API Server.

     * `Container time`, each node will run a container time ,which is responsible for downloading imnages and running containers.

     * `Proxy`, the implementation of the service agent and software load balancer. for example, create a virtual IP which clients can access and which is transparently proxied to the pods in a service. Or via iptables rules to trap access to the service IPs and redirect them to the correct backends. So this provides a highly-available load-balancing solution with low performance overhead by balancing client traffic  on that same node.  

  * OK, let's give a presentation about kubernetes.

  * http://10.66.8.213:30001
  This is the kubernetes-dashboard.

  * http://10.66.8.213:4194
  This is the cAdvisor

  *  
