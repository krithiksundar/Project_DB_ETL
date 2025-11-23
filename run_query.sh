#!/bin/bash
set -euo pipefail
set -x

# First, load environment variables
source tnsdetails.env

# Now you can safely reference them
echo "DB_USER=$DB_USER"
echo "DB_TNS=$DB_TNS"
echo "DB_PASS=${DB_PASS:0:4}****"

echo "Connecting to Oracle and executing query..."
> output.txt

# Run sqlplus and capture errors
if ! sqlplus "$DB_USER/$DB_PASS@$DB_TNS" <<EOF >> output.txt 2>&1
SET HEADING OFF
SET FEEDBACK OFF
SET PAGESIZE 0
@query.sql
EXIT
EOF
then
    echo "ERROR: SQL*Plus failed to connect or execute the query!"
    echo "----- SQL Output Start -----"
    cat output.txt
    echo "----- SQL Output End -----"
    exit 1
fi

# Print results if successful
echo "----- SQL Output Start -----"
cat output.txt
echo "----- SQL Output End -----"
echo "Query executed successfully. Results saved to output.txt"

