#!/bin/bash

set -x

docker run -d --rm --name dsdriver --network test_net \
	-e MYSQL_PASSWORD=verySecrectQPUPwd \
	--volume $HOME/volume/configs:/configs \
	-p 50150:50150 \
	--cap-add=NET_ADMIN \
	127.0.0.1:5000/proteus:$TAG_QPU /configs/dsdriver.toml error
