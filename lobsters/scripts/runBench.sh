#!/bin/bash

set -ex

. runBench.functions 
. runBench.config 

PROTEUS_DIR=$HOME/go/proteus
BENCH_DIR=$HOME/proteus-evaluation/lobsters
TAG=$1
SHEET_ID=$2
ROW=$3
SYSTEM=$4

export CREDENTIAL_FILE=
export SPREADSHEET_ID=14LnCB-ToJ6hduF-yDpEbeRkWF-M2ywnakdEqig5Tv78
export SHEET_ID=$SHEET_ID

bench=$PROTEUS_DIR/pkg/lobsters-bench/bin/benchmark
benchConfDir=$PROTEUS_DIR/pkg/lobsters-bench/config
composeFDir=$BENCH_DIR/deployments/

if [ $SYSTEM == "mysql" ] ; then
	benchConf=$benchConfDir/config-mysql.toml
fi
if [ $SYSTEM == "proteus" ] ; then
	benchConf=$benchConfDir/config-proteus.toml
fi


if [ $SYSTEM == "mysql" ] ; then
	composeF=$composeFDir/datastore-mv.yml
	datastoreStack=datastore-mv
fi
if [ $SYSTEM == "proteus" ] ; then
	composeF=$composeFDir/datastore-proteus.yml
	datastoreStack=datastore-proteus
fi

docker stack rm qpu-graph
docker stack rm datastore-proteus
docker stack rm datastore-plain
docker stack rm datastore-mv

build

sync proteus-eu02 proteus-eu03 proteus-eu04 #proteus-na01 proteus-na02

docker network create -d overlay --attachable proteus_net || true

echo "Proteus image tag: $TAG" > /tmp/bench-config

./utils/format-and-import.py -r $ROW --desc template-config
ROW=$((ROW+1))
$bench -c $benchConf -d >> /tmp/bench-config
./utils/format-and-import.py -r $ROW template-config /tmp/bench-config
ROW=$((ROW+1))

./utils/format-and-import.py -r $ROW --desc template-run
ROW=$((ROW+1))

for ((i = 0; i < ${#runParams[@]}; i++))
do
	
	set -- ${runParams[$i]}

	logfile=$(timestamp_filename).txt
	echo "Timestamp: $(timestamp)" > /tmp/$logfile
	touch /tmp/$logfile

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


#	if [ $FRESHNESS == "dsdriver" ] ; then
#		$PROTEUS_DIR/freshness >> /tmp/$logfile
#	fi
#	if [ $FRESHNESS == "join-stories" ] ; then
#		NODE_HOST=$($PROTEUS_DIR/scripts/utils/service-exec.sh -s qpu-graph_join-stories /opt/proteus-lobsters/freshness/freshness.sh)
#		rsync -a $NODE_HOST:~/volume/scripts/ $HOME/bench/freshness
#		go run $PROTEUS_DIR/scripts/freshness.go $HOME/bench/freshness/write-log.txt $HOME/bench/freshness/query-log.txt >> /tmp/$logfile
#	fi

	./utils/format-and-import.py -r $ROW template-run /tmp/$logfile

#	curl -u $NUAGE_LIP6_U:$NUAGE_LIP6_P -T /tmp/$logfile https://nuage.lip6.fr/remote.php/dav/files/$NUAGE_LIP6_U/proteus_bench_logs/$logfile

	docker stack rm qpu-graph
	docker stack rm datastore-proteus

	sleep 10
	ROW=$((ROW+1))
done
