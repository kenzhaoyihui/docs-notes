# Kubernetes1.6 Release!
## 本次发布共有29个新特性，包括9个stable特性，8个alpha特性以及12个beta特性。

###  1、Stable Features

* ApiServer使用ETCDv3作为后端存储

使用Etcdv3作为状态信息存储的工作其实从Kubernets 1.3就开始进行了，准备了测试代码、不断提升存储性能还有文档迁移等。Etcdv3使用了gRPC协议进行通信，在效率、扩展性和弹性等方面的巨大提升让Kubernetes可以支持上万个容器(详见本公众号视频KubeCon2016| How We Scaled Kubernetes to 2000 Nodes Clusters)。1.6的新集群自动启用Etcdv3。

* 增加QoS级的CGroups支持

在Kubernetes1.2版本里Kubelet可以区分为k8s和系统保留的资源，通过“可分配”状态来判断某个节点是否可被调度。在1.6里，Kubelet会自动创建顶级CGroup来控制节点的可分配性(通过–cgroups-per-qos标识控制)，来更好地保证QoS。此特性支持在此之上的Pod驱逐以及特性回滚。Kubelet升级前需要排空(drain)上面的所有Pod，并且保证容器运行时的CGroups驱动匹配新配置的CGroups。

* 可配置的动态存储StorageClass

每个StorageClass包含了域provisioner和parameters，它们可以动态地指明需要什么样的卷插件支持。当前单个集群仅支持单个卷插件来提供PV，K8s 1.6的新特性使单集群可以通过配置(例如指定provisioner: kubernetes.io/aws-ebs等)来支持多个这样的卷插件

* 增加云上的默认StorageClass

同上，Kubernetes会在云上安装的时候自动部署一个StorageClass实例，现已支持Azure，AWS，GCE，OpenStack和vSphere。

* 增加外部的PV提供者(Provisioner)

用户可以自己编写和运行动态的PV提供者，这样的PV提供者可以被独立部署和更新。详情可见https://github.com/kubernetes-incubator/external-storage

* 支持DellEMC ScaleIO的卷插件

ScaleIO是一个基于软件的存储平台，它会创建一个分布式块存储池。通过这个插件可以让Pod访问DellEMC的ScaleIO卷，支持持久卷(Persistent Volumes)等特性。

* 支持Portworx的卷插件

Portworx是节点上一个块存储池，可以将它作为数据卷。Portworx卷插件支持StorageClassses，Persistent Volumes以及 Persistent Volume Claims.

* 为Secret/ConfigMaps里的所有键创建环境变量

这个特性让用户可以轻而易举地从Secrets或Configmaps注入环境变量，只需引用对应的资源名而不用为每个键创建EnvVar。

* 为GA定制chroot挂载

GCE上的K8s 1.4版本在启动的时候采用了GCI的镜像，里面没有安装挂载NFS和GlusterFS的必要工具。为了解决这个问题，我们通过创建一个安装了所需存储工具并挂载到chroot里面的定制镜像，并且能够从宿主机共享挂载。当Kubelet发现使用了GCI的镜像时，会自动chroot挂载来使用这个镜像。

### 2、Alpha Features

* 对DaemonSet的更新

之前DaemonSet模板的Spec可被更新，但是运行着的Pod是不会被更新的。这个特性添加了一个选项当Daemon的Spec被更新时来自动更新Pod。

* 监控管道Metrics HPA API

水平自动扩展器(HPA)现在支持通过APIServer的聚合器来选择指标(Metrics)

* 任意定制的HPA Metrics

原来HPA仅支持通过CPU的变化进行调整。现在HPA现在支持多个定制的指标(Metrics)，比如请求百分比等。

* 在Kubernetes核心集成了集群启动/发现

添加了新的Token认证和管理方法，kubeadm使用良好。让用户可以用一种安全的方式来发现集群信息，并将TLS根证书作为KubeConfig的一部分。

* 支持out-of-process/out-of-core的云服务商

添加了一个新的cloud-controller-manager二进制，可用来测试新的云服务商

