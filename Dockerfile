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
FROM openjdk:8u181-jre-alpine3.8

ENV APP_USER hmcts

COPY --from=0 /go/src/github.com/cloudfoundry/java-buildpack-memory-calculator /usr/bin/
COPY run.sh /opt/app/

RUN addgroup -g 1000 -S $APP_USER \
  && adduser -u 1000 -S $APP_USER -G $APP_USER \
  && chown -R $APP_USER:$APP_USER /opt/app

WORKDIR /opt/app
USER $APP_USER

ENTRYPOINT ["/opt/app/run.sh"]