#!/bin/bash
# Generate project configs before running commands
set -e

if [ x"${VHOSTS}" != x"" ]; then
  # parsing stuff with read can have its downsides
  # always check your input values and generated configs in case of any issues
  # we expect comma-separated,key=value dict here
  # e.g. VHOSTS="www.host1.com=service1,www.host2.com=service2"
  IFS=',' read -ra HOSTS_LIST <<< "$VHOSTS"
  for elem in "${HOSTS_LIST[@]}"; do
    IFS='=' read -r FQDN PROXIED_SERVICE <<< "$elem"
    export FQDN
    export PROXIED_SERVICE
    envsubst < /etc/nginx/conf.d/project.conf.tmpl > /etc/nginx/conf.d/"${FQDN}".conf
  done
else
  # Backward compatibility, single virtual host
  # (assuming FQDN/PROXIED_SERVICE are set)
  envsubst < /etc/nginx/conf.d/project.conf.tmpl > /etc/nginx/conf.d/project.conf
fi

exec "$@"