#!/bin/bash
set -e

create_log_dir() {
  mkdir -p ${SQUID_LOG_DIR}
  chmod -R 755 ${SQUID_LOG_DIR}
  chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_LOG_DIR}
}

create_cache_dir() {
  mkdir -p ${SQUID_CACHE_DIR}
  chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_CACHE_DIR}
}

create_ssl_db() {
  /usr/lib64/squid/ssl_crtd -c -s ${SQUID_SSL_DIR}
  chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_SSL_DIR}
}

create_log_dir
create_cache_dir
create_ssl_db

# allow arguments to be passed to squid
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == squid ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

# default behaviour is to launch squid
if [[ -z ${1} ]]; then
  if [[ ! -d ${SQUID_CACHE_DIR}/00 ]]; then
    echo "Initializing cache..."
    squid -N -f /etc/squid/squid.conf -z
  fi
  echo "Using this Certificate Authority:"
  cat /etc/squid/t1.pem
  echo "Starting squid..."
  exec squid -f /etc/squid/squid.conf -NYCd 1 ${EXTRA_ARGS}
else
  exec "$@"
fi
