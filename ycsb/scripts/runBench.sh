#!/bin/bash

set -ex

. runBench.functions
. runBench.config

tag_qpu=$1
tag_bench=$2

proteus_dir=$HOME/go/proteus
eval_dir=$HOME/proteus-evaluation/ycsb
deployment_dir=$eval_dir/deployments

storageStack=storage
queryengineStack=proteus
benchStack=ycsb

docker stack rm $benchStack || true
docker stack rm $queryengineStack || true
docker stack rm $storageStack || true

storageDeploymentConf=$deployment_dir/storage.yml
#queryengineDeploymentConf=$deployment_dir/partitioned.yml
#queryengineDeploymentConf=$deployment_dir/global.yml
queryengineDeploymentConf=$deployment_dir/globalcache.yml
benchDeploymentConf=$deployment_dir/ycsb.yml

sync

docker network create -d overlay --attachable proteus_net || true

for ((i = 0; i < ${#runParams[@]}; i++)) ; do 
	set -- ${runParams[$i]}

	logfile=$(timestamp_filename)

docker stack deploy --compose-file $storageDeploymentConf $storageStack
wait_service_running storage_mongo0
wait_service_running storage_mongo1
wait_service_running storage_mongo2
sleep 10

#$proteus_dir/mongo/load/load

env TAG_QPU=$tag_qpu docker stack deploy --compose-file $queryengineDeploymentConf $queryengineStack
wait_service_running proteus_dsdriver-0
wait_service_running proteus_dsdriver-1
wait_service_running proteus_dsdriver-2
wait_service_running proteus_index-0
wait_service_running proteus_index-1
wait_service_running proteus_index-2
wait_service_running proteus_router-0
wait_service_running proteus_router-1
wait_service_running proteus_router-2

#$proteus_dir/bench/bench $1 > /tmp/$logfile.out

env TAG_YCSB=$tag_bench env OUTPUT_FILE_NAME=$logfile env THREADS=$1 env QUERY_PROP=0.95 env UPDATE_PROP=0.05 docker stack deploy --compose-file $benchDeploymentConf $benchStack

sleep 60
wait_service_complete ycsb_ycsb-0
wait_service_complete ycsb_ycsb-1
wait_service_complete ycsb_ycsb-2

rsync small18:/tmp/QUERY_$logfile.1.hdr ${HOME}/res1
rsync small18:/tmp/UPDATE_$logfile.1.hdr ${HOME}/res1
rsync small21:/tmp/QUERY_$logfile.2.hdr ${HOME}/res2
rsync small21:/tmp/UPDATE_$logfile.2.hdr ${HOME}/res2

cp /tmp/QUERY_$logfile.0.hdr ${HOME}/res
cp /tmp/UPDATE_$logfile.0.hdr ${HOME}/res
cp ${HOME}/res1/QUERY_$logfile.1.hdr ${HOME}/res
cp ${HOME}/res1/UPDATE_$logfile.1.hdr ${HOME}/res
cp ${HOME}/res2/QUERY_$logfile.2.hdr ${HOME}/res
cp ${HOME}/res2/UPDATE_$logfile.2.hdr ${HOME}/res

docker run -ti --rm --name parse -e PREFIX=$logfile -e THREADS=$1 -v ${HOME}/res:/ycsb ycsb:parse

$eval_dir/scripts/parse.py ${HOME}/res/$logfile.txt ${HOME}/res/$logfile.out

curl -u $NUAGE_LIP6_U:$NUAGE_LIP6_P -T ${HOME}/res/$logfile.out https://nuage.lip6.fr/remote.php/dav/files/$NUAGE_LIP6_U/proteus_bench_logs/$logfile.txt
curl -u $NUAGE_LIP6_U:$NUAGE_LIP6_P -T ${HOME}/res/$logfile.txt https://nuage.lip6.fr/remote.php/dav/files/$NUAGE_LIP6_U/proteus_bench_logs/$logfile.raw.txt

docker stack rm $benchStack || true
docker stack rm $queryengineStack || true
docker stack rm $storageStack || true

sleep 10
done
