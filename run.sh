#!/bin/bash

## runs the python file interpretter.py and passes args

if [ $# -ne 2 ]
  then
    echo "Wrong number of arguments!\n"
    echo "Usage: ./run.sh <path to intermediate code file> <main function args>\n"
    exit 1
fi


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
COMMAND="python $DIR/src/interpretter.py $*"
eval "$COMMAND"
