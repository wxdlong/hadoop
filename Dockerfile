FROM centos:7
LABEL author="wxdlong"
LABEL email="wxdlong@qq.com"

#install packages
RUN yum clean all; \
    rpm --rebuilddb; \
    yum install -y openssh-server openssh-clients vim rsync iproute ping tar wget

#passwordless ssh
RUN mkdir /var/run/sshd; \
    echo 'root:123456' | chpasswd; \
    sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config; \
    ssh-keygen -A; \
    # SSH login fix. Otherwise user is kicked off after login
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd ;\
    ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa ; \
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys ; 

RUN  wget  http://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-3.2.0/hadoop-3.2.0.tar.gz -O - | tar -zxf - -C /opt && \
     wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3a%2F%2Fwww.oracle.com%2Ftechnetwork%2Fjava%2Fjavase%2Fdownloads%2Fjdk8-downloads-2133151.html; oraclelicense=accept-securebackup-cookie;" "https://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-linux-x64.tar.gz" -O - | tar -zxf - -C /opt 
     

COPY resources /tmp/hadoop/


# install hadoop 

RUN cd /tmp/hadoop; \ 
    sh install.sh

#
#replace the default configruation

#set env
#RUN sed -i "/export HADOOP_PREFIX/a export JAVA_HOME=/opt/tools/jdk1.8.0_77" /opt/tools/hadoop/libexec/hadoop-config.sh; \
#	echo 'export JAVA_HOME=/opt/tools/jdk1.8.0_77' >> /etc/bash.bashrc; \
#    echo 'export HADOOP_PREFIX=/opt/tools/hadoop'  >> /etc/bash.bashrc; \
#    echo 'export HADOOP_COMMON_HOME=/opt/tools/hadoop'  >> /etc/bash.bashrc; \
#    echo 'export HADOOP_HDFS_HOME=/opt/tools/hadoop'  >> /etc/bash.bashrc; \
#	echo 'export HADOOP_MAPRED_HOME=/opt/tools/hadoop'  >> /etc/bash.bashrc; \
#	echo 'export HADOOP_YARN_HOME=/opt/tools/hadoop'  >> /etc/bash.bashrc; \
#	echo 'export HADOOP_CONF_DIR=/opt/tools/hadoop/etc/hadoop'  >> /etc/bash.bashrc; \
#	echo 'export YARN_CONF_DIR=$HADOOP_PREFIX/etc/hadoop'  >> /etc/bash.bashrc; \
#	echo 'export PATH=$PATH:$JAVA_HOME/bin:$HADOOP_PREFIX/bin:$HADOOP_PREFIX/sbin'  >> /etc/bash.bashrc; \
#	echo 'localhost' >> /opt/tools/hadoop/slaves; \
#	echo 'master' > /etc/hostname
    
# Hdfs ports: 50010 50020 50070 50075 50090  Mapred ports: 19888 Yarn ports: 8030 8031 8032 8033 8040 8042 8088

ENTRYPOINT ["init.sh"]