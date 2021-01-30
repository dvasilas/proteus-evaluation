#!/bin/bash

set -ex

. runBench.functions
. runBench.config

tag_qpu=$1
tag_bench=$2

proteus_dir=$HOME/go/proteus
eval_dir=$HOME/proteus-evaluation/ycsb
deployment_dir=$eval_dir/deployments

storageStack=cloudserver
queryengineStack=proteus
benchStack=ycsb

docker stack rm $benchStack || true
docker stack rm $queryengineStack || true
docker stack rm $storageStack || true

storageDeploymentConf=$deployment_dir/storage.yml
queryengineDeploymentConf=$deployment_dir/partitioned.yml
benchDeploymentConf=$deployment_dir/ycsb.yml

sync

docker network create -d overlay --attachable proteus_net || true

for ((i = 0; i < ${#runParams[@]}; i++)) ; do 
	set -- ${runParams[$i]}

	logfile=$(timestamp_filename)

cp -r ${HOME}/dataset/data0 ${HOME}/dataset/data0_run
cp -r ${HOME}/dataset/metadata0 ${HOME}/dataset/metadata0_run

ssh -tt small18 cp -r ~/volume/datastore/dataset/ycsb/data1 ~/dataset/data1_run
ssh -tt small18 cp -r ~/volume/datastore/dataset/ycsb/metadata1 ~/dataset/metadata1_run

ssh -tt small21 cp -r ~/volume/datastore/dataset/ycsb/data2 ~/dataset/data2_run
ssh -tt small21 cp -r ~/volume/datastore/dataset/ycsb/metadata2 ~/dataset/metadata2_run

docker stack deploy --compose-file $storageDeploymentConf $storageStack
wait_services_running
sleep 10

$proteus_dir/mongo/load/load

env TAG_QPU=$tag_qpu docker stack deploy --compose-file $queryengineDeploymentConf $queryengineStack
wait_services_running
sleep 10

$proteus_dir/bench/bench $1 > /tmp/$logfile.out

#env TAG_YCSB=$tag_bench env LOGFILE=$logfile env THREADS=$1 docker stack deploy --compose-file $benchDeploymentConf $benchStack
#sleep 60
#wait_service_complete ycsb_ycsb

#$eval_dir/scripts/parse.py /tmp/$logfile.txt /tmp/$logfile.out

curl -u $NUAGE_LIP6_U:$NUAGE_LIP6_P -T /tmp/$logfile.out https://nuage.lip6.fr/remote.php/dav/files/$NUAGE_LIP6_U/proteus_bench_logs/$logfile.txt
#curl -u $NUAGE_LIP6_U:$NUAGE_LIP6_P -T /tmp/$logfile.txt https://nuage.lip6.fr/remote.php/dav/files/$NUAGE_LIP6_U/proteus_bench_logs/$logfile.raw.txt

docker stack rm $benchStack || true
docker stack rm $queryengineStack || true
docker stack rm $storageStack || true

done
