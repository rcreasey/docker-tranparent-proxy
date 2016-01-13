FROM centos:7

ENV SQUID_CACHE_DIR=/var/cache/squid \
    SQUID_SSL_DIR=/var/lib/ssl_db \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_USER=squid
    
RUN yum update -y && yum install -y squid openssl

COPY t1.key /etc/squid/t1.key
COPY t1.pem /etc/squid/t1.pem
COPY squid.conf /etc/squid/squid.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

EXPOSE 3128/tcp 3129/tcp
VOLUME ["${SQUID_CACHE_DIR}"]
ENTRYPOINT ["/entrypoint.sh"]
