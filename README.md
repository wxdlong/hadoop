
　　上一篇([搭建hadoop docker环境](http://kaibb.com/blog/title/%E6%90%AD%E5%BB%BAhadoop%20docker%E5%8D%95%E7%BB%93%E7%82%B9%E7%8E%AF%E5%A2%83 "搭建hadoop docker环境"))己经讲述了怎么样搭建docker环境. 现在来讲一下怎么运行测试.
  1. 启动容器
  ```shell
  docker run -itd --name hadoop -h hadoop -P registry.aliyuncs.com/kaibb/hadoop
  ```
  查看容器运行状态
 

     docker ps -a
    CONTAINER ID        IMAGE                                COMMAND               CREATED             STATUS              PORTS                                                                                                                                                                                                                                                                                                                                                                                                                 NAMES
    733301fddfa5        registry.aliyuncs.com/kaibb/hadoop   "/usr/sbin/sshd -D"   6 seconds ago       Up 4 seconds        0.0.0.0:32783->22/tcp, 0.0.0.0:32782->2122/tcp, 0.0.0.0:32781->8030/tcp, 0.0.0.0:32780->8031/tcp, 0.0.0.0:32779->8032/tcp, 0.0.0.0:32778->8033/tcp, 0.0.0.0:32777->8040/tcp, 0.0.0.0:32776->8042/tcp, 0.0.0.0:32775->8088/tcp, 0.0.0.0:32774->19888/tcp, 0.0.0.0:32773->49707/tcp, 0.0.0.0:32772->50010/tcp, 0.0.0.0:32771->50020/tcp, 0.0.0.0:32770->50070/tcp, 0.0.0.0:32769->50075/tcp, 0.0.0.0:32768->50090/tcp   hadoop
    
　　2. 进入容器
  

    docker exec -it hadoop bash
	
　　３. 格式化namenode
  hadoop安装在/opt/tools下,因为己经加了执行目录的环境变量,所以在任何目录下运行hadoop命令都可以
  

    hadoop namenode -format
	
	16/04/10 12:44:21 INFO common.Storage: Storage directory /hadoop/name has been successfully formatted.


  namenode 相关信息参考hdfs-site.xml
  ```xml
  <property>
    <name>dfs.replication</name>
    <value>1</value>
  </property>
  <property>
    <name>dfs.datanode.data.dir</name>
    <value>file:/hadoop/data</value>
  </property>
  <property>
    <name>dfs.namenode.name.dir</name>
    <value>file:/hadoop/name</value>
  </property>
```
　　4. 运行`start-dfs.sh`
  　　中间会停下来要求输入yes
 ` Are you sure you want to continue connecting (yes/no)? `
 　查看启动状态：三个节点都正常

    　jps
    297 DataNode
    457 SecondaryNameNode
    572 Jps
    173 NameNode

 查看namenode的web界面,打开浏览器: http://${dockerIP}:${50070:映射端口}/
 ![](http://kaibb.com/images/editor/2016-04/101475_namenode.jpg)
 
　　5. 运行`start-yarn.sh`
　　多了两个节点程序.

    jps
    752 NodeManager
    964 Jps
    297 DataNode
    457 SecondaryNameNode
    653 ResourceManager
    173 NameNode
 
 查看ResourceManager Web界面 - http://$(dockerIP):${8088:映射端口}/
 
 ![](http://kaibb.com/images/editor/2016-04/128081_resouceManager.jpg)
 
　　6. 创建目录
   

    root@hadoop:/opt/tools/hadoop# hdfs dfs -mkdir -p /user/kaibb/input
    root@hadoop:/opt/tools/hadoop# hdfs dfs -ls /user/kaibb
    Found 1 items
    drwxr-xr-x   - root supergroup          0 2016-04-10 13:00 /user/kaibb/input
	
　　7. 复制文件至dfs文件目录中
 

     root@hadoop:/opt/tools/hadoop# hdfs dfs -put /opt/tools/hadoop/etc/hadoop/* /user/kaibb/input

    root@hadoop:/opt/tools/hadoop# hdfs dfs -ls /user/kaibb/input
    Found 30 items
    -rw-r--r--   1 root supergroup       4436 2016-04-10 13:02 /user/kaibb/input/capacity-scheduler.xml
    -rw-r--r--   1 root supergroup       1335 2016-04-10 13:02 /user/kaibb/input/configuration.xsl
    -rw-r--r--   1 root supergroup        318 2016-04-10 13:02 /user/kaibb/input/container-executor.cfg
    -rw-r--r--   1 root supergroup        872 2016-04-10 13:02 /user/kaibb/input/core-site.xml
    -rw-r--r--   1 root supergroup       3670 2016-04-10 13:02 /user/kaibb/input/hadoop-env.cmd
    -rw-r--r--   1 root supergroup       4224 2016-04-10 13:02 /user/kaibb/input/hadoop-env.sh
    -rw-r--r--   1 root supergroup       2490 2016-04-10 13:02 /user/kaibb/input/hadoop-metrics.properties
    -rw-r--r--   1 root supergroup       2598 2016-04-10 13:02 /user/kaibb/input/hadoop-metrics2.properties
    -rw-r--r--   1 root supergroup       9683 2016-04-10 13:02 /user/kaibb/input/hadoop-policy.xml
    -rw-r--r--   1 root supergroup       1059 2016-04-10 13:02 /user/kaibb/input/hdfs-site.xml
    -rw-r--r--   1 root supergroup       1449 2016-04-10 13:02 /user/kaibb/input/httpfs-env.sh
    -rw-r--r--   1 root supergroup       1657 2016-04-10 13:02 /user/kaibb/input/httpfs-log4j.properties
    -rw-r--r--   1 root supergroup         21 2016-04-10 13:02 /user/kaibb/input/httpfs-signature.secret
    -rw-r--r--   1 root supergroup        620 2016-04-10 13:02 /user/kaibb/input/httpfs-site.xml
    -rw-r--r--   1 root supergroup       3518 2016-04-10 13:02 /user/kaibb/input/kms-acls.xml
    -rw-r--r--   1 root supergroup       1527 2016-04-10 13:02 /user/kaibb/input/kms-env.sh
    -rw-r--r--   1 root supergroup       1631 2016-04-10 13:02 /user/kaibb/input/kms-log4j.properties
    -rw-r--r--   1 root supergroup       5511 2016-04-10 13:02 /user/kaibb/input/kms-site.xml
    -rw-r--r--   1 root supergroup      11237 2016-04-10 13:02 /user/kaibb/input/log4j.properties
    -rw-r--r--   1 root supergroup        951 2016-04-10 13:02 /user/kaibb/input/mapred-env.cmd
    -rw-r--r--   1 root supergroup       1383 2016-04-10 13:02 /user/kaibb/input/mapred-env.sh
    -rw-r--r--   1 root supergroup       4113 2016-04-10 13:02 /user/kaibb/input/mapred-queues.xml.template
    -rw-r--r--   1 root supergroup        962 2016-04-10 13:02 /user/kaibb/input/mapred-site.xml
	
　　8. 运行示例程序`root@hadoop:/opt/tools/hadoop# hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.2.jar grep /user/kaibb/input output 'dfs[a-z.]+'
`
　　控制台正在不断输出结果,程序正在运行中,还可以打开web界面查看
  
  ![](http://kaibb.com/images/editor/2016-04/197175_job.jpg)
  
　　9. 查看结果
  

     hdfs dfs -cat output/*
    6	dfs.audit.logger
    4	dfs.class
    3	dfs.server.namenode.
    2	dfs.audit.log.maxbackupindex
    2	dfs.period
    2	dfs.audit.log.maxfilesize
    1	dfsmetrics.log
    1	dfsadmin
    1	dfs.servers
    1	dfs.replication
    1	dfs.file
    1	dfs.datanode.data.dir
    1	dfs.namenode.name.dir
    
	
　　至此简单的测试结束,还算不错,如有什么不对,欢迎指正.谢谢