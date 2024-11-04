#!/bin/sh

BIND_PORT=${PORT:-5984}
cat <<EOF > /opt/couchdb/etc/local.ini
[chttpd]
port = ${BIND_PORT}
bind_address = 0.0.0.0
[admins]
admin = ${ADMIN_PASSWORD}
EOF

chown -R couchdb:couchdb /opt/couchdb

su - couchdb /opt/couchdb/bin/couchdb "$@"
