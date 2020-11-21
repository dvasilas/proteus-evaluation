#!/bin/bash

set -x

docker run -d --rm --name datastore --network test_net \
	-e MYSQL_ROOT_PASSWORD=verySecretPwd \
	--volume $HOME/volume/datastore/build/setup-proteus.sh:/docker-entrypoint-initdb.d/setup.sh \
	--volume $HOME/volume/datastore/dataset/small.sql:/opt/proteus-lobsters/small.sql \
	--volume $HOME/volume/datastore/dataset/med.sql:/opt/proteus-lobsters/med.sql \
	--volume $HOME/volume/datastore/build/db-schema/schema-proteus.sql:/opt/proteus-lobsters/schema-proteus.sql \
	--volume $HOME/volume/delay.sh:/delay.sh \
	-p 3307:3306 \
	-p 50000:50000 \
	--cap-add=NET_ADMIN \
	127.0.0.1:5000/proteus-lobsters:$TAG_DATASTORE
