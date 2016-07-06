#!/bin/bash

rm -f testserver.log
rm -f testserver.pass

time docker build -t netuitive-agent-api-test .

docker run -d -h testserver -p 8000:8000 -v `pwd`:/vagrant:rw --name netuitive-agent-api-test netuitive-agent-api-test
sleep 2

TESTIP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' netuitive-agent-api-test)

docker run -d  --link netuitive-agent-api-test --name netuitive-agent-test -e DOCKER_HOSTNAME=testserver -e APIKEY=testapikey -e HTTPVAR=http -e LOGLEVEL=DEBUG -e APIHOST=$(TESTIP):8000 -v /proc:/host_proc:ro -v /var/run/docker.sock:/var/run/docker.sock:ro netuitive/docker-agent

sleep 90

docker stop netuitive-agent-api-test; sleep 1
docker stop netuitive-agent-test; sleep 1
docker rm netuitive-agent-api-test; sleep 1
docker rm netuitive-agent-test; sleep 1

docker rmi netuitive-agent-api-test



for f in testserver.pass; do
    [ -e "$f" ] && echo "$f exists" || exit 1
    break
done
