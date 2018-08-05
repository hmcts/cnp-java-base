#!/bin/sh

# Based on: https://medium.com/@matt_rasband/dockerizing-a-spring-boot-application-6ec9b9b41faf

# These MUST be provided by the user's container:
#
# APPLICATION_TOTAL_MEMORY
# APPLICATION_SIZE_ON_DISK_IN_MB
# APP

# This is optional:
#
# JAVA_OPTS

loaded_classes=$(($APPLICATION_SIZE_ON_DISK_IN_MB * 400))
stack_threads=$((15 + $APPLICATION_SIZE_ON_DISK_IN_MB * 6 / 10))

docker_opts="-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=1"

calc_opts=$(java-buildpack-memory-calculator \
  -loadedClasses $loaded_classes \
  -poolType metaspace \
  -stackThreads $stack_threads \
  -totMemory ${APPLICATION_TOTAL_MEMORY})

java -jar ${APP} ${docker_opts} ${calc_opts} ${JAVA_OPTS}