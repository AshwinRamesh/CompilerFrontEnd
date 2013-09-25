#!/bin/bash

## @author Ashwin Ramesh
## This run script simply runs the python file interpretter.py and passes args

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
COMMAND="python $DIR/src/interpretter.py $*"
eval "$COMMAND"
