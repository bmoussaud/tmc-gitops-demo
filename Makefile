IMAGE_NAME=bmoussaud/tmc-gitops-demo
IMAGE_VERSION=0.0.1
IMAGE=$(IMAGE_NAME):$(IMAGE_VERSION)
SOURCE_BRANCH=v0.0.1

build:
	docker build \
	--label org.label-schema.build-date=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	--label org.label-schema.vcs-ref=`git rev-parse --short HEAD` \
	--label org.label-schema.vcs-url="https://github.com:bmoussaud/tmc-gitops-demo.git" \
	--label org.label-schema.version="$(SOURCE_BRANCH)" \
	--label org.label-schema.schema-version="1.0" \
	-f . \
	-t $(IMAGE) \
	.

dockerhub-push: build
	docker push  $(IMAGE)

docker-run: build
	docker run -e TMC_API_TOKEN=${TMC_API_TOKEN} --rm  -it $(IMAGE) /bin/bash