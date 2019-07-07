#!/bin/bash


echo "export JAVA_HOME=/opt/jdk1.8.0_191" >> /etc/bashrc; 
echo "export HADOOP_HOME=/opt/hadoop-3.2.0" >> /etc/bashrc; 
echo "export HDFS_NAMENODE_USER=root" >> /etc/bashrc; 
echo "export HDFS_DATANODE_USER=root" >> /etc/bashrc; 
echo "export HDFS_SECONDARYNAMENODE_USER=root" >> /etc/bashrc; 
echo "export YARN_RESOURCEMANAGER_USER=root" >> /etc/bashrc; 
echo "export YARN_NODEMANAGER_USER=root" >> /etc/bashrc; 
echo 'export PATH=${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:${JAVA_HOME}/bin:${PATH}'>> /etc/bashrc; 
source /etc/bashrc


for file in $(ls conf )
do
   cp ${HADOOP_HOME}/etc/hadoop/${file} ${HADOOP_HOME}/etc/hadoop/${file}.orig
   cp -rf conf/${file} ${HADOOP_HOME}/etc/hadoop/
done


hdfs namenode -format >/dev/null 
cp init.sh /usr/local/bin
cp hello-hadoop.sh /usr/local/bin
rm -rf /tmp/hadoop

