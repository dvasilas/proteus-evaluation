REPO := 127.0.0.1:5000/proteus-lobsters
TAG := $(shell git log -1 --pretty=%H | cut -c1-8)
IMG := ${REPO}:${TAG}

.PHONY: image-build
## image-build:
image-build:
	docker build -t datastore/proteus .

.PHONY: image-push-registry
## image-push-registry: Pushes the image to the local registry
image-push-registry:
	docker tag datastore/proteus ${IMG}
	docker push ${IMG}

.PHONY: help
## help: Prints this help message
help:
	@echo "Usage: \n"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'
