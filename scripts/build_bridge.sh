#!/bin/bash

set -e

DIR=${BASH_SOURCE%/*}

g++ -c ${DIR}/../cbits/bridge.cpp -o ${DIR}/../cbits/bridge.o -I${DIR}/../deps/clibspi/include -I${DIR}/../deps/clibcdc/include -I${DIR}/../deps/clibdpa/include -I${DIR}/../deps/clibdpa/Dpa -I${DIR}/../deps/clibdpa/IqrfSpiChannel -I${DIR}/../deps/clibdpa/IqrfCdcChannel -fPIC
ar rvs ${DIR}/../cbits/libbridge.a ${DIR}/../cbits/bridge.o
