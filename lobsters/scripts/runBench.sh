#!/bin/bash

set -ex

. runBench.functions
. runBench.config

tag_datastore=$1
tag_qpu=$2
system=$3

if [ "$#" -ne 3 ] ; then
    echo "Expecting 3 arguments"
    exit 1
    fi

proteus_dir=$HOME/go/proteus
eval_dir=$HOME/proteus-evaluation/lobsters
bench_dir=$HOME/go/proteus-lobsters-bench
bench=$bench_dir/bin/benchmark
bench_conf_dir=$bench_dir/config
deployment_dir=$eval_dir/deployments

docker stack rm qpu-graph
docker stack rm datastore-proteus
docker stack rm datastore-mv

if [ $system == "mysql" ] ; then
	bench_conf=$bench_conf_dir/config-mysql.toml
  	deployment=$deployment_dir/datastore-mv.yml
	datastore_stack=datastore-mv
fi

if [ $system == "proteus" ] ; then
	bench_conf=$bench_conf_dir/config-proteus.toml
  	deployment=$deployment_dir/datastore-proteus.yml
	datastore_stack=datastore-proteus
fi

sync

docker network create -d overlay --attachable proteus_net || true

build

for ((i = 0; i < ${#runParams[@]}; i++)) ; do

	set -- ${runParams[$i]}

	logfile=$(timestamp_filename).txt

	echo "Timestamp: $(timestamp)" > /tmp/$logfile
	echo "Datastore image tag : $tag_datastore" >> /tmp/$logfile
	echo "Proteus image tag : $tag_qpu" >> /tmp/$logfile

	env TAG_DATASTORE=$tag_datastore docker stack deploy --compose-file $deployment $datastore_stack

	wait_services_running
	sleep 10

	if [ $system == "proteus" ] ; then
		env TAG_DATASTORE=$tag_datastore env TAG_QPU=$tag_qpu docker stack deploy --compose-file $deployment_dir/qpu-graph.yml qpu-graph
		wait_services_running
		sleep 10
	fi

	$eval_dir/scripts/utils/getPlacement.sh >> /tmp/$logfile

	$bench -c $bench_conf -l $1 --fr $2 --fw $3 -t $4 >> /tmp/$logfile

	curl -u $NUAGE_LIP6_U:$NUAGE_LIP6_P -T /tmp/$logfile https://nuage.lip6.fr/remote.php/dav/files/$NUAGE_LIP6_U/proteus_bench_logs/$logfile

 	if [ $system == "proteus" ] ; then
		docker stack rm qpu-graph
	fi

	docker stack rm $datastore_stack

	sleep 10
done
