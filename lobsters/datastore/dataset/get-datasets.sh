#!/bin/bash

set -ex

wget --user=$NUAGE_LIP6_U --password=$NUAGE_LIP6_P https://nuage.lip6.fr/remote.php/dav/files/dvasilas/datasets/small.sql
wget --user=$NUAGE_LIP6_U --password=$NUAGE_LIP6_P https://nuage.lip6.fr/remote.php/dav/files/dvasilas/datasets/small-mv.sql
wget --user=$NUAGE_LIP6_U --password=$NUAGE_LIP6_P https://nuage.lip6.fr/remote.php/dav/files/dvasilas/datasets/med.sql
wget --user=$NUAGE_LIP6_U --password=$NUAGE_LIP6_P https://nuage.lip6.fr/remote.php/dav/files/dvasilas/datasets/med-mv.sql
wget --user=$NUAGE_LIP6_U --password=$NUAGE_LIP6_P https://nuage.lip6.fr/remote.php/dav/files/dvasilas/datasets/large_nocom.sql
wget --user=$NUAGE_LIP6_U --password=$NUAGE_LIP6_P https://nuage.lip6.fr/remote.php/dav/files/dvasilas/datasets/large_nocom-mv.sql

