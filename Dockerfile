# Build memory calculator
FROM golang:1.10.3-alpine

ENV MEM_CALC_VERSION v3.13.0.RELEASE
WORKDIR /go/src

RUN apk update && apk add --no-cache git \
  && go get -v github.com/cloudfoundry/java-buildpack-memory-calculator \
  && cd github.com/cloudfoundry/java-buildpack-memory-calculator \
  && git checkout $MEM_CALC_VERSION \
  && GOOS=linux go build -a

# Base image for Gradle/Java/Springboot apps
FROM openjdk:8-jre-alpine
COPY --from=0 /go/src/github.com/cloudfoundry/java-buildpack-memory-calculator /usr/bin/
COPY run.sh /opt/app/

WORKDIR /opt/app

ENTRYPOINT ["/opt/app/run.sh"]