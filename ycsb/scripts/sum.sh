#!/bin/bash

set -x

docker run -d --rm --name sum --network test_net \
	-e MYSQL_PASSWORD=verySecrectQPUPwd \
	--volume $HOME/volume/configs:/configs \
	--volume $HOME/volume/delay.sh:/delay.sh \
	-p 50250:50250 \
	--cap-add=NET_ADMIN \
	127.0.0.1:5000/proteus:$TAG_QPU /configs/sum-stories.toml error
