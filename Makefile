.DEFAULT=build

build:
	docker build -t hmcts/cnp-java-base .

run:
	docker run --entrypoint "/bin/sh" -it --rm hmcts/cnp-java-base:latest

debian:
	docker build -f Dockerfile.debian -t hmcts/cnp-java-base:debian .
