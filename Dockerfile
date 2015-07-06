# VERSION               0.0.1
# DESCRIPTION:    Netuitive-agent in a container
# MAINTAINER Netuitive <repos@netuitive.com>

FROM      centos:6

# environment variable defaults
ENV APIKEY apikey
ENV APIHOST api.app.netuitive.com
ENV INTERVAL 60
ENV DOCKER_HOSTNAME docker-hostname
ENV LOGLEVEL WARN
ENV HTTPVAR https

# install updates and build tools
RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && yum -y update && yum -y groupinstall 'development tools' && yum -y install zlib-dev openssl-devel sqlite-devel bzip2-devel xz-libs wget tar

# install python 2.7
RUN mkdir /tmp/pyi && cd /tmp/pyi && wget -O - https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tgz | tar zxf - && cd Python-2.7.10  && ./configure --prefix=/usr/local && make && make altinstall && curl https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py | python2.7 -

# install python modules
RUN pip2.7 install docker-py netuitive configobj simplejson pyutmp setproctitle psutil boto

# install Diamond
RUN mkdir /tmp/n && cd /tmp/n && git clone https://github.com/Netuitive/Diamond.git && cd /tmp/n/Diamond && python2.7 setup.py install && rm -rf /etc/diamond/diamond.conf.example* && rm -rf /etc/init.d/diamond && find /usr/local/share/diamond/collectors/  -type f -name "*.py" -print0 | xargs -0 sed -i 's/\/proc/\/host_proc/g'

# install Netuitive Diamond Handler
RUN cd /tmp/n && git clone https://github.com/Netuitive/omnibus-netuitive-agent.git && cp /tmp/n/omnibus-netuitive-agent/netuitive/src/handler/netuitive_cloud.py /usr/local/lib/python2.7/site-packages/diamond/handler/ && cp /usr/local/lib/python2.7/site-packages/diamond/utils/log.py /usr/local/lib/python2.7/site-packages/diamond/utils/log.py.tpl && mkdir -p /opt/netuitive-agent && mkdir -p /usr/local/share/diamond/collectors/netuitive
ADD version-manifest.txt /opt/netuitive-agent/version-manifest.txt
ADD netuitive_docker.py /usr/local/share/diamond/collectors/netuitive/
ADD netuitive-agent.conf /etc/diamond/netuitive-agent.conf.tpl

# cleanup
RUN rm -rf /tmp/pyi && rm -rf /tmp/n && rm -rf /root/.cache && rpm -e autoconf automake bison byacc cscope ctags cvs diffstat doxygen elfutils flex gcc gcc-c++ gcc-gfortran gettext git indent intltool libtool patch patchutils rcs redhat-rpm-config rpm-build subversion swig systemtap alsa-lib apr apr-util atk avahi-libs bzip2 cairo cloog-ppl cpp cups-libs elfutils-libs file fipscheck fipscheck-lib fontconfig freetype gdb gdk-pixbuf2 gettext-devel gettext-libs glibc-devel glibc-headers gnutls gtk2 hicolor-icon-theme jasper-libs kernel-devel kernel-headers libICE libSM libX11 libX11-common libXau libXcomposite libXcursor libXdamage libXext libXfixes libXft libXi libXinerama libXrandr libXrender libXtst libart_lgpl libedit libgcj libgfortran libgomp libjpeg-turbo libpng libproxy libproxy-bin libproxy-python libstdc++-devel libthai libtiff libxcb m4 mailcap mpfr neon openssh openssh-clients pakchois pango perl perl-Git perl-Compress-Raw-Zlib perl-Compress-Zlib perl-Error perl-HTML-Parser perl-HTML-Tagset perl-IO-Compress-Base perl-IO-Compress-Zlib perl-Module-Pluggable perl-Pod-Escapes perl-Pod-Simple perl-URI perl-XML-Parser perl-libs perl-libwww-perl perl-version pixman ppl rsync systemtap-client systemtap-devel systemtap-runtime unzip xz xz-lzma-compat zip && yum --setopt=groupremove_leaf_only=1 groupremove 'Development Tools' && yum clean all


# startup script
ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

#start
ENTRYPOINT ["/entrypoint.sh"]
