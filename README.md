# Minimal Hadoop Docker Image

A lightweight, single-node Hadoop 3.4.2 cluster. This image includes NameNode
and DataNode services.

## Quick Start

To build the docker image

```bash
chmod +x build-hadoop-docker.sh
./build-hadoop-docker.sh
```

## To start the docker container

```bash
./start-hadoop.sh
```

The Hadoop cluster will be running post script completion

## Run with Docker Compose

A `docker-compose-hadoop.yml` file is provided as well.

```bash
docker-compose -f docker-compose-hadoop.yml up -d --build
```

## Persistence

HDFS data is persisted using a Docker volume named `hadoop_data`. The container
stores data at `/hadoop`.

* NameNode data: `/hadoop/namenode`
* DataNode data: `/hadoop/datanode`

## To access the shell inside the container

```bash
docker exec -it hadoop-cluster bash
```
