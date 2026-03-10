FROM eclipse-temurin:21-jre-ubi9-minimal AS builder

ENV HADOOP_VERSION=3.4.2

COPY cache/hadoop-${HADOOP_VERSION}.tar.gz /tmp/hadoop.tar.gz

RUN mkdir -p /opt/hadoop && \
    tar -xz \
    --strip-components=1 \
    --exclude="share/doc" \
    --exclude="*/jdiff" \
    --exclude="*/sources" \
    --exclude="*tests.jar" \
    --exclude="share/hadoop/tools" \
    -f /tmp/hadoop.tar.gz -C /opt/hadoop

FROM eclipse-temurin:21-jre-ubi9-minimal

ENV HADOOP_VERSION=3.4.2
ENV HADOOP_HOME=/opt/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
ENV JAVA_HOME=/opt/java/openjdk

ARG UID=1000

# Install runtime dependencies and create hadoop user
RUN set -ex; \
    microdnf update -y; \
    microdnf -y install procps gettext findutils hostname shadow-utils; \
    microdnf clean all; \
    useradd --no-create-home -s /sbin/nologin -c "" --uid $UID hadoop

COPY --from=builder --chown=hadoop:hadoop /opt/hadoop /opt/hadoop

RUN mkdir -p /opt/hadoop/data /opt/hadoop/tmp && \
    chown -R hadoop:hadoop /opt/hadoop/data /opt/hadoop/tmp

COPY --chown=hadoop:hadoop core-site.xml ${HADOOP_HOME}/etc/hadoop/
COPY --chown=hadoop:hadoop hdfs-site.xml ${HADOOP_HOME}/etc/hadoop/
COPY --chown=hadoop:hadoop hadoop-env.sh ${HADOOP_HOME}/etc/hadoop/
COPY --chown=hadoop:hadoop entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

USER hadoop
WORKDIR $HADOOP_HOME

# HDFS NameNode, DataNode ports
EXPOSE 9870 9000 9864 9866

ENTRYPOINT ["/entrypoint.sh"]
