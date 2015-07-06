#!/bin/bash


rm -f testserver.log
rm -f testserver.pass

time docker build -t netuitive-agent-api-test .

docker run -d -h testserver -p 8000:8000 -v `pwd`:/vagrant:rw --name netuitive-agent-api-test netuitive-agent-api-test
sleep 2

docker run -d  --link netuitive-agent-api-test:TESTING --name netuitive-agent-test -e DOCKER_HOSTNAME=testserver -e APIKEY=testapikey -e HTTPVAR=http -e LOGLEVEL=DEBUG -e APIHOST=$(docker inspect netuitive-agent-api-test | grep IPAddress | cut -d '"' -f 4):8000 -v /proc:/host_proc:ro -v /var/run/docker.sock:/var/run/docker.sock:ro netuitive-agent

sleep 90

docker stop netuitive-agent-api-test; sleep 1
docker stop netuitive-agent-testing; sleep 1
docker rm netuitive-agent-testing; sleep 1
docker rm netuitive-agent-api-test; sleep 1

docker rmi netuitive-agent-api-test

