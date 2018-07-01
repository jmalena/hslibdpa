#!/bin/bash

set -e

DIR=${BASH_SOURCE%/*}

g++ -c ${DIR}/../bridge/bridge.cpp -o ${DIR}/../bridge/bridge.o -I${DIR}/../deps/clibspi/include -I${DIR}/../deps/clibcdc/include -I${DIR}/../deps/clibdpa/include -I${DIR}/../deps/clibdpa/Dpa -I${DIR}/../deps/clibdpa/IqrfSpiChannel -I${DIR}/../deps/clibdpa/IqrfCdcChannel
ar rvs ${DIR}/../bridge/libbridge.a ${DIR}/../bridge/bridge.o
