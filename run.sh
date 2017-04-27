#!/bin/sh

AUTH_FILE="./nginx/conf/.htpasswd"

if [ -n "${AUTH_USERNAME}" -a -n "${AUTH_PASSWORD}" ]; then
  echo "${AUTH_USERNAME}:$(openssl passwd -apr1 "${AUTH_PASSWORD}")" >> "${AUTH_FILE}"
fi

if [ ! -f "${AUTH_FILE}" ]; then
  echo "No htaccess auth file found. Either create Staticfile.auth in the project root, or set AUTH_USERNAME and AUTH_PASSWORD env vars" >&2
  exit 1
fi

cat < $APP_ROOT/nginx/logs/access.log &
(>&2 cat) < $APP_ROOT/nginx/logs/error.log &
exec $APP_ROOT/nginx/sbin/nginx -p $APP_ROOT/nginx -c $APP_ROOT/nginx/conf/nginx.conf
