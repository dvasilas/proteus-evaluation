#!/bin/bash

set -xe

delay=40

ip1=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $1)
ip2=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $2)
docker exec $1 /delay.sh -i eth0 -d $ip2 -m $delay start
docker exec $2 /delay.sh -i eth0 -d $ip1 -m $delay start
