#!/bin/bash

set -ex

. runBench.functions
. runBench.config

PROTEUS_DIR=$HOME/go/proteus
BENCH_DIR=$HOME/proteus-evaluation/lobsters
TAG=$1
SYSTEM=$2
bench=$HOME/go/proteus-lobsters-bench/bin/benchmark
benchConfDir=$PROTEUS_DIR/pkg/lobsters-bench/config
composeFDir=$BENCH_DIR/deployments/

docker stack rm qpu-graph
docker stack rm datastore-proteus
docker stack rm datastore-mv

if [ $SYSTEM == "mysql" ] ; then
	benchConf=$benchConfDir/config-mysql.toml
  composeF=$composeFDir/datastore-mv.yml
	datastoreStack=datastore-mv
fi

if [ $SYSTEM == "proteus" ] ; then
	benchConf=$benchConfDir/config-proteus.toml
  composeF=$composeFDir/datastore-proteus.yml
	datastoreStack=datastore-proteus
fi

sync

docker network create -d overlay --attachable proteus_net || true

build

for ((i = 0; i < ${#runParams[@]}; i++))
do

	set -- ${runParams[$i]}

	logfile=$(timestamp_filename).txt

  echo "Timestamp: $(timestamp)" > /tmp/$logfile

  $bench -c $benchConf -d >> /tmp/$logfile

	env TAG_DATASTORE=$TAG docker stack deploy --compose-file $composeF $datastoreStack

	wait_services_running
	sleep 10

	if [ $SYSTEM == "proteus" ] ; then
		env TAG_DATASTORE=$TAG env TAG_QPU=$TAG docker stack deploy --compose-file $composeFDir/qpu-graph.yml qpu-graph
		wait_services_running
		sleep 10
	fi

	$BENCH_DIR/scripts/utils/getPlacement.sh >> /tmp/$logfile

	$bench -c $benchConf -l $1 --fr $2 --fw $3 -t $4 >> /tmp/$logfile

	curl -u $NUAGE_LIP6_U:$NUAGE_LIP6_P -T /tmp/$logfile https://nuage.lip6.fr/remote.php/dav/files/$NUAGE_LIP6_U/proteus_bench_logs/$logfile

  if [ $SYSTEM == "proteus" ] ; then
    docker stack rm qpu-graph
	fi

	docker stack rm $datastoreStack

	sleep 10
done
