.DEFAULT=build

build:
	docker build -t hmcts/cnp-java-base .

run:
	docker run -it --rm hmcts/cnp-java-base:latest sh

debian:
	docker build -f Dockerfile.debian -t hmcts/cnp-java-base:debian .
