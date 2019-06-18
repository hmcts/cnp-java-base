# Base image for Gradle/Java/Springboot apps
FROM openjdk:8u191-jre-alpine3.9

ENV APP_USER hmcts

ONBUILD ARG JAVA_OPTS
ONBUILD ENV JAVA_OPTS=$JAVA_OPTS

ONBUILD ARG APP_INSIGHTS_AGENT_VERSION
ONBUILD ENV APP_INSIGHTS_AGENT_VERSION=${APP_INSIGHTS_AGENT_VERSION:-2.3.1}

ONBUILD ARG JAVA_AGENT_OPTIONS
ONBUILD ENV JAVA_AGENT_OPTIONS=${JAVA_AGENT_OPTIONS:--javaagent:/opt/app/applicationinsights-agent-${APP_INSIGHTS_AGENT_VERSION}.jar}

RUN addgroup -g 1000 -S $APP_USER \
  && adduser -u 1000 -S $APP_USER -G $APP_USER \
  && mkdir -p /opt/app \
  && chown -R $APP_USER:$APP_USER /opt/app

RUN apk add --no-cache jattach --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/

WORKDIR /opt/app
USER $APP_USER

ONBUILD RUN wget -O /opt/app/applicationinsights-agent-${APP_INSIGHTS_AGENT_VERSION}.jar \
  https://github.com/Microsoft/ApplicationInsights-Java/releases/download/${APP_INSIGHTS_AGENT_VERSION}/applicationinsights-agent-${APP_INSIGHTS_AGENT_VERSION}.jar

# The following options are used for PRs:
# - Use the followiwng RAM percentages from total RAM exposed by the container to use:  
#   -XX:InitialRAMPercentage=20.0 -XX:MaxRAMPercentage=65.0 -XX:MinRAMPercentage=10.0
# - Use parallel collector. This is to have a more efficient use of memory in PRs as it can be 
#   made to reclaim more aggressively:  
#   -XX:+UseParallelOldGC 
# - Grow the heap when only 20% is free and shrink it when more than 40% is free:
#   -XX:MinHeapFreeRatio=20 -XX:MaxHeapFreeRatio=40 
# - A hint to the virtual machine that up to 20% of time can be spent in GC (this will save memory at the cost of some time):
#   -XX:GCTimeRatio=4 
# - Timing goal check should be mostly based on to the current GC execution time (90% weight):
#   -XX:AdaptiveSizePolicyWeight=90
# - Use a small min heap size (try to save memory):
#   -Xms128M
ONBUILD ENV JAVA_TOOL_OPTIONS "-XX:InitialRAMPercentage=20.0 -XX:MaxRAMPercentage=65.0 -XX:MinRAMPercentage=10.0 -XX:+UseParallelOldGC -XX:MinHeapFreeRatio=20 -XX:MaxHeapFreeRatio=40 -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Xms128M ${JAVA_OPTS} ${JAVA_AGENT_OPTIONS}"

ENTRYPOINT ["/usr/bin/java", "-jar"]
# Users should pass a jar file + options
# CMD ["app_name.jar", "--option1", ...]
