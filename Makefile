REGISTRY := ghcr.io/ev-smoke
IMAGE_NAME=example

TARGETOS ?= linux
TARGETARCH ?= amd64


build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o app"

image:
	@DOCKER_BUILDKIT=1 docker buildx build \
		--file Dockerfile \
		--platform $(TARGETOS)/$(TARGETARCH) \
	 	--tag $(REGISTRY)/$(IMAGE_NAME):$(TARGETOS)-$(TARGETARCH) \
		--build-arg ARCH=$(TARGETARCH) \
		--build-arg PLATFORM=$(PLATFORM) \
		--output type=docker .;

linux:
	$(MAKE) TARGETOS=linux TARGETARCH=amd64 image

arm:
	$(MAKE) TARGETOS=linux TARGETARCH=arm64 image

macos:
	$(MAKE) TARGETOS=darwin TARGETARCH=arm64 image

windows:
	$(MAKE) TARGETOS=windows TARGETARCH=amd64 image

push:
	docker push ${REGISTRY}/${IMAGE_NAME}:${TARGETOS}-${TARGETARCH}

clean:
	docker rmi -f ${REGISTRY}/${IMAGE_NAME}:${TARGETOS}-${TARGETARCH} || true
