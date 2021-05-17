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

gh-run:
	docker run --name github_action_test --label GH --workdir /github/workspace --rm -e INPUT_WHO-TO-GREET -e HOME -e GITHUB_JOB -e GITHUB_REF -e GITHUB_SHA -e GITHUB_REPOSITORY -e GITHUB_REPOSITORY_OWNER -e GITHUB_RUN_ID -e GITHUB_RUN_NUMBER -e GITHUB_RETENTION_DAYS -e GITHUB_ACTOR -e GITHUB_WORKFLOW -e GITHUB_HEAD_REF -e GITHUB_BASE_REF -e GITHUB_EVENT_NAME -e GITHUB_SERVER_URL -e GITHUB_API_URL -e GITHUB_GRAPHQL_URL -e GITHUB_WORKSPACE -e GITHUB_ACTION -e GITHUB_EVENT_PATH -e GITHUB_ACTION_REPOSITORY -e GITHUB_ACTION_REF -e GITHUB_PATH -e GITHUB_ENV -e RUNNER_OS -e RUNNER_TOOL_CACHE -e RUNNER_TEMP -e RUNNER_WORKSPACE -e ACTIONS_RUNTIME_URL -e ACTIONS_RUNTIME_TOKEN -e ACTIONS_CACHE_URL -e GITHUB_ACTIONS=true -e CI=true -v "/var/run/docker.sock":"/var/run/docker.sock" -v  $(PWD):/github/workspace $(IMAGE)   "Mona the Octocat"