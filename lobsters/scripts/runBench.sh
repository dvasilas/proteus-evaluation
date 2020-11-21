#!/bin/bash

set -ex

. runBench.functions
. runBench.config

tag_datastore=$1
tag_qpu=$2
system=$3
deployment=$4

if [ "$#" -ne 4 ] ; then
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
docker stop join || true
docker stop sum || true
docker stop dsdriver || true
docker stop datastore || true
docker stop bench || true

if [ $system == "mysql" ] ; then
	bench_conf=$bench_conf_dir/config-mysql.toml
  	deploymentConf=$deployment_dir/datastore-mv.yml
	datastore_stack=datastore-mv
elif [ $system == "proteus" ] ; then
	bench_conf=$bench_conf_dir/config-proteus.toml
  	deploymentConf=$deployment_dir/datastore-proteus.yml
	datastore_stack=datastore-proteus
else
	echo "Expecting either 'proteus' or 'mysql' as 'system' argument"
	exit 1

fi

sync

docker network create -d overlay --attachable proteus_net || true

docker network create --attachable test_net || true

for ((i = 0; i < ${#runParams[@]}; i++)) ; do

	set -- ${runParams[$i]}

	logfile=$(timestamp_filename).txt

	echo "Timestamp: $(timestamp)" > /tmp/$logfile
	echo "Datastore image tag : $tag_datastore" >> /tmp/$logfile
	echo "Proteus image tag : $tag_qpu" >> /tmp/$logfile

	if [ $deployment == "swarm" ] ; then
		env TAG_DATASTORE=$tag_datastore docker stack deploy --compose-file $deploymentConf $datastore_stack
		wait_services_running
	elif [ $deployment == "local" ] ; then
		env TAG_DATASTORE=$tag_datastore ./datastore.sh
	else
		echo "Expecting either 'swarm' or 'local' as 'deployment' argument"
		exit 1
	fi
	sleep 10

	if [ $system == "proteus" ] ; then
		if [ $deployment == "swarm" ] ; then
			env TAG_DATASTORE=$tag_datastore env TAG_QPU=$tag_qpu docker stack deploy --compose-file $deployment_dir/qpu-graph.yml qpu-graph
			wait_services_running
			$eval_dir/scripts/utils/getPlacement.sh >> /tmp/$logfile
		elif [ $deployment == "local" ] ; then
			env TAG_QPU=$tag_qpu ./dsdriver.sh
			env TAG_QPU=$tag_qpu ./sum.sh
			env TAG_QPU=$tag_qpu ./join.sh
		else
			echo "Expecting either 'swarm' or 'local' as 'deployment' argument"
			exit 1
		fi
	sleep 10
	fi

	if [ $deployment == "swarm" ] ; then
		$bench -c $bench_conf -l $1 --fr $2 --fw $3 -t $4 >> /tmp/$logfile
	elif [ $deployment == "local" ] ; then
		docker run -d --rm --name bench --network test_net --cap-add=NET_ADMIN --volume $HOME/go/proteus-lobsters-bench/config/config-proteus.toml:/config/config.toml --volume $HOME/volume/delay.sh:/delay.sh --volume /tmp:/out bench
		sleep 10
		./simulate-latency.sh bench datastore
		./simulate-latency.sh sum join
		sleep 10
		docker exec bench /app/bench/bin/benchmark -c /config/config.toml -l $1 --fr $2 --fw $3 -t $4 > /tmp/$logfile
	else
		echo "Expecting either 'swarm' or 'local' as 'deployment' argument"
		exit 1
	fi

	curl -u $NUAGE_LIP6_U:$NUAGE_LIP6_P -T /tmp/$logfile https://nuage.lip6.fr/remote.php/dav/files/$NUAGE_LIP6_U/proteus_bench_logs/$logfile
		
	if [ $deployment == "swarm" ] ; then
		docker stack rm qpu-graph
	elif [ $deployment == "local" ] ; then
		docker stop bench
		docker stop join
		docker stop sum 
		docker stop dsdriver
	else
		echo "Expecting either 'swarm' or 'local' as 'deployment' argument"
		exit 1
	fi

	if [ $deployment == "swarm" ] ; then
		docker stack rm $datastore_stack
	elif [ $deployment == "local" ] ; then
		docker stop datastore
	else
		echo "Expecting either 'swarm' or 'local' as 'deployment' argument"
		exit 1
	fi

	sleep 10
done
