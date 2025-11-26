#!/bin/sh

BIND_PORT=${PORT:-5984}
cat <<EOF > /opt/couchdb/etc/local.ini
[couchdb]
single_node = true
[chttpd]
port = ${BIND_PORT}
bind_address = 0.0.0.0
[admins]
admin = ${ADMIN_PASSWORD}
[log]
level = warning
EOF

chown -R couchdb:couchdb /opt/couchdb

su - couchdb /opt/couchdb/bin/couchdb "$@"
