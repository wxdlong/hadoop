#!/bin/bash


echo "$(date +%Y-%m-%d.%H:%M:%S): Hello hadoop - example"

hadoop jar ${HADOOP_HOME}/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.0.jar grep input output 'dfs[a-z.]+'

echo "$(date +%Y-%m-%d.%H:%M:%S): Out Put"

hdfs dfs -cat output/*



