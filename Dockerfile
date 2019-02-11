# Base image for Gradle/Java/Springboot apps
FROM openjdk:8u191-jre-alpine3.9

ENV APP_USER hmcts

RUN addgroup -g 1000 -S $APP_USER \
  && adduser -u 1000 -S $APP_USER -G $APP_USER \
  && mkdir -p /opt/app \
  && chown -R $APP_USER:$APP_USER /opt/app

WORKDIR /opt/app
USER $APP_USER

ENV JAVA_TOOL_OPTIONS "-XX:InitialRAMPercentage=20.0 -XX:MaxRAMPercentage=65.0 -XX:MinRAMPercentage=10.0 -XX:+UseParallelOldGC -XX:MinHeapFreeRatio=20 -XX:MaxHeapFreeRatio=40 -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Xms128M"

ENTRYPOINT ["/usr/bin/java", "-jar"]
# Users should pass a jar file + options
# CMD ["app_name.jar", "--option1", ...]