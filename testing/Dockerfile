# VERSION               0.0.1
# DESCRIPTION:    Netuitive-agent-test-server in a container
# MAINTAINER Netuitive <repos@netuitive.com>

FROM      centos:6

# install updates and build tools
# RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && yum -y update && yum -y groupinstall 'development tools' && yum -y install zlib-dev openssl-devel sqlite-devel bzip2-devel xz-libs wget tar

# install python 2.7
# RUN mkdir /tmp/pyi && cd /tmp/pyi && wget -O - https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tgz | tar zxf - && cd Python-2.7.10  && ./configure --prefix=/usr/local && make && make altinstall && curl https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py | python2.7 -

ADD testserver.py /tmp/testserver.py
RUN chmod 700 /tmp/testserver.py

EXPOSE 8000

#start
ENTRYPOINT ["/tmp/testserver.py"]
