## KubeVirt Speech(@yzhao)

* Firstly, thank you for all attending.

* Today, I will give a simple presentation about the new project "KubeVirt" which develop owner is fabiand.

* The agenda is:
 * first is Kubernetes
 * second is KubeVirt(virtualization extension for kubernetes)
 * Third is demo for KubeVirt

 ### * OK, first， what is Kubernetes?
 *kubernetes is creating by Google, based on google Borg system(Borg system is a based on container, large-scale cluster management system，kubernetes borrowed its experience). Also, it is an open source system for managing containerized applications and its code hosted on Github. [KubeVirt](https://github.com/kubevirt/kubevirt)

 * Due to kubernetes based on docker and its souce code written by Golang , so kubernetes
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
     * The `etcd` is a HA(highly-available) storage system. Be used to persist all resource objects in the storage cluster, for example: node, service, pod, RC, namespace.

     * The `apiserver` provides the only operations of the resource objects entry, all other componments must be provided by the API to operate the resource data. the apiserver mainly processes REST operations, validates them, and updates the corresponding objects in etcd.

     * `Controller-manager`, the kubernetes cluster management and control centre, the main purpose is to realize the automation of fault detection and recovery. such as copying and deleting pods according the definition. according to service and pods management of the relationship, finish the service to create and update the endpoints; node discovery,management,status monitoring, local cache of the image file cleanup.

     * `Scheduler`, automatically chooses hosts to run the pod(containers) on.
     You can define the pod run on the specified host via add the labels.

   * On the node host, there are the kubelet, proxy, container time componments.
     * `Kubelet`, is responsible for the node to create, modify, monitor, delete and other lifecycle management, while kubelet regularly reported the status of the node information to the API Server.

     * `Container time`, each node will run a container time ,which is responsible for downloading images and running containers.

     * `Proxy`, the implementation of the service agent and software load balancer. for example, create a virtual IP which clients can access and which is transparently proxied to the pods in a service. Or via iptables rules to trap access to the service IPs and redirect them to the correct backends. So this provides a highly-available load-balancing solution with low performance overhead by balancing client traffic  on that same node.  

  * OK, let's start deploying the install  about kubernetes. Now, I will deploy the kubernetes cluster monitoring system. Heapster+InfluxDB+Grafana

     * heapster: collect the cluster pods, nodes resource via cAdvisor, then save them to the backends storage system, it support memory, InfluxDB, BigQuery, Google Cloud Monitoring...

     * InfluxDB: use to store real-time data acquisition,event tracking records, storage time charts, raw data..

     * Grafana: display data graphically

  * http://10.66.8.213:30001
  This is the kubernetes-dashboard, offical kubernetes UI.There are namespace, nodes, deployment,services, RC, jobs, pods, secrets...

  * http://10.66.8.213:4194
  This is the cAdvisor, the default software about monitoring the containers status.


  * I will deploy the kubernetes cluster monitor instance. It can show the performance about the cluster,pods, nodes...with picture. Then, access http://10.66.8.159:30081 This is the monitor to draw the picture about cpu, memory, network of  cluster and pods or others.

  * use the cmd `kubectl patch node node-name -p '{ "spec":{"unschedulable":true}}'` to put this node unschedulable status.Then, the pods don't schedule on this node later.

### * Next, what is the KubeVirt? why need KubeVirt?

* *** mindmap: https://coggle.it/diagram/WOxCliPVCgABogpZ ***

* *** The virtualization extension for kubernetes ***

* *** A virtual machine management add-on for kubernetes, the aim to provide a common ground for virtualization solutions on top of kubernetes.***

* *** It's core KubeVirt extends kubernetes by adding additional virtualization resource type(`VM` type), and use the kubernetes API to manage these VM resources alongside all other resources kubernetes provides.***

* *** But these resources themselves are not enough to laungh virtual machine, so should run additional controller and agents on an existing cluster. These controllers and agents are provided by KubeVirt. ***

* *** Use cockpit to monitor and manage resources, also include VM***

### *** KubeVirt componment :***

* virt-api-server:provide the KubeVirt entry, the virt-api-server mainly take care to update the virtualization related the third party resources about VM.

* VM: The VM definition is defining all properties of the virtual machine itself,
for example: machine type, cpu type, number and type of NICs...

* virt-controller: monitor the VM and manage the associated pods, and make sure to create and manage the lifecycle of pods associated to the VM objects.

* virt-launcher: To a VM, it will have a pod to run the virt-launcher,like "virt-launcher-testvm" , the main purpose of the vm-launch is to provide the cgroups and namespaces,which will be used to host the VM process.

* virt-handler: every host need a single instance of `virt-handler`, it can be delivered as a DaemonSet. It will also watch for changes of the VM object, once detected it will perform all necessary operations to change a VM to meet the required state.
The main areas which `virt-handler` has to cover are:
     * keep a cluster-level VM spec in sysc with a libvirt domain on its host.
     * report domain state and spec changes to the cluster.
     * Invoke node-centric plugins which can fulfill networking and storage requirements defined in VM spec.
* libvirtd: be responsible for managing the VM process.

* storage--strorge controller,   networking--network controller: just provide a VM with storage type  and network type; Planning in process.


### * Now , i will give a example about KubeVirt.

* Cockpit : `10.66.8.254:9090(`pods and containers)
* cockpit about VMs: `10.66.8.254:30010`

### Flow:
* ###### Now
  * Create a predefined VM
  * Schedule a VM on Kubernetes cluster
  * Launch a VM
  * Stop a VM
  * Delete a VM

* ##### process
  * The client tool creates a predefined VM, posts it to the K8S API Server.

  * K8S API Server validates the input and create a VM resource, and `virt-api-server` validates the VM TPR(the party resource)

  * The `virt-controller` observes the new VM objects and creates a corresponding pod.

  * K8S schedule the pod on a designated
host.

  * The `virt-handler` observes the VM pod `virt-launch-testvm` got assigned to the host ,then use the VM Specification and creates a corresponding domain using the local `libvirtd`.

  * The client tool deletes the VM objetc through the `virt-api-server`

  * The `virt-handler` observes the VM objects deletion and turns off the domain.

### Any questions?
*** yzhao@redhat.com ***
