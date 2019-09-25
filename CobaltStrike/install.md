1. VPS准备环境
	Debian、ubuntu

2. 安装java环境
	保存以下代码为：`install.sh`，然后`bash install.sh`
	```
	#!/bin/bash
	wget https://repo.huaweicloud.com/java/jdk/8u171-b11/jdk-8u171-linux-x64.tar.gz
	tar -zxvf jdk-8u171-linux-x64.tar.gz -C /usr/lib/
	echo "export JAVA_HOME=/usr/lib/jdk1.8.0_171/" >> /etc/profile
	echo "export JRE_HOME=/usr/lib/jdk1.8.0_171/jre" >> /etc/profile
	echo "export PATH=\$JAVA_HOME/bin:\$JAVA_HOME/jre/bin:\$PATH" >> /etc/profile
	echo "export CLASSPATH=\$CLASSPATH:.:\$JAVA_HOME/lib:\$JAVA_HOME/jre/lib" >> /etc/profile
	`source /etc/profile`
	rm jdk-8u171-linux-x64.tar.gz
	```

3. 把Cobalt Strike文件上传到服务器，比如上传到`/opt/cobaltstrike`，然后
	```
	cd /opt/cobaltstrike
	chmod +x teamser
	./teamserver VPS_IP password
	```
	

4. 启动
	启动服务端 ==>>用客户端连接服务端
	
5. 后台运行
	`nohup ./teamserver VPS_IP password  >/dev/null 2>&1 &`