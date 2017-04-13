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
   * The kubernetes cluster is consist of the master and node. So, some componments must be run on the master,and some must be run on the node.

   * On the master host,there are  the etcd,apiserver,scheduler,controller-manager componments .
     * The etcd is a HA(highly available) storage system. Be used to persist all resource objects in the storage cluster, for example: node, service, pod, RC, namespace.

     * The apiserver provides the only operations of the resource objects entry, all other componments must be provided by the API to operate the resource data. the apiserver mainly processes REST operations, validates them, and updates the corresponding objects in etcd.

     * Controller-manager, the kubernetes cluster management and control centre, the main purpose is to realize the automation of fault detection and recovery. such as copying and deleting pods according the definition. according to service and pods management of the relationship, finish the service to create and update the endpoints; node discovery,management,status monitoring, local cache of the image file cleanup.

     *
