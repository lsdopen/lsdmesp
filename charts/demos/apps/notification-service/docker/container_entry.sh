#!/bin/sh
echo "Starting container with JAVA_OPTS: $JAVA_OPTS and ARGS: $ARGS"
exec java $JAVA_OPTS -jar app.jar $ARGS
echo "Exiting shell..."
