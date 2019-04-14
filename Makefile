.DEFAULT=build

build-8:
	docker build -t hmcts/cnp-java-base:8 8/

build-11:
	docker build -t hmcts/cnp-java-base:11 11/

build-11-debug:
	docker build --build-arg version=11-debug -t hmcts/cnp-java-base:11-debug 11/

run-8:
	docker run --entrypoint "/bin/sh" -it --rm hmcts/cnp-java-base:8

run-11-debug:
	docker run --entrypoint sh -it --rm hmcts/cnp-java-base:11-debug

