docker-agent
===============================
This project creates a Docker container with Netuitive-agent read to
monitor your Docker host and containers.

Usage
-----
### Building it

`docker build --rm=true -t netuitive-agent .`

### Using it
See Netuitive Cloud help to create a datasource and obtain your APIKEY.  With this APIKEY you can send Docker host and container metrics to Netuitive for monitoring and analysis.  
More info: https://help.netuitive.com/Content/GettingStarted/Datasources/netuitive_integration_docker.htm?Highlight=docker 

`docker run -d -e DOCKER_HOSTNAME=my-docker-host -e APIKEY=my-api-key --name netuitive-agent -v /proc:/host_proc:ro -v /var/run/docker.sock:/var/run/docker.sock:ro -d netuitive/docker-agent`
