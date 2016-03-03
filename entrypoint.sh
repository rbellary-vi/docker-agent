#!/bin/bash
set -e
echo "Copying configs in place..."
find /conf -name '*.*' -exec cp {} /opt/netuitive-agent/conf \;

if [[ ! $USE_LOCAL_CONFIG ]]; then
	# if we don't already have a config file, copy over template (assume ENV variables will further config)
	if [[ ! -r /opt/netuitive-agent/conf/netuitive-agent.conf ]]; then
		echo "No config file found, copying over template file..."
		cp /opt/netuitive-agent/conf/netuitive-agent.conf.tpl /opt/netuitive-agent/conf/netuitive-agent.conf
	else
		echo "Found config file in /opt/netuitive-agent/conf/netuitive-agent.conf file, using..."
	fi

	echo "Checking for environment variable overrides..."
	if [[ $APIKEY ]]; then
		sed -i -e "s/<datasource\ api\ key>/${APIKEY}/g" /opt/netuitive-agent/conf/netuitive-agent.conf
		echo "Configuring APIKEY with $APIKEY"
	fi

	if [[ $HTTPVAR ]]; then
		sed -i -e "s/https/${HTTPVAR}/g" /opt/netuitive-agent/conf/netuitive-agent.conf
		echo "Configuring HTTPVAR with $HTTPVAR"
	fi

	if [[ $LOGLEVEL ]]; then
		sed -i -e "s/INFO/${LOGLEVEL}/g" /opt/netuitive-agent/conf/netuitive-agent.conf
		echo "Configuring loglevel with $LOGLEVEL"
	fi

	if [[ $INTERVAL ]]; then
		sed -i -e "s/interval\ =\ 60/interval\ =\ ${INTERVAL}/g" /opt/netuitive-agent/conf/netuitive-agent.conf
		echo "Configuring interval with $INTERVAL"
	fi

	if [[ $APIHOST ]]; then
		sed -i -e "s/api\.app\.netuitive\.com/${APIHOST}/g" /opt/netuitive-agent/conf/netuitive-agent.conf
		echo "Configuring APIHOST with $APIHOST"
	fi

	if [[ $DOCKER_HOSTNAME ]]; then
		sed -i -e "s/# hostname = my_custom_hostname/hostname = ${DOCKER_HOSTNAME}/g" /opt/netuitive-agent/conf/netuitive-agent.conf
		echo "Configuring HOSTNAME with $DOCKER_HOSTNAME"
	fi
fi

chmod 644 /opt/netuitive-agent/conf/netuitive-agent.conf

cat /opt/netuitive-agent/embedded/lib/python2.7/site-packages/diamond/utils/log.py.tpl|sed -e "s/logging\.DEBUG/logging\.${LOGLEVEL}/g" > /opt/netuitive-agent/embedded/lib/python2.7/site-packages/diamond/utils/log.py
export SENSORS_LIB=/opt/netuitive-agent/embedded/lib/libsensors.so

echo "=> Done!"
/opt/netuitive-agent/embedded/bin/python /opt/netuitive-agent/bin/netuitive-agent --configfile=/opt/netuitive-agent/conf/netuitive-agent.conf --log-stdout --foreground
