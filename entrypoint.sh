#!/bin/bash
set -e
echo "Configuring..."

if [[ ! $USE_LOCAL_CONFIG ]]; then

	sed -i -e "s/api_key\ =\ <datasource api key>/api_key = ${APIKEY}/g" /opt/netuitive-agent/conf/netuitive-agent.conf
	echo "Configuring APIKEY with $APIKEY"

	sed -i -e "s/https/${HTTPVAR}/g" /opt/netuitive-agent/conf/netuitive-agent.conf
	echo "Configuring HTTPVAR with $HTTPVAR"

	sed -i -e "s/level\ =\ INFO/level\ =\ ${LOGLEVEL}/g" /opt/netuitive-agent/conf/netuitive-agent.conf
	echo "Configuring loglevel with $LOGLEVEL"

	sed -i -e "s/level\ =\ DEBUG/level\ =\ ${LOGLEVEL}/g" /opt/netuitive-agent/conf/netuitive-agent.conf
	echo "Configuring loglevel with $LOGLEVEL"

	sed -i -e "s/interval\ =\ 60/interval\ =\ ${INTERVAL}/g" /opt/netuitive-agent/conf/netuitive-agent.conf
	echo "Configuring interval with $INTERVAL"

	sed -i -e "s/api\.app\.netuitive\.com/${APIHOST}/g" /opt/netuitive-agent/conf/netuitive-agent.conf
	echo "Configuring APIHOST with $APIHOST"

	sed -i -e "s/# hostname\ =\ my_custom_hostname/hostname\ =\ ${DOCKER_HOSTNAME}/g" /opt/netuitive-agent/conf/netuitive-agent.conf
	echo "Configuring HOSTNAME with $DOCKER_HOSTNAME"


	sed -i -e "s/# listen_ip\ =\ 127.0.0.1/listen_ip\ =\ ${LIP}/g" /opt/netuitive-agent/conf/netuitive-agent.conf
	echo "Configuring LISTEN_IP with $LIP"

	sed -i -e "s/# listen_port\ =\ 8125/listen_port\ =\ ${LPRT}/g" /opt/netuitive-agent/conf/netuitive-agent.conf
	echo "Configuring LISTEN_PORT with $LPRT"

	sed -i -e "s/# forward_ip\ =\ 127.0.0.1/forward_ip\ =\ ${FIP}/g" /opt/netuitive-agent/conf/netuitive-agent.conf
	echo "Configuring FORWARD_IP with $FIP"

	sed -i -e "s/# forward_port\ =\ 9125/forward_port\ =\ ${FPRT}/g" /opt/netuitive-agent/conf/netuitive-agent.conf
	echo "Configuring FORWARD_PORT with $FPRT"

	sed -i -e "s/#forward\ =\ False/forward\ =\ ${FORWORD}/g" /opt/netuitive-agent/conf/netuitive-agent.conf
	echo "Configuring FORWARD with $FORWARD"

	sed -i -e "s/enabled\ =\ False/enabled = True/g" /opt/netuitive-agent/conf/netuitive-agent.conf
	echo "Configuring StatsD server"

	sed -i -e "s/'midnight', 1, 7)/'d', 365, 1)/g" /opt/netuitive-agent/conf/netuitive-agent.conf
	echo "Configuring StatsD server"

fi

# make logs go to stdout for docker
ln -sf /proc/1/fd/1 /opt/netuitive-agent/log/netuitive-agent.log
ln -sf /proc/1/fd/1 /opt/netuitive-agent/log/netuitive-statsd.log
ln -sf /proc/1/fd/1 /opt/netuitive-agent/log/supervisord.log

echo "Starting Services..."

export SENSORS_LIB=/opt/netuitive-agent/embedded/lib/libsensors.so
/opt/netuitive-agent/embedded/bin/python /opt/netuitive-agent/bin/netuitive-agent --foreground --configfile /opt/netuitive-agent/conf/netuitive-agent.conf&

/opt/netuitive-agent/embedded/bin/netuitive-statsd --foreground --configfile /opt/netuitive-agent/conf/netuitive-agent.conf start
