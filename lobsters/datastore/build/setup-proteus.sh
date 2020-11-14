#!/bin/sh
set -ex

echo "Running setup.sh"

echo "Creating schema ..."
mysql -uroot -p$MYSQL_ROOT_PASSWORD < /opt/proteus-lobsters/schema-proteus.sql

echo "Loading data ..."
mysql -uroot -p$MYSQL_ROOT_PASSWORD proteus_lobsters_db < /opt/proteus-lobsters/small.sql
# mysql -uroot -p$MYSQL_ROOT_PASSWORD proteus_lobsters_db < /opt/proteus-lobsters/med.sql

echo "Running server ..."
/opt/proteus-lobsters/server > /opt/proteus-lobsters/server.log &
