# cnp-java-base

## Purpose
Base docker image for Java Spring Boot applications running in containers, specifically on Kubernetes.

## Latest version:
https://hub.docker.com/r/hmcts/cnp-java-base/tags/

## Features

It uses the new JVM container-aware settings introduced in Java 10 and backported to Java 8 in release 191. For more information see:
[Java 8u191 release notes](https://www.oracle.com/technetwork/java/javase/8u191-relnotes-5032181.html#JDK-8146115).

The image includes base settings tuned to provide best trade off between speed and memory efficiency. 

Application insights agent is bundled for java8 based images (check APP_INSIGHTS_AGENT_VERSION for the current version, this can be customised), and loaded at runtime for you with the `-agentlib` JVM option.
Java 11 images don't have a shell built in so you will need to add the agent yourself

## Usage
To use this as your base image, construct your Dockerfile like so (java 8):
```
FROM hmcts/cnp-java-base:<get the latest tag from https://hub.docker.com/r/hmcts/cnp-java-base/tags/>

# If you have any custom app insights agent config then add it to your image
#COPY lib/AI-Agent.xml /opt/app/

# Note: replace with your app name.
COPY build/libs/cnp-rhubarb-recipes-service.jar /opt/app/

CMD ["cnp-rhubarb-recipes-service.jar"]
```

Java 11:
```
FROM hmcts/cnp-java-base:<get the latest tag from https://hub.docker.com/r/hmcts/cnp-java-base/tags/>

# this can be retrieved from: https://github.com/hmcts/cnp-plum-recipes-service/raw/5e2744bd03b61e3dff3ef00172eb3a00b3001114/lib/applicationinsights-agent-2.4.0-BETA-SNAPSHOT.jar
# it's a patched version to work on java 11 waiting for the PR to be merged
# (AI-Agent.xml is optional)
COPY lib/applicationinsights-agent-2.4.0-BETA-SNAPSHOT.jar lib/AI-Agent.xml /opt/app/

# Note: replace with your app name.
COPY build/libs/cnp-rhubarb-recipes-service.jar /opt/app/

CMD ["cnp-rhubarb-recipes-service.jar"]
```

Advanced version:
```
ARG JAVA_OPTS="" # Optional, do not include if unneeded
ARG APP_INSIGHTS_AGENT_VERSION=2.3.2 # get a different version of the app insights agent jar

FROM hmcts/cnp-java-base:<get the latest tag from https://hub.docker.com/r/hmcts/cnp-java-base/tags/>

# Note: replace with your app name.
COPY build/libs/cnp-rhubarb-recipes-service.jar /opt/app/

CMD ["cnp-rhubarb-recipes-service.jar"]
# Alternatively you can also pass options to your applications
# CMD ["cnp-rhubarb-recipes-service.jar", "--option1", ...]
```

Notes:
* DO NOT attempt to override any of the JVM tuning options specified in the base Dockerfile (e.g. `-Xmx`) unless you really
know what you are doing.

## Building
You can use the Makefile to build locally.  If you need to make a change, remember to tag it for the Dockerhub automated build.  For example:
```
git tag openjdk-8u191-jre-alpine3.9-1.0
git push --tags
```

## Credits and resources
* https://www.opsian.com/blog/java-on-docker/
* https://blog.docker.com/2018/04/improved-docker-container-integration-with-java-10/
* https://www.oracle.com/technetwork/java/javase/8u191-relnotes-5032181.html#JDK-8146115
* https://developers.redhat.com/blog/2017/04/04/openjdk-and-containers/#more-433899
* https://developers.redhat.com/blog/2014/07/22/dude-wheres-my-paas-memory-tuning-javas-footprint-in-openshift-part-2/
