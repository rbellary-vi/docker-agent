CloudWisdom Agent Docker Container
=================================

This project creates a Docker container bundled with the [CloudWisdom Linux Agent](https://github.com/Netuitive/omnibus-netuitive-agent) and default Docker monitoring support.  It will automatically monitor your Docker host and containers.

For more information on the CloudWisdom Linux Agent, go [here](https://docs.virtana.com/en/linux-agent.html). For more information on the CloudWisdom Agent Docker Container, go [here](https://docs.virtana.com/en/docker-install.html). For additional help, contact CloudWisdom support at [cloudwisdom.support@virtana.com](mailto:cloudwisdom.support@virtana.com).

Note that all references in this repository to Python are for Python 2.7.

Getting Started
----------------

You'll need a [CloudWisdom](https://try.cloudwisdom.virtana.com/) account to create the necessary datasource for interacting with the CloudWisdom Agent Docker Container. See the [CloudWisdom help](https://docs.virtana.com/en/docker.html) docs for the detailed setup steps. For a brief tutorial, follow along below.

### Creating Your API Key in CloudWisdom
Do the following to create a datasource and obtain your APIKEY:

1. Login to [CloudWisdom](https://try.cloudwisdom.virtana.com/).
1. Click Datasources in the user profile menu.
1. Click the Docker card, give the datasource a name, and click Generate.

### Running the Docker Agent
The only necessary configuration is the hostname and your API key (generated in CloudWisdom).  You can run the agent with the following command:

    docker run -d --name netuitive-agent -e DOCKER_HOSTNAME="my-docker-host" -e APIKEY="my-api-key" -v /proc:/host_proc:ro -v /var/run/docker.sock:/var/run/docker.sock:ro netuitive/docker-agent

#### Running the Docker Agent with the CloudWisdom StatsD server
Similar to the above command, but this command enables the CloudWisdom StatsD server that's packaged with the CloudWisdom Agent:

    docker run -d -p 8125:8125/udp --name netuitive-agent -e DOCKER_HOSTNAME="my-docker-host" -e APIKEY="my-api-key" -v /proc:/host_proc:ro -v /var/run/docker.sock:/var/run/docker.sock:ro netuitive/docker-agent

#### Using a Local Configuration File<a name="local-config-link"></a>
You can pass a local configuration to the Docker agent to enable new collectors, change the Hostname, reconfigure collectors, and more. This uses a similar command to the above, but requires some minor setup first:

1. Create a directory to hold the netuitive-agent.conf file.

        mkdir <someplace to put netuitive-agent.conf in it>

1. Copy the netuitive-agent.conf file from the project (assuming you've checked it out) to the directory you created in step 1.

        cp netuitive-agent.conf <confdir you created in the first step>

1. Run the agent with the following command:

        docker run -d --name netuitive-agent -v <local conf dir with netuitive-agent.conf>:/opt/netuitive-agent/conf -v /proc:/host_proc:ro -v /var/run/docker.sock:/var/run/docker.sock:ro -e USE_LOCAL_CONFIG=true netuitive/docker-agent

### Building the Docker Container

    docker build --rm=true -t netuitive-agent .

Configuration
--------------

### Environment Variables
The agent has support for the following environment variables:

| Variable Name | Description | Example |
|:---------------:|-------------|---------|
| `LOGLEVEL` | Changes the log level of the agent. | `-e LOGLEVEL=DEBUG` would set the agent to log at the DEBUG level. |
| `INTERVAL` | Interval (in seconds) in which the agent collectors run. | `-e INTERVAL=120` would set the interval to two minutes. |
| `DOCKER_HOSTNAME` | Hostname of the docker host. | `-e DOCKER_HOSTNAME="my-docker-host"` would set the hostname to <i>my-docker-host</i>. |
| `APIKEY` | The API key used to send data to Netuitive. | `e APIKEY=myapikey` would set the API key to <i>myapikey</i>. |
| `USE_LOCAL_CONFIG` | Setting used to tell the agent to ignore any environment variables set and to use a local configuration file. See [Using a Local Configuration File](#local-config-link) above. | `-e USE_LOCAL_CONFIG=true` would enable this feature|
| `LPRT` | Setting used to tell the Netuitive StatsD server what UDP port to listen on. The default is <i>8125</i>. | |
| `FORWARD` | Setting used to enable forwarding from the Netuitive StatsD Server to another StatsD Server. | |
| `FIP` | Setting used to tell the StatsD agent what IP to forward to. | |
| `FPRT` | Setting used to tell the StatsD agent what port to forward to. The default is <i>8125</i>. | |
| `TAGS` | Add a comma delimited list of tags to add to the agent. Tags should be of the form <b>key:value</b> (e.g. <b>key1:value1, key2:value2</b>). The default is no tags. | |
| `HTTPVAR` | Sets the protocol | http or https |
| `APIHOST` | The API hostname to send metrics to. Default: api.app.netuitive.com | |
| `APIURL` | Sets the full API url. If povided it will override the HTTPVAR and APIHOST variables | https://api.app.netuitive.com/ingest/infrastructure |
| `LIP` | Sets the listening IP. Default: 0.0.0.0 | |

### Adding Collectors
To configure other collectors, you will need to pass a configuration file with the updated configuration.  See [Using a Local Configuration File](#local-config-link) above.

Alternatively

To configure collectors you can pass in the collector by environment variables. For example, ElasticSearchCollector.conf has the following keys available for configuration (enabled, logstash_mode, cluster, metrics_blacklist). To configure these keys you can pass in environment variables:

    COLLECTOR_ELASTICSEARCH_ENABLED=True
    COLLECTOR_ELASTICSEARCH_LOGSTASH__MODE="true"
    COLLECTOR_ELASTICSEARCH_CLUSTER="true"
    COLLECTOR_ELASTICSEARCH_METRICS__BLACKLIST="^indices\.(?!_all\.|datastore\.|docs\.).*"

Note the double `_` in LOGSTASH__MODE and METRICS__BLACKLIST. Use the double `_` to have it remain in the key name (logstash_mode, metrics_blacklist)
