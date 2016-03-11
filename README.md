# Netuitive Docker Agent
This project creates a Docker container bundled with the [Netuitive-agent](https://github.com/Netuitive/Diamond) and default Docker monitoring support.  It will automatically monitor your Docker host and containers.

## Quick-start

### Creating your APIKEY in Netuitive Cloud
See [Netuitive Cloud help](https://help.netuitive.com/Content/GettingStarted/Datasources/netuitive_integration_docker.htm?Highlight=docker) if needed.  Do the following to create a datasource and obtain your APIKEY:
* Login to [Netuitive Cloud](https://app.netuitive.com)
* Click on Datasources in the user profile menu
* Click Docker Datasource card and give it a name and click Generate.

### Running the docker-agent
The only necessary configuration is the hostname and your APIKEY.  You can run the agent with the following command:
```
docker run -d --name netuitive-agent -e DOCKER_HOSTNAME="my-docker-host" -e APIKEY="my-api-key" -v /proc:/host_proc:ro -v /var/run/docker.sock:/var/run/docker.sock:ro netuitive/docker-agent
```
### Using local config
To enable new collectors, change hostname, reconfigure collectors etc.  You can pass a local config file to the docker-agent for this.  Do the following:
* `mkdir <someplace to put netuitive-agent.conf in it>` create a directory to hold the netuitive-agent.conf file
* `cp netuitive-agent.conf <confdir you created>` copy the netuitive-agent.conf file from this project (assuming you checked it out)

Run the agent with the following:
```
docker run -d --name netuitive-agent -v <local conf dir w/netuitive-agent.conf>:/opt/netuitive-agent/conf -v /proc:/host_proc:ro -v /var/run/docker.sock:/var/run/docker.sock:ro -e USE_LOCAL_CONFIG=true netuitive/docker-agent
```

## Configuration

### Environment Variables

The agent has support for the following environment variables.

* `LOGLEVEL` change the log level of the agent.  `-e LOGLEVEL=DEBUG` for example would set the agent to log at DEBUG level.
* `INTERVAL` interval in seconds the agent collectors run.  `-e INTERVAL=120` for example would set them to 2min intervals.
* `DOCKER_HOSTNAME` hostname of the docker host.  `-e DOCKER_HOSTNAME="my-docker-host"` would set the hostname to my-docker-host.
* `APIKEY` api key used to send data to Netuitive. `-e APIKEY=myapikey` would set the apikey to myapikey.
* `USE_LOCAL_CONFIG` is used to tell the agent to ignore any environment variables set and use a local config file.  See "Using Local Config" below. `-e USE_LOCAL_CONFIG=true` would enable this feature.
* `LPRT` is used to tell the statsd agent what UDP port to listen on. (8125 by default)
* `FORWARD`is used to enabled forwarding from the netuitive-statsd server to another statsd server.
* `FIP` is used to tell the statsd agent what IP to forward to.
* `FPRT` is used to tell the statsd agent what IP to forward to. (8125 by default)


### Adding Collectors
In order to configure other collectors you will need to pass a configuration file with the updated configuration.  See "Using local config" above.


### Building it

`docker build --rm=true -t netuitive-agent .`

### More Help
See Netuitive Cloud help to create a datasource and obtain your APIKEY.  With this APIKEY you can send Docker host and container metrics to Netuitive for monitoring and analysis.

More info: https://help.netuitive.com/Content/Misc/Datasources/Netuitive/integrations/new_netuitive_datasource_via_docker.htm
