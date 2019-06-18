.DEFAULT=build

build-alpine-8:
	docker build -t hmcts/cnp-java-base:openjdk-8u191-jre-alpine3.9-2.0.2 alpine-jre8/

build-8:
	docker build --build-arg APP_INSIGHTS_AGENT_VERSION=2.3.1 --build-arg version=8 -t hmcts/cnp-java-base:openjdk-8-distroless-1.0 distroless/

build-8-debug:
	docker build --build-arg APP_INSIGHTS_AGENT_VERSION=2.3.1 --build-arg version=8-debug -t hmcts/cnp-java-base:openjdk-8-distroless-debug-1.0 distroless/

build-11:
	docker build --build-arg version=11 -t hmcts/cnp-java-base:openjdk-11-distroless-1.0-beta distroless/

build-11-debug:
	docker build --build-arg version=11-debug -t hmcts/cnp-java-base:openjdk-11-distroless-debug-1.0-beta distroless/

run-alpine-8:
	docker run --entrypoint "/bin/sh" -it --rm hmcts/cnp-java-base:openjdk-8u191-jre-alpine3.9-2.0.2

run-11-debug:
	docker run --entrypoint sh -it --rm hmcts/cnp-java-base:openjdk-11-distroless-debug-1.0-beta

build-all: build-alpine-8 build-8 build-8-debug build-11 build-11-debug