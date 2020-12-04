#!/bin/sh
set -ex

echo "Running setup.sh"

echo "Creating schema ..."
mysql -uroot -p$MYSQL_ROOT_PASSWORD < /opt/proteus-lobsters/schema-lobsters.sql

echo "Loading data ..."
mysql -uroot -p$MYSQL_ROOT_PASSWORD proteus_lobsters_db < /opt/proteus-lobsters/large_nocom-mv.sql

echo "Done ..."
