# Vars

GIT_DESCRIBE := $(shell git describe --dirty --always)
DOCKER_IMAGE_NAME := gin-ping

# Targets
run:
	go run src/main.go

build:
	go build -o gin-ping src/main.go

test:
	go test -v ./...

docker-build:
	docker build -t ${DOCKER_IMAGE_NAME}:${GIT_DESCRIBE} .

docker-build-skaffold:
	skaffold build

docker-debug:
	docker run -it --rm --entrypoint /bin/sh ${DOCKER_IMAGE_NAME}:${GIT_DESCRIBE}

docker-test:
	@./docker-test.sh ${DOCKER_IMAGE_NAME} ${GIT_DESCRIBE}

PUBLIC_PREFIX := earthquakesan
docker-push:
	docker tag ${DOCKER_IMAGE_NAME}:${GIT_DESCRIBE} ${PUBLIC_PREFIX}/${DOCKER_IMAGE_NAME}:${GIT_DESCRIBE}
	docker push ${PUBLIC_PREFIX}/${DOCKER_IMAGE_NAME}:${GIT_DESCRIBE}

create-kind-cluster:
	kind create cluster

# See https://github.com/GoogleContainerTools/skaffold/issues/3559
skaffold-deploy:
	skaffold deploy --images=${PUBLIC_PREFIX}/${DOCKER_IMAGE_NAME}:${GIT_DESCRIBE}

skaffold-delete:
	skaffold delete
