# VERSION               0.2.4
# DESCRIPTION:    Netuitive-agent in a container
# MAINTAINER Netuitive <repos@netuitive.com>

FROM      centos:6

# environment variable defaults
ENV APIKEY apikey
ENV APIHOST api.app.netuitive.com
ENV INTERVAL 60
ENV DOCKER_HOSTNAME docker-hostname
ENV LOGLEVEL INFO
ENV HTTPVAR https
ENV LIP "0.0.0.0"
ENV LPRT 8125
ENV FIP "127.0.0.2"
ENV FPRT 8125
ENV FORWARD "False"

RUN  yum -y update \
  && rpm --import https://repos.app.netuitive.com/RPM-GPG-KEY-netuitive \
  && rpm -ivh https://repos.app.netuitive.com/rpm/noarch/netuitive-repo-1-0.2.noarch.rpm \
  && yum -y install netuitive-agent \
  && /sbin/chkconfig netuitive-agent off \
  && yum clean all \
  && find /var/log/ -type f -exec rm -f {} \; \
  && find /var/cache/ -type f -exec rm -f {} \;


# startup script
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

VOLUME ["/opt/netuitive-agent/conf/"]

EXPOSE 8125

ENTRYPOINT ["/entrypoint.sh"]
