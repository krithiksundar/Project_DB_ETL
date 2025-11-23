#!/bin/bash
set -euo pipefail
set -x

# First, load environment variables
source tnsdetails.env

CONN_STR="$DB_USER/$DB_PASS@//$DB_HOST:$DB_PORT/$DB_SERVICE"

echo "192.168.0.107 sidb sidb.localdomain" >> /etc/hosts

> output.txt
echo > /dev/tcp/192.168.0.107/1521 && echo "Port open" || echo "Port closed"

echo "Testing Oracle DB connection..."
echo "--------------------------------"

timeout 240 sqlplus "$CONN_STR" <<EOF >> output.txt 2>&1
@query.sql
EXIT;
EOF

echo "--------------------------------"
echo "Done"