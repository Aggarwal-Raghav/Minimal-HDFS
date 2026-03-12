#!/usr/bin/env bash

HADOOP_VERSION=${1:-"3.4.2"}

if ! docker network ls | grep -q "hadoop-network"; then
    echo "-> Creating Docker network 'hadoop-network'"
    docker network create hadoop-network
fi


echo "-> Starting Hadoop cluster..."
docker run -d \
  --name hadoop-cluster \
  --hostname hadoop-cluster \
  --network hadoop-network \
  -p 9870:9870 \
  -p 9000:9000 \
  -p 9864:9864 \
  -v hadoop_data:/hadoop \
  minimal-hadoop:$HADOOP_VERSION

echo "-> Success! Hadoop is running."
echo "-> NameNode Web UI: http://localhost:9870"
echo "-> Check logs with: docker logs -f hadoop-cluster"
