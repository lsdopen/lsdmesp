FROM openjdk:11-jdk-slim

# install required packages
RUN apt-get -yq update
RUN apt-get -yqq install wget
RUN apt-get -yqq install curl
RUN apt-get -yqq install unzip
RUN cd /tmp && \
    wget https://github.com/seglo/kafka-lag-exporter/releases/download/v0.8.2/kafka-lag-exporter-0.8.2.zip && \
    unzip kafka-lag-exporter-0.8.2.zip && \
    cd kafka-lag-exporter-0.8.2 && \
    mv lib bin /opt && \
    cd /opt

WORKDIR /opt
VOLUME /opt/etc
VOLUME /opt/certs

ADD logback.xml logback.xml
ADD container_entry.sh container_entry.sh

# add user
RUN useradd -d /home/kafka -m kafka -s /bin/bash -c "Kafka User"
USER kafka

# setup environment
ENV JAVA_OPTS=""
ENV ARGS=""

EXPOSE 9999

ENTRYPOINT ["/opt/container_entry.sh"]
