#!/bin/bash

source /etc/bashrc
/usr/sbin/sshd 
${HADOOP_HOME}/sbin/start-dfs.sh
${HADOOP_HOME}/bin/hdfs dfs -mkdir -p /user/root
${HADOOP_HOME}/bin/hdfs dfs -mkdir input
${HADOOP_HOME}/bin/hdfs dfs -put ${HADOOP_HOME}/etc/hadoop/*xml input

${HADOOP_HOME}/sbin/start-yarn.sh


tail -f /dev/null




