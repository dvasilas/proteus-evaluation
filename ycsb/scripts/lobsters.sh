#!/bin/bash

set -x

docker run -d --rm --name lobsters --network test_net \
	-e MYSQL_PASSWORD=verySecrectQPUPwd \
	--volume $HOME/volume/configs:/configs \
	--volume $HOME/volume/delay.sh:/delay.sh \
	--cap-add=NET_ADMIN \
	127.0.0.1:5000/proteus-stateless:$TAG_QPU /configs/lobsters.toml error
