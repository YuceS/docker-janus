FROM amazonlinux:latest
# file maintainer author
MAINTAINER yuce sungur <deney.io.ys@gmail.com>
# docker build environments
ENV CONFIG_PATH="/opt/janus/etc/janus"
RUN  amazon-linux-extras install epel
RUN \
    yum install deltarpm -y \
    && yum install git mlocate gcc gcc-c++ libtool autoconf automake doxygen graphviz cmake  -y \ 
    && yum install glib2-devel -y \
    && yum install pkgconfig -y \
RUN \    
    yum install gengetopt  -y \ 
    && yum install jansson-devel -y \
    && yum install libconfig-devel -y \
    && yum install libnice-devel -y \
RUN  \
    yum install openssl-devel -y \
    && yum install libmicrohttpd-devel -y \
    && yum install libwebsockets-devel -y \
    && yum install paho-c-devel -y \
RUN \
    yum install opus-devel -y \
    && yum install libogg-devel -y \
    && yum install libcurl-devel -y \
RUN \    
    yum install lua-devel -y \
    && yum install npm -y \
    && yum install wget -y \
    && yum install unzip -y \
    && yum install make -y \
# build libsrtp
RUN \
    cd /usr/src \
    && wget https://github.com/cisco/libsrtp/archive/v2.2.0.zip \
    && unzip v2.2.0.zip \
    && rm v2.2.0.zip \ 
    && cd libsrtp-2.2.0 \
    && ./configure --prefix=/usr --enable-openssl --libdir=/usr/lib64 \
    && make shared_library \
    && make install \
#
RUN \
    cd /usr/src \
    && git clone https://github.com/BelledonneCommunications/sofia-sip \
    && cd sofia-sip \
    && sh autogen.sh \
    && ./configure --prefix=/usr --libdir=/usr/lib64 \
    && make \
    && make install \
#
RUN \
    cd /usr/src \
    && git clone https://github.com/sctplab/usrsctp \
    && cd usrsctp \
    && ./bootstrap \
    && ./configure --prefix=/usr --libdir=/usr/lib64 \
    && make \
    && make install \
# build janus-gateway
RUN \
    cd /usr/src \
    && git clone https://github.com/meetecho/janus-gateway.git \
    && cd janus-gateway \
    && sh autogen.sh \
    && ./configure --prefix=/opt/janus --disable-rabbitmq --disable-nanomsg \
    && make \
    && make install \
    && make configs
USER janus
CMD ["/opt/janus/bin/janus"]
