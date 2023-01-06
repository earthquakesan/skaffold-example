#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

DOCKER_IMAGE_NAME=$1
GIT_DESCRIBE=$2

# Port is hardcoded in the app and not configurable at the moment
GIN_PING_DOCKER_INTERNAL_PORT=8080

# Run docker image with random exposed port
GIN_PING_DOCKER_ID=$(docker run -d -p ${GIN_PING_DOCKER_INTERNAL_PORT} ${DOCKER_IMAGE_NAME}:${GIT_DESCRIBE})
GIN_PING_PORT=$(docker inspect --format="{{(index (index .NetworkSettings.Ports \"${GIN_PING_DOCKER_INTERNAL_PORT}/tcp\") 0).HostPort}}" ${GIN_PING_DOCKER_ID})
TEST_RESULT=$(curl -s http://localhost:${GIN_PING_PORT}/ping)

if [[ ${TEST_RESULT} =~ "pong" ]]; then
    echo "Test successful!"
    docker rm -f ${GIN_PING_DOCKER_ID}
    exit 0
else
    echo "Did not receive 'pong' from the endpoint http://localhost:${GIN_PING_PORT}/ping"
    echo "Test failed!"
    docker rm -f ${GIN_PING_DOCKER_ID}
    exit 1
fi
