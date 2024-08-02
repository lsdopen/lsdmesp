#!/bin/sh
echo "Starting kafka lag exporter with JAVA_OPTS: $JAVA_OPTS and ARGS: $ARGS"
exec /opt/bin/kafka-lag-exporter -Dconfig.file=/root/etc/application.conf -Dlogback.configurationFile=/opt/logback.xml
echo "Exiting shell..."
