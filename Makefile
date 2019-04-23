.DEFAULT=build

build-8:
	docker build -t hmcts/cnp-java-base:openjdk-8u191-jre-alpine3.9-2.0.2 8/

build-11:
	docker build -t hmcts/cnp-java-base:openjdk-11-distroless-1.0-beta 11/

build-11-debug:
	docker build --build-arg version=11-debug -t hmcts/cnp-java-base:openjdk-11-distroless-debug-1.0-beta 11/

run-8:
	docker run --entrypoint "/bin/sh" -it --rm hmcts/cnp-java-base:openjdk-8u191-jre-alpine3.9-2.0.2

run-11-debug:
	docker run --entrypoint sh -it --rm hmcts/cnp-java-base:openjdk-11-distroless-debug-1.0-beta

build-all: build-8 build-11 build-11-debug