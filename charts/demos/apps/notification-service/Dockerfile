FROM openjdk:11-jdk-slim

# install required packages
RUN apt-get -yq update
RUN apt-get -yqq install wget
RUN apt-get -yqq install curl

WORKDIR /opt
VOLUME /opt/etc

# add app jar
ARG JAR_FILE
ADD target/${JAR_FILE} app.jar
ADD target/lib lib
ADD docker/container_entry.sh container_entry.sh

# add user
RUN useradd -d /home/kafka -m kafka -s /bin/bash -c "Kafka User"
USER kafka

# setup environment
ENV JAVA_OPTS=""
ENV ARGS=""

ENTRYPOINT ["/opt/container_entry.sh"]
