#!/bin/sh

docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD";
docker build -t netuitive/docker-agent .;
docker tag netuitive/docker-agent netuitive/docker-agent:$TRAVIS_TAG;
docker push netuitive/docker-agent:latest;
docker push netuitive/docker-agent:$TRAVIS_TAG;
