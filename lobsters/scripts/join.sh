#!/bin/bash

set -x

docker run -d --rm --name join --network test_net \
	-e MYSQL_PASSWORD=verySecrectQPUPwd \
	--volume $HOME/volume/configs:/configs \
	--volume $HOME/volume/delay.sh:/delay.sh \
	-p 50350:50350 \
	--cap-add=NET_ADMIN \
	127.0.0.1:5000/proteus:$TAG_QPU /configs/join-stories.toml error
