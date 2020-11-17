#!/bin/bash

set -ex

. runBench.functions
. runBench.config

PROTEUS_DIR=$HOME/go/proteus
BENCH_DIR=$HOME/proteus-evaluation/lobsters
SHEET_ID=$2
ROW=$3
RESULT_DIR=$4

export CREDENTIAL_FILE=$1
export SPREADSHEET_ID=14LnCB-ToJ6hduF-yDpEbeRkWF-M2ywnakdEqig5Tv78
export SHEET_ID=$SHEET_ID

for filename in "$RESULT_DIR"/*
do
  echo $filename
  ./utils/format-and-import.py -r $ROW --desc template-config
  ROW=$((ROW+1))

  ./utils/format-and-import.py -r $ROW --desc template-run
  ROW=$((ROW+1))

  ./utils/format-and-import.py -r $ROW template-run $filename
  ROW=$((ROW+1))
done