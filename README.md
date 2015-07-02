docker-agent
===============================
This project creates a Docker container with Netuitive-agent read to
monitor your Docker host and containers.

Usage
-----
### Building it

`docker build --rm=true -t netuitive-agent .`

### Using it

`docker run -d -e DOCKER_HOSTNAME=my-docker-host -e APIKEY=my-api-key --name netuitive-agent -v /proc:/host_proc:ro -v /var/run/docker.sock:/var/run/docker.sock:ro -d netuitive/docker-agent`
