# cnp-java-base
----
## Purpose
Base docker image for Java Spring Boot applications running in containers, specifically on Kubernetes.

## Latest version:
https://hub.docker.com/r/hmcts/cnp-java-base/tags/

## Features

The latest version, openjdk-8u191-jre-alpine3.9-1.0 does NOT make use of the memory calculator, which has always been a 
workaround and can constrain the JVM ergonomics. It uses instead the new JVM capabilities introduced in Java 10 and 
backported to Java 8 in release 191. For more information see:
[Java 8u191 release notes](https://www.oracle.com/technetwork/java/javase/8u191-relnotes-5032181.html#JDK-8146115)

The previous versions, openjdk-8u181-jre-alpine3.8-1.0  and openjdk-jre-8-slim-stretch-1.0 use the [Cloud Foundry Java Buildpack Memory Calculator](https://github.com/cloudfoundry/java-buildpack-memory-calculator) to statically tune the JVM based on application characteristics and container resource limits.  The idea is to avoid applications being 'OOM killed' by the container orchestrator.

For example, a Java process launched using this image will have tunings similar to this:
```
Tims-MacBook-Pro-3:moj timw$ docker exec 9eb ps aux
PID   USER     TIME  COMMAND
    1 hmcts     0:00 {run.sh} /bin/sh /opt/app/run.sh
   14 hmcts     0:47 java -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=1 -Xmx87434K -Xss1M -XX:ReservedCodeCacheSize=240M -XX:MaxDirectMemorySize=10M -XX:MaxMetaspaceSize=133750K -jar moj-rhubarb-recipes-service.jar
```

## Usage
To use this as your base image, construct your Dockerfile like so:
For the latest version (openjdk-8u191-jre-alpine3.9-1.0):
```
FROM hmcts/cnp-java-base:openjdk-jre-8-alpine-2.0

# Note: replace with your application name
ENV APP moj-rhubarb-recipes-service.jar

# Optional
ENV JAVA_OPTS ""

COPY build/libs/$APP /opt/app/

# Note: replace with your app name. Cannot use $APP here as there is no shell expansion
CMD ["moj-rhubarb-recipes-service.jar"]
# Alternatively you can also pass options to your applications
# CMD ["moj-rhubarb-recipes-service.jar", "--option1", ...]

```

For previous versions (openjdk-8u181-jre-alpine3.8-1.0  and openjdk-jre-8-slim-stretch-1.0):
```
FROM hmcts/cnp-java-base:openjdk-jre-8-alpine-1.2

# Mandatory!
ENV APP moj-rhubarb-recipes-service.jar
ENV APPLICATION_TOTAL_MEMORY 512M
ENV APPLICATION_SIZE_ON_DISK_IN_MB 53

# Optional
ENV JAVA_OPTS ""

COPY build/libs/$APP /opt/app/

```
Notes:
* You MUST provide the `APP`, `APPLICATION_TOTAL_MEMORY`, and `APPLICATION_SIZE_ON_DISK_IN_MB` environment variables
* `JAVA_OPTS` is optional
* `APPLICATION_TOTAL_MEMORY` should be the same as `resources.limits.memory` in your Kubernetes deployment template.
* `APPLICATION_SIZE_ON_DISK_IN_MB` is the size (in MB) of your application JAR file.
* DO NOT attempt to override any of the JVM tuning options specified in the example output above (e.g. `-Xmx`).  The memory calculator does this for you.

## Building
You can use the Makefile to build locally.  If you need to make a change, remember to tag it for the Dockerhub automated build.  For example:
```
git tag 1.1
git push --tags
```

## Credits and resources
* https://www.opsian.com/blog/java-on-docker/
* https://blog.docker.com/2018/04/improved-docker-container-integration-with-java-10/
* https://www.oracle.com/technetwork/java/javase/8u191-relnotes-5032181.html#JDK-8146115
* https://developers.redhat.com/blog/2017/04/04/openjdk-and-containers/#more-433899
* 
* Initial releases inspired by [this](https://medium.com/@matt_rasband/dockerizing-a-spring-boot-application-6ec9b9b41faf) blog post.
* https://blog.csanchez.org/2017/05/31/running-a-jvm-in-a-container-without-getting-killed/
* https://github.com/dsyer/spring-boot-memory-blog/blob/master/cf.md

## TO DO
* License information
