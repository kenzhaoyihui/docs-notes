	1. Dockerfile
	被docker程序解释的脚本，docker程序将读取Dockerfile，根据指令生成定制的image
  
  2.   书写规则
  忽略大小写，但是建议一般大写，#作为注释，每一行只支持一条指令，每一条指令可以携带多个参数；
  Dockerfile的指令根据作用分为两种，构建指令和设置指令，构建指令用于构建image，其指定的操作不会运行在image容器上执行；设置指令用于设置image的属性，其指定的操作将在运行image的容器中执行.

	3. 具体常见的指令
	1) FROM (指定基础image)     构建指令，image可以是官方远程仓库或者是位于本地的仓库
	FROM <image>        一般该image的最后修改版本
	FROM <image>:<tag>   一个tag版本，不指定tag，默认tag为latest最新
  
  
	
	2) MAINTAINER  (用来指定镜像创建的信息）    构建指令   用于将image的制作者相关的信息写到image中，当我们对该image执行docker inspect命令时，输出中会有相应的字段记录该信息
	MAINTAINER <name>   例如：(MAINTAINER Calvin ken.zhaoyihui  <Calvin Ken@zhaoyihui@me>)
  
  
	
	3) RUN(安装软件用)      构建指令，RUN可以运行任何被基础image支持的命令，如果image选择了Centos，那么软件管理部分只能使用Centos的命令
	RUN   <command>   (the command is run in a shell - `/bin/sh -c`)
	RUN ["executable", "param1", "param2" ….]   (exec from)
  
  
	
	4) CMD (设置container启动时执行的操作)   设置指令   该操作可以是执行自定义脚本，也可以是执行系统命令，该命令只能在文件中存在一次，如果有多个，则只执行最后一条
	CMD ["executable", "param1", "param2"]  (like an exec,this is the preferred form)
	CMD command param1 param2 (as a shell)
	如果Dockerfile指定了ENTRYPOINT，那么执行下面的形式：
	CMD ["param1", "param2"] (as default paramenters to ENTRYPOINT)
  

	ENTRYPOINT指定的是一个可执行的脚本或者程序的路径，该指令的脚本或者程序会以param1,param2作为参数执行， 如果CMD以这种方式出现，那么一定要有配套的ENTRYPOINT
	
  
  
  
	5) ENTRYPOINT  (设置container启动时执行的操作)   设置指令，指定容器启动时的命令，可以多次设置，但也是最后一次生效
	ENTRYPOINT ["executable", "param1", "param2"]  (like an exec,  the preferred form)
	ENTRYPOINT command param1 param2 (as a shell)
	该指令的使用分为两种情况，一种是独自使用，另一种是和CMD指令一起使用。
	
	当独自使用时，如果还是用了CMD命令且CMD是一个完整的可执行的命令，那么CMD指令和ENTRYPOINT会相互覆盖只有最后一个CMD或者ENTRYPOINT有效
	比如：CMD echo "hello world!"
	              ENTRYPOINT ls -l,    那么CMD指令将不会执行，只有ENTRYPOINT指令执行
	
	当与CMD配合使用时，这是CMD指令不是一个完整的可执行命令，仅仅只是参数部分
	ENTRYPOINT指令只能使用JSON方式执行命令，而不能指定参数。
	比如： FROM centos7
	              CMD [" -l"]
	               ENTRYPOINT ["/usr/bin/ls"]
                 
                 
                 
	
	6) USER (设置container容器的用户） 设置指令  设置启动容器的用户，默认是root用户
	ENTRYPOINT [ "memcached"]
	USER daemon
	或
	ENTRYPOINT ["memcached", "-u" , "daemon"]      //指定memcached的运行用户
  
  
  
  
	
	7) EXPOSE（指定容器需要映射到宿主机器的端口） 设置指令 
	该指令会将容器中的端口映射成宿主机器中的某个端口。当你需要访问容器的时候，可以不是用容器的IP地址而是使用宿主机器的IP地址和映射后的端口。要完成整个操作需要两个步骤，首先在Dockerfile使用EXPOSE设置需要映射的容器端口，然后在运行容器的时候指定-p选项加上EXPOSE设置的端口，这样EXPOSE设置的端口号会被随机映射成宿主机器中的一个端口号。也可以指定需要映射到宿主机器的那个端口，这时要确保宿主机器上的端口号没有被使用。EXPOSE指令可以一次设置多个端口号，相应的运行容器的时候， 可以配套的多次使用-p选项。
	
	# 映射一个端口  
EXPOSE port1  
# 相应的运行容器使用的命令  
docker run -p port1 image   
# 映射多个端口  
EXPOSE port1 port2 port3  
# 相应的运行容器使用的命令  
docker run -p port1 -p port2 -p port3 image  
# 还可以指定需要映射到宿主机器上的某个端口号  
docker run -p host_port1:port1 -p host_port2:port2 -p host_port3:port3 image



	
	
	8）ENV（用于设置环境变量）
	构建指令，在image中设置一个环境变量
	格式：
	ENV <key> <value>
	设置了后，后续的RUN命令都可以使用，container启动后，可以通过docker inspect查看这个环境变量，也可以通过在docker run --env key=value时设置或修改环境变量。
	假如你安装了JAVA程序，需要设置JAVA_
	HOME，那么可以在Dockerfile中这样写：
	ENV JAVA_HOME /path/to/java/dirent
	
  
  
  
	
	9）ADD （从src复制文件到container的dest路径）
	包括目录；如果文件是可识别的压缩格式，则docker会帮忙解压缩（注意压缩格式）；如果<src>是文件且<dest>中不使用斜杠结束，则会将<dest>视为文件，<src>的内容会写入<dest>；如果<src>是文件且<dest>中使用斜杠结束，则会<src>文件拷贝到<dest>目录下。
	格式：
	ADD <src> <dest>
	<src> 是相对被构建的源目录的相对路径，可以是文件或目录的路径，也可以是一个远程的文件url;
	<dest> 是container中的绝对路径
	
  
  
  
  
  
	10）VOLUME（指定挂载点）
	设置指令，使容器中的一个目录具有持久化存储数据的功能，改目录可以被容器本身使用，也可以共享给其他容器使用。我们指定容器使用的是AUFS,这种文件系统不能持久化数据，当容器关闭后，所有的更改都会丢失。当容器中的应用有持久化数据的需求时可以在Dockerfile中使用该指令。
	格式：
	VOLUME ["<mountpoint>"]
	FROM base  
VOLUME ["/tmp/data"]
	运行通过该Dockerfile生成image的容器，/tmp/data目录中的数据在容器关闭后，里面的数据还存在。例如另一个容器也有持久化数据的需求，且想使用上面容器共享的/tmp/data目录，那么可以运行下面的命令启动一个容器：
	docker run -t -i -rm -volumes-from container1 image2 bash
	container1为第一个容器的ID，image2为第二个容器运行image的名字。
	
  
  
  
  
  
	11）WORKDIR（切换目录）
	设置指令，可以多次切换（相当于cd命令），对RUN ,CMD,ENTRYPOINT生效。
	格式：
	WORKDIR /path/to/workdir
	# 在 /p1/p2 下执行 vim a.txt  
WORKDIR /p1 WORKDIR p2 RUN vim a.txt
	
  
  
  
	12）ONBUILD（在子镜像中执行）
	ONBUILD <Dockerfile关键字>
ONBUILD指定的命令在构建镜像时并不执行，而是在它的子镜像中执行。
