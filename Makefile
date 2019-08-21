.DEFAULT=build

build-8:
	docker build --build-arg APP_INSIGHTS_AGENT_VERSION=2.3.1 --build-arg version=8 -t base/java:openjdk-8-distroless-1.1 distroless/

build-8-debug:
	docker build --build-arg APP_INSIGHTS_AGENT_VERSION=2.3.1 --build-arg version=8-debug -t base/java:openjdk-8-distroless-debug-1.1 -f distroless/debug.Dockerfile distroless/

build-11:
	docker build --build-arg version=11 -t base/java:openjdk-11-distroless-1.1 distroless/

build-11-debug:
	docker build --build-arg version=11-debug -t base/java:openjdk-11-distroless-debug-1.1 -f distroless/debug.Dockerfile distroless/

run-8-debug:
	docker run --entrypoint sh -it --rm base/java:openjdk-11-distroless-debug-1.1

run-11-debug:
	docker run --entrypoint sh -it --rm base/java:openjdk-11-distroless-debug-1.1

build-all: build-8 build-8-debug build-11 build-11-debug