* Pod注入策略

添加了新的API资源PodPreset以及admission控制器，允许定义交叉(cross-cutting)卷和环境并注入到Pod里，让Services和Pods变得松耦合

* “多合一”的卷提案

一个新的卷驱动，可以提供secrets、configmaps以及其他的API

* 弹性卷API升级了生命周期管理

现有的弹性卷缺乏对最新的内部动态卷插件等的支持，并且没有定义一个稳定的驱动API，当前的弹性卷并不适合诸如GCE和CoreOS的环境。所以弹性卷插件更新为支持attach、detach接口，它会破坏向后兼容性，所以请更新你的驱动。

### 3、Beta Features

* 使Deployments能够正确指明部署失败的原因

在新版本里如果Deployments的滚动升级失败或卡住了，它会通过API来报告说明相应的原因

* 基于角色的访问控制

RBAC API现已升级为v1beta1，并且为控制台、节点和控制器组件等定义了默认的角色

* Kubelet TLS启动

为Kubelet引入了向API Server请求TLS证书的API

* 极大简化了Kubernetes集群的创建过程

kubeadm的显著提升，涵盖了目前为beta版的一组基准特性和命令行标识

* 无痛部署Kubernetes集群联邦

kubefed命令升级至beta版，支持on-prem集群上的联邦，加入集群时自动配置kube-dns，以及向联邦组件传入参数

* 重定义容器运行时接口CRI

Docker运行时(Docker-CRI)实现现在为beta版，kubelet默认启用，可以通过–enable-cri=false来关闭它

* Pod内的亲和性/反亲和性

支持将相关的Pods传递或者打包到另外的拓扑区域，比如节点、域(zone)等

* 通过NoExecute污点来表示节点问题，用户定义耐受时间

每个Pod都可以配置一个耐受时间(tolerationSeconds)，当这个节点变成Unreachable、Not Ready或其他问题时，这个Pod在这段时间内会被限制在该节点里

* 节点亲和性

用来规定哪个节点是可以被调度Pod

* 多/用户定义调度器

用户可以并行运行多个调度器来负责不同的Pods组

* 污点(taint)/耐受(toleration)

默认不接受(repelling)来自某些节点的Pods，用来支持比如为特殊Pod保留节点-专用节点的使用场景。

* 支持卷挂载选项

支持对持久卷的挂载选项

### 4、Features 追踪

* Feature NameStage

* etcd v3 as storage backend for APIServerStable

* Add support for pod and qos level cgroupsStable

* Configurable Dynamic Provisioning aka StorageClassStable

* Default Storage Classes for Cloud ProvidersStable

* Create environment variables from all keys in a Secret/ConfigmapStable

* External provisionersStable

* DellEMC ScaleIO VolumeStable

* Portworx Volume PluginStable

* Customized mounts in chroot to GAStable

* DaemonSet updatesAlpha

* Monitoring Pipeline Metrics HPA APIAlpha

* Arbitrary/Custom Metrics in the Horizontal Pod AutoscalerAlpha

* Integrate Cluster Bootstrap/Discovery with Kubenetes CoreAlpha

* Support out-of-process and out-of-tree cloud providersAlpha

* Pod Injection PolicyAlpha

* All in one volume proposalAlpha

* Flex volume API and Improved lifecycle (flexvolume)Alpha

* Allow deployments to correctly indicate they are failing to deployBeta

* Role-based access controlBeta

* Kubelet TLS BootstrapBeta

* Dramatically Simplify Kubernetes Cluster CreationBeta

* It should be fast and painless to deploy a Federation of Kubernetes clustersBeta

* Redefine the Container Runtime InterfaceBeta

* Inter-pod affinity/anti-affinityBeta

* ‘Forgiveness’: Represent node problems using NoExecute taint, and allow user-defined eviction time threshold using tolerationSecondsBeta

* Node affinityBeta

* Multiple/user-defined schedulersBeta

* Taints/tolerationsBeta

* Support Volume Mount OptionsBeta
