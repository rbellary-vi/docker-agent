#!/bin/bash
set -e
echo "=> Configuring Netuitive Agent"

cat /opt/netuitive-agent/conf/netuitive-agent.conf.tpl|sed -e "s/https/${HTTPVAR}/g"|sed -e "s/INFO/${LOGLEVEL}/g"|sed -e "s/interval\ =\ 60/interval\ =\ ${INTERVAL}/g"|sed -e "s/<custom\ datasource\ api\ key>/${APIKEY}/g"|sed -e "s/api\.app\.netuitive\.com/${APIHOST}/g"|sed -e "s/# hostname = my_custom_hostname/hostname = ${DOCKER_HOSTNAME}/g" > /opt/netuitive-agent/conf/netuitive-agent.conf

chmod 644 /opt/netuitive-agent/conf/netuitive-agent.conf

cat /opt/netuitive-agent/embedded/lib/python2.7/site-packages/diamond/utils/log.py.tpl|sed -e "s/logging\.DEBUG/logging\.${LOGLEVEL}/g" > /opt/netuitive-agent/embedded/lib/python2.7/site-packages/diamond/utils/log.py

echo "=> Done!"

export SENSORS_LIB=/opt/netuitive-agent/embedded/lib/libsensors.so

/opt/netuitive-agent/embedded/bin/python /opt/netuitive-agent/bin/netuitive-agent --configfile=/opt/netuitive-agent/conf/netuitive-agent.conf --log-stdout --foreground
