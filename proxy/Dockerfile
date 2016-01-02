FROM phusion/baseimage
MAINTAINER rcreasey@blizzard.com

ENV SQUID_VERSION=3.3.8 \
    SQUID_CACHE_DIR=/var/cache/squid3 \
    SQUID_LOG_DIR=/var/log/squid3 \
    SQUID_USER=proxy

RUN apt-get update && \
    apt-get install -y devscripts build-essential fakeroot libssl-dev && \
    DEBIAN_FRONTEND=noninteractive apt-get source squid3 && \
    apt-get build-dep -y squid3
    
RUN dpkg-source -x squid3_3.3.8-1ubuntu6.4.dsc
 
ADD rules.patch /squid3-rules.patch
RUN patch squid3-3.3.8/debian/rules < squid3-rules.patch
RUN cd squid3-3.3.8 && dpkg-buildpackage -rfakeroot -b
RUN apt-get install -y ssl-cert squid-langpack
RUN dpkg --install squid3-common_3.3.8-1ubuntu6.4_all.deb && \
    dpkg --install squid3_3.3.8-1ubuntu6.4_amd64.deb && \
    dpkg --install squidclient_3.3.8-1ubuntu6.4_amd64.deb

RUN /usr/lib/squid3/ssl_crtd -c -s /var/spool/squid3_ssldb && \
    chown -R proxy:proxy /var/spool/squid3_ssldb

RUN rm -rf /squid*

RUN openssl req -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 \
    -out /etc/ssl/certs/squid.pem \
    -keyout /etc/ssl/private/squid.pem \
    -subj "/C=US/ST=California/L=Irvine/O=Blizzard Entertainment/CN=www.battle.net"

COPY squid.conf /etc/squid3/squid.conf
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3128/tcp 3129/tcp

VOLUME ["${SQUID_CACHE_DIR}"]
ENTRYPOINT ["/sbin/entrypoint.sh"]
