# cnp-java-base

[![Build Status](https://dev.azure.com/hmcts/Platform%20Engineering/_apis/build/status/ACR/Publish%20Java%20Base%20Image?branchName=master)](https://dev.azure.com/hmcts/Platform%20Engineering/_build/latest?definitionId=218&branchName=master)

## Purpose
Base docker image for Java Spring Boot applications running in containers, specifically on Kubernetes.

## Latest version:

```
az acr repository show-tags -n hmctspublic --repository base/java --subscription DCD-CNP-PROD
```

## Features

It uses the new JVM container-aware settings introduced in Java 10 and backported to Java 8 in release 191. For more information see:
[Java 8u191 release notes](https://www.oracle.com/technetwork/java/javase/8u191-relnotes-5032181.html#JDK-8146115).

The image includes base settings tuned to provide best trade off between speed and memory efficiency. 

Application insights agent variables are set by default, you need to add the agent to the image and set the version that you're using (`APP_INSIGHTS_AGENT_VERSION`)

## Usage
To use this as your base image, construct your Dockerfile like so (java 8):
```
ARG APP_INSIGHTS_AGENT_VERSION=<AI-version> # optional to override default version
FROM hmctspublic.azurecr.io/base/java:<get the latest tag from the hmctspublic Azure registry>

COPY lib/AI-Agent.xml /opt/app/

# Note: replace with your app name.
COPY build/libs/cnp-rhubarb-recipes-service.jar /opt/app/

CMD ["cnp-rhubarb-recipes-service.jar"]
```

Java 11:
```
ARG APP_INSIGHTS_AGENT_VERSION=<AI-version> # optional to override default version
FROM hmcts/cnp-java-base:<get the latest tag from https://hub.docker.com/r/hmcts/cnp-java-base/tags/>

COPY lib/AI-Agent.xml /opt/app/

# Note: replace with your app name.
COPY build/libs/cnp-rhubarb-recipes-service.jar /opt/app/

CMD ["cnp-rhubarb-recipes-service.jar"]
```

Advanced version:
```
ARG JAVA_OPTS="" # Optional, do not include if unneeded
ARG APP_INSIGHTS_AGENT_VERSION=2.3.2 # get a different version of the app insights agent jar

FROM hmcts/cnp-java-base:<get the latest tag from https://hub.docker.com/r/hmcts/cnp-java-base/tags/>

COPY lib/AI-Agent.xml /opt/app/

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
