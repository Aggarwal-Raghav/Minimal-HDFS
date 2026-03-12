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
