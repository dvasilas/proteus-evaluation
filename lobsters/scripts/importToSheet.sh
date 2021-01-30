#!/bin/bash

set -ex

. runBench.functions
. runBench.config

PROTEUS_DIR=$HOME/go/proteus
BENCH_DIR=$HOME/proteus-evaluation/lobsters
CREDENTIAL_FILE=$1
SHEET_ID=$2
ROW=$3
RESULT_DIR=$4
HEAD_F=$5

export CREDENTIAL_FILE
#export SPREADSHEET_ID=1OeeBC0vOM5qecenPMiiYH-2zCmaWz9BmJVEvCgtHnVc
#export SPREADSHEET_ID=14LnCB-ToJ6hduF-yDpEbeRkWF-M2ywnakdEqig5Tv78
export SPREADSHEET_ID=1HnO7VM1lsHoQ1DoTDqWPB6goeafQqgaDXRt0PpMS17U
export SHEET_ID=$SHEET_ID

  echo $filename
  ./utils/format-and-import.py -r $ROW --desc template-config
  ROW=$((ROW+1))

  utils/format-and-import.py -r $ROW template-config $HEAD_F
  ROW=$((ROW+1))

  ./utils/format-and-import.py -r $ROW --desc template-run
  ROW=$((ROW+1))

for filename in "$RESULT_DIR"/*
do
  ./utils/format-and-import.py -r $ROW template-run $filename
  ROW=$((ROW+1))
done
