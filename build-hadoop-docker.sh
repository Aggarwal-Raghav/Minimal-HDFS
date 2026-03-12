#!/usr/bin/env bash

HADOOP_VERSION="3.4.2"
TARBALL_NAME="hadoop-${HADOOP_VERSION}.tar.gz"
URL="https://dlcdn.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/${TARBALL_NAME}"

mkdir -p cache

if [ -f "cache/${TARBALL_NAME}" ]; then
    echo "-> Found ${TARBALL_NAME} in local cache. Skipping download."
else
    echo "-> Downloading ${TARBALL_NAME} into cache directory..."
    wget -P cache/ "${URL}"

    if [ $? -ne 0 ]; then
        echo "-> Download failed!!!"
        exit 1
    fi
    echo "-> Download complete."
fi

echo "-> Building Docker image minimal-hadoop:${HADOOP_VERSION}..."
docker build -f Dockerfile.hadoop -t minimal-hadoop:${HADOOP_VERSION} .

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
