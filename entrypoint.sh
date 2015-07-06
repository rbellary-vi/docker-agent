#!/bin/bash
set -e
echo "=> Configuring Netuitive Agent"

cat /etc/diamond/netuitive-agent.conf.tpl|sed -e "s/https/${HTTPVAR}/g"|sed -e "s/INFO/${LOGLEVEL}/g"|sed -e "s/interval\ =\ 60/interval\ =\ ${INTERVAL}/g"|sed -e "s/<custom\ datasource\ api\ key>/${APIKEY}/g"|sed -e "s/api\.app\.netuitive\.com/${APIHOST}/g"|sed -e "s/# hostname = my_custom_hostname/hostname = ${DOCKER_HOSTNAME}/g" > /etc/diamond/netuitive-agent.conf

chmod 644 /etc/diamond/netuitive-agent.conf

cat /usr/local/lib/python2.7/site-packages/diamond/utils/log.py.tpl|sed -e "s/logging\.DEBUG/logging\.${LOGLEVEL}/g" > /usr/local/lib/python2.7/site-packages/diamond/utils/log.py

echo "=> Done!"


/usr/local/bin/python2.7 /usr/local/bin/diamond --skip-pidfile --configfile=/etc/diamond/netuitive-agent.conf --log-stdout --foreground
