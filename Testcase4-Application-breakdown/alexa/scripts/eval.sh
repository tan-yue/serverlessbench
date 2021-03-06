#!/bin/bash

# this script should be executed in parent directory of scripts
if [ -z "$SERVERLESSBENCH_HOME" ]; then
    echo "$0: ERROR: SERVERLESSBENCH_HOME environment variable not set"
    exit
fi

source $SERVERLESSBENCH_HOME/eval-config

result=eval-result.log
rm -f $result 

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "1. measuring cold-invoke..."
$SCRIPTS_DIR/run-single.sh -m cold -t $cold_loop -r $result

echo "2. measuring warm-inovke..."
$SCRIPTS_DIR/run-single.sh -m warm -t $warm_loop -w $warm_warmup -r $result

echo "3. measuring concurrent invoking..."
python3 $SCRIPTS_DIR/run.py $concurrent_client $concurrent_loop $concurrent_warmup

echo "alexa application running result: "
cat $result
