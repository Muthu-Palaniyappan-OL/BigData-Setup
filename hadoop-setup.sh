#!/bin/bash

# Staring Directory

read -p "Enter Bearer Token: " BEARER_TOKEN </dev/tty

if java &> /dev/null
then
	echo "Java exits, please remove it, we will install java 11"
	exit
fi

rm -rf /home/$USER/tmpdata
rm -rf /home/$USER/dfsdata

####################################################

USER=$(whoami)
HADOOP_HOME=/home/$USER/hadoop-3.3.4
JAVA_HOME=/home/$USER/jdk-11
FLUME_HOME=/home/$USER/apache-flume-1.10.1-bin

####################################################

rm -rf $HADOOP_HOME
rm -rf $JAVA_HOME
rm -rf $FLUME_HOME

echo "Simple Script To Setup Hadoop"

echo -e "\nINFO: Downloading Hadoop\n"
# wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.4/hadoop-3.3.4.tar.gz
# tar zxf hadoop-3.3.4.tar.gz
rm hadoop-3.3.4.tar.gz

echo -e "\nINFO: Downloading JAVA 11\n"
# wget https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz
# tar zxf openjdk-11+28_linux-x64_bin.tar.gz
rm openjdk-11+28_linux-x64_bin.tar.gz

echo -e "\nINFO: Downloading FLUME\n"
# wget https://archive.apache.org/dist/flume/1.10.1/apache-flume-1.10.1-bin.tar.gz
# tar zxf apache-flume-1.10.1-bin.tar.gz
rm apache-flume-1.10.1-bin.tar.gz

cat >> /home/$USER/.bashrc <<EOF
# ========================================================
# BASHRC ADDED BY MUTHU
export HADOOP_HOME=$HADOOP_HOME
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export PATH=$HADOOP_HOME/sbin:$HADOOP_HOME/bin:\$PATH
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/nativ"
export JAVA_HOME=$JAVA_HOME
export PATH=$JAVA_HOME/bin:\$PATH
export PATH=$FLUME_HOME/bin:\$PATH
export FLUME_HOME=$FLUME_HOME
export FLUME_CONF=$FLUME_HOME/conf
export BEARER_TOKEN=$BEARER_TOKEN
# END OF BASHRC ADDED BY MUTHU
# ========================================================
EOF

cat >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh <<EOF
export JAVA_HOME=$JAVA_HOME
EOF

cat > $HADOOP_HOME/etc/hadoop/core-site.xml <<EOF
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
	<property>
        <name>hadoop.tmp.dir</name>
        <value>/home/$USER/tmpdata</value>
        <description>A base for other temporary directories.</description>
    </property>
    <property>
        <name>fs.default.name</name>
        <value>hdfs://localhost:9000</value>
        <description>The name of the default file system></description>
    </property>
</configuration>
EOF

cat > $HADOOP_HOME/etc/hadoop/hdfs-site.xml <<EOF
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
	<property>
	  <name>dfs.data.dir</name>
	  <value>/home/$USER/dfsdata/namenode</value>
	</property>
	<property>
	  <name>dfs.data.dir</name>
	  <value>/home/$USER/dfsdata/datanode</value>
	</property>
	<property>
	  <name>dfs.replication</name>
	  <value>1</value>
	</property>
</configuration>
EOF

cat > $HADOOP_HOME/etc/hadoop/mapred-site.xml <<EOF
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
	<property>
	  <name>mapreduce.framework.name</name>
	  <value>yarn</value>
	</property>
</configuration>
EOF

cat > $HADOOP_HOME/etc/hadoop/yarn-site.xml <<EOF
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
	<property>
	  <name>yarn.nodemanager.aux-services</name>
	  <value>mapreduce_shuffle</value>
	</property>
	<property>
	  <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
	  <value>org.apache.hadoop.mapred.ShuffleHandler</value>
	</property>
	<property>
	  <name>yarn.resourcemanager.hostname</name>
	  <value>127.0.0.1</value>
	</property>
	<property>
	  <name>yarn.acl.enable</name>
	  <value>0</value>
	</property>
	<property>
	  <name>yarn.nodemanager.env-whitelist</name>
	  <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PERPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>
	</property>
</configuration>
EOF

chmod -R 777 $HADOOP_HOME $JAVA_HOME $FLUME_HOME
source /home/$USER/.bashrc
hdfs namenode -format

mv $FLUME_HOME/conf/flume-conf.properties.template $FLUME_HOME/conf/flume-conf.properties
mv $FLUME_HOME/conf/flume-env.sh.template $FLUME_HOME/conf/flume-env.sh

echo "Script Finished Successfully..."
