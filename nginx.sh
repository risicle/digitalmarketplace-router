#!/bin/bash

if [[ $DM_MODE == 'maintenance' ]]; then
    templates="maintenance healthcheck"
else
    templates="api assets www healthcheck"
fi

for template in $templates; do
    echo "Compiling $template" >&2
    /app/render-template.py /app/templates/$template.j2 > /etc/nginx/sites-enabled/$template.conf
done

exec /usr/sbin/nginx
