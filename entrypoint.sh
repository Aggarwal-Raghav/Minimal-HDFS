#!/usr/bin/env bash

export JAVA_HOME=/opt/java/openjdk
export HADOOP_HOME=/opt/hadoop

# Update HOSTANME if in conf if its set as env vars
if [ -n "$HOSTNAME" ]; then
    echo "Setting DataNode hostname to: $HOSTNAME"
    sed -i "/<\/configuration>/i \
    <property>\n \
      <name>dfs.datanode.hostname</name>\n \
      <value>$HOSTNAME</value>\n \
    </property>" $HADOOP_HOME/etc/hadoop/hdfs-site.xml
fi

# Format the NameNode for first time
if [ ! -f /opt/hadoop/tmp/dfs/name/current/VERSION ]; then
    echo "Formatting NameNode..."
    $HADOOP_HOME/bin/hdfs namenode -format -force -nonInteractive
fi

# Not using daemon flag
echo "--> Starting NameNode..."
$HADOOP_HOME/bin/hdfs namenode &
NAMENODE_PID=$!

echo "--> Starting DataNode..."
$HADOOP_HOME/bin/hdfs datanode &
DATANODE_PID=$!

echo "Hadoop namenode and datanode is running!"

wait -n $NAMENODE_PID $DATANODE_PID

EXIT_STATUS=$?
echo "A Hadoop daemon exited unexpectedly with status $EXIT_STATUS. Shutting down."
exit $EXIT_STATUS
